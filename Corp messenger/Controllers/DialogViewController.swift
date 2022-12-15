//
//  DialogViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 13.12.2022.
//

import UIKit

final class DialogViewController: UIViewController{
    //MARK: Storages
    private let defaults = UserDefaults.standard
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: UI Elements
    private let profileButton = UIBarButtonItem()
    
    private let inputViewBox = UIView()
    private let inputTextField = UITextView()
    private let sendButton = UIButton()
    
    private var messagesScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 2000))
    
    private var dialogId: String = ""
    private var user: User?
    private var dialog: Dialog?
    private var messages: [Message]?
    
    //MARK: - ViewController settings
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false) //сокрытие навбара
        navigationController?.navigationBar.topItem?.title = "Chats"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        
        if let user = user{
            self.navigationItem.title = (user.name ?? "") + " " + (user.surname ?? "")
            
            var temp = UIImage.convertBase64StringToImage(imageBase64String: user.imageBlob ?? "")
            temp = UIImage.cropToBounds(image: temp, width: 50, height: 50)
            
            //profileButton.image = temp
            //profileButton.customView?.clipsToBounds = true
        }
        self.navigationItem.setRightBarButton(profileButton, animated: true)
        //navigationController?.navigationBar.topItem?.setRightBarButton(profileButton, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Пример получения родительского ViewController
        if let viewController = navigationController?.parent as? ChatsViewController{
            viewController.wsSend(message: "hi")
        }
        
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    //MARK: - Setup Views
    private func setupViews(){
        setupView()
        setupTopBarButton()
        //setupInputs()
        setupScrollView()
    }
    
    private func setupView(){
        self.view.backgroundColor = UIColor(cgColor: CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00))
    }
    
    private func setupTopBarButton(){
        profileButton.isHidden = false
        profileButton.image = UIImage(systemName: "square.and.pencil")
        profileButton.target = self
        profileButton.action = #selector(barBurronTapped)
    }
    
    private func setupInputs(){
        //TODO:
        inputViewBox.backgroundColor = UIColor(cgColor: CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00))
        inputViewBox.addSubview(inputTextField)
        inputViewBox.addSubview(sendButton)
        
        sendButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        sendButton.layer.cornerRadius = 20
        sendButton.clipsToBounds = true
        sendButton.tintColor = .white
        sendButton.backgroundColor = .orange
        
        inputTextField.backgroundColor = UIColor(cgColor: CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00))
        inputTextField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        inputTextField.isEditable = true
        inputTextField.isScrollEnabled = false
        inputTextField.textContainer.maximumNumberOfLines = 10
        inputTextField.sizeToFit()
        inputTextField.textAlignment = .left
        inputTextField.textColor = .white
        inputTextField.layer.cornerRadius = 5
        
        sendButton.rightAnchor.constraint(equalTo: inputViewBox.rightAnchor, constant: -10).isActive = true
        sendButton.topAnchor.constraint(equalTo: inputViewBox.topAnchor, constant: 10).isActive = true
        //sendButton.bottomAnchor.constraint(equalTo: inputViewBox.bottomAnchor, constant: -5).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        inputTextField.leftAnchor.constraint(equalTo: inputViewBox.leftAnchor, constant: 10).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10).isActive = true
        inputTextField.topAnchor.constraint(equalTo: inputViewBox.topAnchor, constant: 10).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: inputViewBox.bottomAnchor, constant: -10).isActive = true
        inputTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(inputViewBox)
        inputViewBox.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inputViewBox.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        inputViewBox.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        inputViewBox.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        inputViewBox.translatesAutoresizingMaskIntoConstraints = false
        inputViewBox.sizeToFit()
        
    }
    
    private func setupScrollView(){
        messagesScrollView.isScrollEnabled = true
        //messagesScrollView.sizeToFit()
        messagesScrollView.contentSize = CGSize(width: 500, height: 5000)
        messagesScrollView.isUserInteractionEnabled = true
        
        self.view.addSubview(messagesScrollView)
        
        messagesScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        messagesScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        messagesScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messagesScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        messagesScrollView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    
    //MARK: - Objc funcs
    @objc
    private func barBurronTapped(){
        //TODO: Open profile
    }
    
    //MARK: - Outside access
    func dialogConfigure(dialog_id: String){
        self.dialogId = dialog_id
        
        messageUpdate()
    }
    
    func messageUpdate(){
        //messagesScrollView.subviews.map{$0.removeFromSuperview()}
        
        let fetchRequest = Dialog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dialog_id LIKE %@", dialogId)
        var data: [Dialog] = []
        
        do{
            data = try self.context.fetch(fetchRequest)
            
            if data.count == 1{
                dialog = data[0]
                
                self.user = dialog?.user
            }
        }
        catch{
            
        }
        
        if let unwrappedMessages = dialog?.messages{
            if var messages = unwrappedMessages.allObjects as? [Message]{
                
                let userPhone = defaults.string(forKey: "phone")
                
                messages.sort{ $0.time < $1.time}
                
                for message in messages {
                    let newMessageView = MessageView(frame: CGRect(x: 0, y: 0, width: 500, height: 100))
                    
                    if message.user_id == userPhone{
                        newMessageView.configure(sender: .user, text: message.message_text ?? "")
                    }
                    else{
                        newMessageView.configure(sender: .user, text: message.message_text ?? "")
                    }
                    
                    messagesScrollView.addSubview(newMessageView)
                    newMessageView.leftAnchor.constraint(equalTo: messagesScrollView.leftAnchor).isActive = true
                    newMessageView.rightAnchor.constraint(equalTo: messagesScrollView.rightAnchor).isActive = true
                    newMessageView.widthAnchor.constraint(equalTo: messagesScrollView.widthAnchor).isActive = true
                    if messagesScrollView.subviews.count > 1{
                        newMessageView.topAnchor.constraint(equalTo: messagesScrollView.subviews[messagesScrollView.subviews.count - 2].bottomAnchor, constant: 5).isActive = true
                    }
                    else{
                        newMessageView.topAnchor.constraint(equalTo: messagesScrollView.topAnchor, constant: 5).isActive = true
                    }
                    newMessageView.translatesAutoresizingMaskIntoConstraints = false
                    //setupScrollView()
                    
                }
            }
        }
        
    }
}
