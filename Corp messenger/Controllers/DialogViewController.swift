//
//  DialogViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 13.12.2022.
//

import UIKit
import CoreData

final class DialogViewController: UIViewController{
    //MARK: Storages
    private let defaults = UserDefaults.standard
    private var context: NSManagedObjectContext?
    
    //MARK: UI Elements
    private let profileButton = UIBarButtonItem()
    
    private let inputViewBox = UIView()
    private let inputTextField = UITextView()
    private let sendButton = UIButton()
    
    private let messagesScrollView = UIScrollView()
    private let messagesContentView = UIView()
    
    private static var dialogId: String = ""
    private var user: User?
    private var dialog: Dialog?
    private var messages: [Message]?
    
    //MARK: - ViewController settings
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false) //сокрытие навбара
        navigationController?.navigationBar.topItem?.title = "Chats"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        
        if let user = user{
            self.navigationItem.title = (user.name ?? "") + " " + (user.surname ?? "")
        }
        self.navigationItem.setRightBarButton(profileButton, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        if let user = user{
            self.navigationItem.title = (user.name ?? "") + " " + (user.surname ?? "")
        }
        messageUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.hideKeyboardWhenTappedAround()
        
        if let context = UIApplication.shared.delegate as? AppDelegate{
            self.context = context.persistentContainer.viewContext
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    //MARK: - Setup Views
    private func setupViews(){
        setupView()
        setupTopBarButton()
        setupInputs()
        setupScrollView()
    }
    
    private func setupView(){
        self.view.backgroundColor = UIColor(cgColor: CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00))
    }
    
    private func setupTopBarButton(){
        profileButton.isHidden = false
        profileButton.image = UIImage(systemName: "person.fill")
        profileButton.target = self
        profileButton.action = #selector(barBurronTapped)
    }
    
    private func setupInputs(){
        inputViewBox.backgroundColor = UIColor(cgColor: CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00))
        inputViewBox.addSubview(inputTextField)
        inputViewBox.addSubview(sendButton)
        inputViewBox.layer.borderColor = CGColor(gray: 0.2, alpha: 1)
        inputViewBox.layer.borderWidth = 1
        
        sendButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        sendButton.layer.cornerRadius = 20
        sendButton.clipsToBounds = true
        sendButton.tintColor = .white
        sendButton.backgroundColor = .orange
        
        inputTextField.backgroundColor = UIColor(cgColor: CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00))
        inputTextField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        inputTextField.isEditable = true
        inputTextField.isScrollEnabled = false
        inputTextField.textAlignment = .left
        inputTextField.text = "Message"
        inputTextField.textColor = UIColor.lightGray
        inputTextField.layer.cornerRadius = 20
        inputTextField.textContainer.lineFragmentPadding = 20
        inputTextField.delegate = self
        
        sendButton.rightAnchor.constraint(equalTo: inputViewBox.rightAnchor, constant: -10).isActive = true
        sendButton.topAnchor.constraint(equalTo: inputViewBox.topAnchor, constant: 10).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        sendButton.isEnabled = false
        
        inputTextField.leftAnchor.constraint(equalTo: inputViewBox.leftAnchor, constant: 10).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10).isActive = true
        inputTextField.topAnchor.constraint(equalTo: inputViewBox.topAnchor, constant: 10).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: inputViewBox.bottomAnchor, constant: -10).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(inputViewBox)
        inputViewBox.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -1).isActive = true
        inputViewBox.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 1).isActive = true
        inputViewBox.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: 1).isActive = true
        inputViewBox.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        inputViewBox.translatesAutoresizingMaskIntoConstraints = false
        inputViewBox.sizeToFit()
        
    }
    
    private func setupScrollView(){
        messagesScrollView.isScrollEnabled = true
        messagesScrollView.isUserInteractionEnabled = true
        messagesScrollView.backgroundColor = UIColor(cgColor: CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00))
        
        messagesScrollView.translatesAutoresizingMaskIntoConstraints = false
        messagesContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messagesScrollView)
        messagesScrollView.addSubview(messagesContentView)
        
        messagesScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messagesScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        messagesScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        messagesScrollView.bottomAnchor.constraint(equalTo: inputViewBox.topAnchor).isActive = true
        
        messagesContentView.centerXAnchor.constraint(equalTo: messagesScrollView.centerXAnchor).isActive = true
        messagesContentView.widthAnchor.constraint(equalTo: messagesScrollView.widthAnchor).isActive = true
        messagesContentView.topAnchor.constraint(equalTo: messagesScrollView.topAnchor).isActive = true
        messagesContentView.bottomAnchor.constraint(equalTo: messagesScrollView.bottomAnchor).isActive = true
        
    }
    
    private func scrollToBottom(){
        messagesScrollView.layoutSubviews()
        let bottomOffset = CGPoint(x: 0, y: messagesContentView.frame.height - messagesScrollView.bounds.height + messagesScrollView.contentInset.bottom)
        messagesScrollView.setContentOffset(bottomOffset, animated: false)
    }
    
    //MARK: - Core Data
    
    private func newMessageCoreData(user_id: String, message_id: String, message_text: String, time: Int) -> Message{
        guard let context = context else {return Message()}
        let newMessage = Message(context: context)
        
        newMessage.user_id = user_id
        let newTime = Int64(time)
        newMessage.time = newTime
        newMessage.read = false
        newMessage.message_text = message_text
        newMessage.message_id = message_id
        newMessage.edited = false
        
        do{
            try context.save()
        }
        catch{
            
        }
        
        return newMessage
    }
    
    //MARK: - Objc funcs
    @objc
    private func barBurronTapped(){
        //TODO: Open profile
    }
    
    @objc
    private func sendButtonTapped(){
        view.endEditing(false)
        guard let message_text = inputTextField.text else {print("text error");return}
        
        inputTextField.text = "Message"
        inputTextField.textColor = UIColor.lightGray
        sendButton.isEnabled = false
        
        guard let phone = defaults.string(forKey: "phone") else {print("phone error");return}
        
        let payload = wsRequestModels.message(dialog_id: DialogViewController.dialogId, user_id: phone, message_text: message_text)
        let request = wsRequestModels.wsRequestNewMessage(route: "newMessage", payload: payload)
        
        do{
            let message = try JSONEncoder().encode(request)
            
            guard let count = navigationController?.children.count else{return}
            
            if let viewController = navigationController?.children[count - 2] as? UITabBarController{
                print("parent got")
                guard let vc = viewController.viewControllers else {return}
                guard let vc = vc[1] as? ChatsViewController else {return}
                print("Trying to send")
                vc.wsSend(message: String(decoding: message, as: UTF8.self))
            }
            
        }
        catch{
            print("error")
        }
        
        
        print("tapped")
    }
    
    @objc
    func keyboardWillShow(){
        scrollToBottom()
    }
    
    //MARK: - Outside access
    func dialogConfigure(dialog_id: String){
        DialogViewController.dialogId = dialog_id
    }
    
    func messageUpdate(){
        guard let context = context else {return}
        messagesContentView.subviews.map{$0.removeFromSuperview()}
        let fetchRequest = Dialog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dialog_id LIKE %@", DialogViewController.dialogId)
        var data: [Dialog] = []
        do{
            data = try context.fetch(fetchRequest)
            if data.count == 1{
                dialog = data[0]
                self.user = dialog?.user
            }
        }
        catch{
            print("Dialog error")
        }
        
        if let unwrappedMessages = dialog?.messages{
            if var messages = unwrappedMessages.allObjects as? [Message]{
                
                let userPhone = defaults.string(forKey: "phone")
                
                messages.sort{ $0.time < $1.time}
                
                var i = 0
                let count = messages.count
                for message in messages {
                    i = i + 1
                    let newMessageView = MessageView(frame: CGRect(x: 0, y: 0, width: 500, height: 100))
                    
                    if message.user_id == userPhone{
                        newMessageView.configure(sender: .user, text: message.message_text ?? "")
                    }
                    else{
                        newMessageView.configure(sender: .companion, text: message.message_text ?? "")
                    }
                    
                    messagesContentView.addSubview(newMessageView)
                    newMessageView.leftAnchor.constraint(equalTo: messagesContentView.leftAnchor).isActive = true
                    newMessageView.widthAnchor.constraint(equalTo: messagesContentView.widthAnchor).isActive = true
                    if messagesContentView.subviews.count > 1{
                        newMessageView.topAnchor.constraint(equalTo: messagesContentView.subviews[messagesContentView.subviews.count - 2].bottomAnchor, constant: 5).isActive = true
                    }
                    else{
                        newMessageView.topAnchor.constraint(equalTo: messagesContentView.topAnchor, constant: 10).isActive = true
                    }
                    
                    if i == count{
                        newMessageView.bottomAnchor.constraint(equalTo: messagesContentView.bottomAnchor, constant: -10).isActive = true
                    }
                    newMessageView.translatesAutoresizingMaskIntoConstraints = false
                    //setupScrollView()
                    
                }
                
                //TODO: SCroll to bottom
                messagesScrollView.layoutSubviews()
                let bottomOffset = CGPoint(x: 0, y: messagesContentView.frame.height - messagesScrollView.bounds.height + messagesScrollView.contentInset.bottom)
                messagesScrollView.setContentOffset(bottomOffset, animated: true)
            }
        }
        else{
            print("Messages error")
        }
        
    }
}

extension DialogViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        
        if !textView.text.isEmpty && textView.textColor != UIColor.lightGray{
            sendButton.isEnabled = true
        }
        else{
            sendButton.isEnabled = false
        }
        
        guard textView.contentSize.height < 100 else {textView.isScrollEnabled = true; return}
        
        textView.isScrollEnabled = false
        textView.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height{
                constraint.constant = estimateSize.height
            }
            
        }
        
    }
}
