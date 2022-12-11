//
//  MessagesViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 09.12.2022.
//

import UIKit

final class ChatsViewController: UIViewController{
    //MARK: Storages
    private let defaults = UserDefaults.standard
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: UI elements
    private let messageTableView = UITableView(frame: .zero, style: .plain)
    
    private let spinner = UIActivityIndicatorView(style: .large)
    private let loadingView = UIView()
    //MARK: Bar button
    private let addButton = UIBarButtonItem()
    //MARK: UITableView data source
    private var dataSource: [wsResponseModels.Dialog]?
    
    //MARK: WebSocket
    private var WebSocket: URLSessionWebSocketTask?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false) //сокрытие навбара
        navigationController?.navigationBar.topItem?.title = "Chats"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        
        navigationController?.navigationBar.topItem?.setRightBarButton(addButton, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWS()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func setupWS(){
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "ws://10.192.240.149:3000")
        guard let url = url else {return}
        var urlRequest = URLRequest(url: url)
        let token = defaults.string(forKey: "token")
        guard let token = token else {return}
        urlRequest.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        
        WebSocket = session.webSocketTask(with: urlRequest)
        WebSocket?.resume()
    }
    
    //MARK: - Setup views
    private func setupViews(){
        setupView()
        setupBarButton()
        setupTableView()
        setupLoader()
    }
    
    private func setupNavBarApperance(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(cgColor: CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00))
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupView(){
        self.view.layer.backgroundColor = CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00)
    }
    
    private func setupBarButton(){
        addButton.isHidden = false
        addButton.image = UIImage(systemName: "square.and.pencil")
        addButton.target = self
        addButton.action = #selector(barBurronTapped)
    }
    
    private func setupLoader(){
        //SPINNER
        spinner.startAnimating()
        spinner.isHidden = false
        spinner.color = .white
        
        loadingView.addSubview(spinner)
        
        spinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        //LOADING VIEW
        loadingView.backgroundColor = UIColor(cgColor: CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00))
        loadingView.isHidden = false
        
        self.view.addSubview(loadingView)
        
        loadingView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTableView(){
        messageTableView.delegate = self
        messageTableView.register(MessageCell.self , forCellReuseIdentifier: "cellId")
        messageTableView.backgroundColor = .clear
        messageTableView.keyboardDismissMode = .onDrag
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageTableView.isHidden = true
        
        self.view.addSubview(messageTableView)
        
        messageTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        messageTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        messageTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        messageTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        messageTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Core Data
    
    private func newDialogCoreData(dialog_id: String, lastMessageTime: Int64) -> Dialog{
        let newDialog = Dialog(context: context)
        
        newDialog.dialog_id = dialog_id
        newDialog.lastMessageTime = lastMessageTime
        
        do{
            try self.context.save()
        }
        catch{
            
        }
        
        return newDialog
    }
    
    private func newUserCoreData(phone: String, name: String, surname:String, imageBlob: String) -> User{
        let newUser = User(context: context)
        
        newUser.phone = phone
        newUser.name = name
        newUser.surname = surname
        newUser.imageBlob = imageBlob
        
        do{
            try self.context.save()
        }
        catch{
            
        }
        
        return newUser
    }
    
    private func newMessageCoreData(user_id: String, message_id: String, message_text: String, time: Int) -> Message{
        let newMessage = Message(context: context)
        
        newMessage.user_id = user_id
        let newTime = Int64(time)
        newMessage.time = newTime
        newMessage.read = false
        newMessage.message_text = message_text
        newMessage.message_id = message_id
        newMessage.edited = false
        
        do{
            try self.context.save()
        }
        catch{
            
        }
        
        return newMessage
    }
    
    //MARK: - Fetches
    
    
    
    //MARK: - Objc methods
    @objc
    func barBurronTapped(){
        //TODO:
    }
    
}

//MARK: - WebSocket extension
extension ChatsViewController: URLSessionWebSocketDelegate{
    
    private func wsSend(message: String){
        WebSocket?.send(.string(message)){ error in
            if let error = error{
                print("Send error: \(error)")
            }
        }
    }
    
    private func wsRecieve(){
        WebSocket?.receive(completionHandler: { result in
            switch result{
            case .success(let message):
                switch message{
                case .string(let data):
                    print("String")
                    print(data)
                    if let response = try? JSONDecoder().decode(wsResponseModels.wsModel.self, from: Data(data.utf8)){
                        print(response)
                    }
                    break
                case .data(let data):
                    print("data")
                    print(data)
                    break
                @unknown default:
                    print("Hz")
                    break
                }
                //if let response = try? JSONDecoder().decode(wsResponseModels.wsModel.self, from: message)
                break
            case .failure(let error):
                print(error)
                break
            }
            
            
        })
    }
    
    //MARK: WebSocket Response handler
    private func wsResponseHandle(res: wsResponseModels.wsModel){
        switch res.route{
        case "newJwt":
            break
        case "newMessage":
            break
        case "newDialog":
            break
        case "getMessages":
            break
        case "getDialogs":
            break
        case "onError":
            break
        default:
            print("Not default route: \(res.route)")
            break
        }
    }
    
    private func wsClose(){
        WebSocket?.cancel(with: .goingAway, reason: "Bye bye".data(using: .utf8))
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WS connected")
        wsRecieve()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WS disconnected")
    }
}

//MARK: - TableView Extension
extension ChatsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard let count = dataSource?.count else{return 0}
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        default:
            let dialog = dataSource?[indexPath.row]
            if let messageCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? MessageCell{
                messageCell.configure(nameSurname: dialog?.dialog_name ?? "None", image: UIImage(), lastMessage: "Oh hi my dear, how are you? I \nhope we will meet nex week! АХАХАХА ЛОШАРА АМЕРИКАНСКАЯ")
                return messageCell
            }
        }
        
        return UITableViewCell()
    }
    
    
}

extension ChatsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
