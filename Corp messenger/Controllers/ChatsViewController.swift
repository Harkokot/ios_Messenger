//
//  MessagesViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 09.12.2022.
//

import UIKit
import CoreData
import AudioToolbox

final class ChatsViewController: UIViewController{
    //MARK: Storages
    private let defaults = UserDefaults.standard
    private var context: NSManagedObjectContext?
    
    //MARK: UI elements
    private let messageTableView = UITableView(frame: .zero, style: .plain)
    
    private let spinner = UIActivityIndicatorView(style: .large)
    private let loadingView = UIView()
    
    private let noDialogsView = UIView()
    private let noDialogsLabel = UILabel()
    private let noDialogsImage = UIImageView()
    //MARK: Bar button
    private let addButton = UIBarButtonItem()
    //MARK: UITableView data source
    private var dataSource: [Dialog] = []
    
    //MARK: Dialog View Controller
    let dialogController = DialogViewController()
    
    //MARK: WebSocket
    private var WebSocket: URLSessionWebSocketTask?
    private var userOnScreen: Bool = true
    private var userOnMessageScreen: Bool = false
    
    //MARK: - ViewController settings
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false) //сокрытие навбара
        navigationController?.navigationBar.topItem?.title = "Chats"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        
        navigationController?.navigationBar.topItem?.setRightBarButton(addButton, animated: true)
        
        userOnScreen = true
        userOnMessageScreen = false
        localFetchDialogs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let context = UIApplication.shared.delegate as? AppDelegate{
            self.context = context.persistentContainer.viewContext
        }
        
        setupWS()
        
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Chat disappear")
        userOnScreen = false
        userOnMessageScreen = true
    }
    
    private func setupDialogs(){
        var request = wsRequestModels.wsRequestText(route: "getDialogs", payload: "")
        
        do{
            let req = try JSONEncoder().encode(request)
            
            wsSend(message: String(decoding: req, as: UTF8.self))
        }
        catch{
            print("Чет не получилось")
        }
    }
    
    private func setupWS(){
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "ws://localhost:3000")
        guard let url = url else {return}
        var urlRequest = URLRequest(url: url)
        let token = defaults.string(forKey: "token")
        guard let token = token else {return}
        urlRequest.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        
        WebSocket = session.webSocketTask(with: urlRequest)
        WebSocket?.resume()
        
        setupDialogs()
    }
    
    //MARK: - Setup views
    private func setupViews(){
        setupView()
        setupBarButton()
        setupTableView()
        setupLoader()
        setupNoDialogsViews()
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
    
    private func setupNoDialogsViews(){
        noDialogsView.layer.backgroundColor = CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00)
        noDialogsView.isHidden = true
        
        noDialogsImage.image = UIImage(systemName: "theatermasks")
        noDialogsImage.backgroundColor = .clear
        noDialogsImage.tintColor = .white
        
        noDialogsLabel.text = "You don't have any dialogues"
        noDialogsLabel.backgroundColor = .clear
        noDialogsLabel.textColor = .white
        noDialogsLabel.textAlignment = .center
        noDialogsLabel.font = UIFont.systemFont(ofSize: 20)
        
        noDialogsView.addSubview(noDialogsImage)
        noDialogsView.addSubview(noDialogsLabel)
        
        noDialogsImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        noDialogsImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        noDialogsImage.centerXAnchor.constraint(equalTo: noDialogsView.centerXAnchor).isActive = true
        noDialogsImage.centerYAnchor.constraint(equalTo: noDialogsView.centerYAnchor, constant: -50).isActive = true
        noDialogsImage.translatesAutoresizingMaskIntoConstraints = false
        
        noDialogsLabel.centerXAnchor.constraint(equalTo: noDialogsView.centerXAnchor).isActive = true
        noDialogsLabel.topAnchor.constraint(equalTo: noDialogsImage.bottomAnchor, constant: 20).isActive = true
        noDialogsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(noDialogsView)
        
        noDialogsView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        noDialogsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        noDialogsView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        noDialogsView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        noDialogsView.translatesAutoresizingMaskIntoConstraints = false
        
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
        guard let context = context else {return Dialog()}
        
        let newDialog = Dialog(context: context)
        
        newDialog.dialog_id = dialog_id
        newDialog.lastMessageTime = lastMessageTime
        
        do{
            try context.save()
        }
        catch{
            
        }
        
        return newDialog
    }
    
    private func newUserCoreData(phone: String, name: String, surname:String, imageBlob: String) -> User{
        guard let context = context else {return User()}
        let newUser = User(context: context)
        
        newUser.phone = phone
        newUser.name = name
        newUser.surname = surname
        newUser.imageBlob = imageBlob
        
        do{
            try context.save()
        }
        catch{
            
        }
        
        return newUser
    }
    
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
    
    //MARK: - Local fetchies
    private func localFetchDialogs(){
        let fetchRequest = Dialog.fetchRequest()
        let lastMessageSort = NSSortDescriptor(key:"lastMessageTime", ascending: true)
        fetchRequest.sortDescriptors?.append(lastMessageSort)
        var data: [Dialog] = []
        guard let context = context else {return}
        do{
            data = try context.fetch(fetchRequest)
            
            dataSource = data
            
            if data.count > 0{
                DispatchQueue.main.async {
                    self.messageTableView.isHidden = false
                    self.messageTableView.reloadData()
                    self.loadingView.isHidden = true
                    self.noDialogsView.isHidden = true
                }
            }
            else{
                DispatchQueue.main.async {
                    self.noDialogsView.isHidden = false
                    self.loadingView.isHidden = true
                }
            }
        }
        catch{
            
        }
        
        if userOnMessageScreen{
            DispatchQueue.main.async {
                if let viewController = self.navigationController?.children{
                    if let vc = viewController[viewController.count-1] as? DialogViewController{
                        vc.messageUpdate()
                    }
                }
            }
        }
        
    }
    
    //MARK: - URL Fetches
    
    private func fetchUserData(phone: String, dialog_id: String){
        let phone = phone
        guard let token = defaults.string(forKey: "token") else {return}
        let parameters: [String: String] = ["phone": phone]
        let headers: [String: String] = ["Authorization":"Bearer " + token]
        
        URLSession.dataFetch(url: "/api/userData", parameters: parameters, headers: headers, requestType: .GET){ statusCode, data in
            if 200...299 ~= statusCode{
                if let responseJSON = try? JSONDecoder().decode(ResponseModels.userDataResponse.self, from: data)
                {
                    let responseData = responseJSON.data
                    DispatchQueue.main.sync {
                        guard let context = self.context else {return}
                        let newUser = User(context: context)
                        
                        newUser.surname =  responseData.surname
                        newUser.name = responseData.name
                        newUser.phone = responseData.phone
                        newUser.imageBlob = responseData.imageBlob
                        
                        //fetch dialog
                        let fetchRequest = Dialog.fetchRequest()
                        fetchRequest.predicate = NSPredicate(format: "dialog_id LIKE %@", dialog_id)
                        var data: [Dialog] = []
                        
                        do{
                            data = try context.fetch(fetchRequest)
                            
                            if data.count == 1{
                                newUser.dialog = data[0]
                                
                                do{
                                    try context.save()
                                    self.localFetchDialogs()
                                }
                                catch{
                                    
                                }
                            }
                            else{
                                print("dialog exception with user creation")
                            }
                        }
                        catch{
                            
                        }
                    }
                    
                }
                else{
                    print("Parsing error")
                }
            }
            else if statusCode == 503{
                print("Server unavailable")
            }
            else{
                DispatchQueue.main.async {
                    //self.setInputsError()
                }
            }
        }
    }
    
    
    //MARK: - Objc methods
    @objc
    func barBurronTapped(){
        let alertController = UIAlertController(title: "Add new dialogue", message: "Phone number without country code", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                self.createNewDialog(phone: text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "9876543210"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func createNewDialog(phone: String){
        
        let payload = wsRequestModels.members(members: [phone])
        let request = wsRequestModels.wsRequestNewDialog(route: "newDialog", payload: payload)
        
        do{
            let message = try JSONEncoder().encode(request)
            
            wsSend(message: String(decoding: message, as: UTF8.self))
                print("New dialog")
            
        }
        catch{
            print("error")
        }
    }
    
}

//MARK: - WebSocket extension
extension ChatsViewController: URLSessionWebSocketDelegate{
    
    func wsSend(message: String){
        print("message sended")
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
                    if let response = try? JSONDecoder().decode(wsResponseModels.wsResponseText.self, from: Data(data.utf8)){
                        switch response.route{
                        case "newJwt":
                            self.defaults.set(response.payload, forKey: "token")
                            break
                        case "onError":
                            break
                        default:
                            print("Not default route: \(response.route)")
                            break
                        }
                    }
                    else{
                        self.wsResponseHandle(res: data)
                    }
                    break
                case .data(_):
                    print("data")
                    break
                @unknown default:
                    print("Hz")
                    break
                }
                break
            case .failure(let error):
                print(error)
                break
            }
            self.wsRecieve()
        })
    }
    
    //MARK: WebSocket Response handler
    private func wsResponseHandle(res: String){
        
        //MARK: New dialog parser
        if let newDialogRequest = try? JSONDecoder().decode(wsResponseModels.wsResponseNewDialog.self, from: Data(res.utf8)){
            guard let context = context else {return}
            let newCDDialog = Dialog(context: context)
            
            newCDDialog.lastMessageTime = Int64(newDialogRequest.payload.newDialog.lastMessageTime)
            newCDDialog.dialog_id = newDialogRequest.payload.newDialog.dialog_id
            do{
                try context.save()
                
                for member in newDialogRequest.payload.newDialog.members{
                    if(defaults.string(forKey: "phone") != member){
                        
                        
                        
                        fetchUserData(phone: member, dialog_id: newDialogRequest.payload.newDialog.dialog_id)
                    }
                }
            }
            catch{
                
            }
            
            return
        }
        
        //MARK: New message parser
        if let newMessageRequest = try? JSONDecoder().decode(wsResponseModels.wsResponseNewMessage.self, from: Data(res.utf8)){
            
            let payload = newMessageRequest.payload
            guard let context = context else {return}
            let newCDMessage = Message(context: context)
            
            newCDMessage.user_id = payload.newMessage.user_id
            newCDMessage.time = Int64(payload.newMessage.time)
            newCDMessage.read = false
            newCDMessage.message_text = payload.newMessage.message_text
            newCDMessage.message_id = payload.newMessage.message_id
            newCDMessage.edited = false
            
            let fetchRequest = Dialog.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "dialog_id LIKE %@", payload.dialog.dialog_id)
            var data: [Dialog] = []
            
            do{
                data = try context.fetch(fetchRequest)
                
                if data.count == 1{
                    data[0].addToMessages(newCDMessage)
                    do{
                        try context.save()
                    }
                    catch{
                        
                    }
                }
                else{
                    throw "dialog exception with user creation"
                }
            }
            catch{
                
            }
            
            localFetchDialogs()
            guard let phone = defaults.string(forKey: "phone") else {return}
            if newCDMessage.user_id != phone{
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            return
        }
        
        //MARK: Get dialogs parser
        if let getDialogsRequest = try? JSONDecoder().decode(wsResponseModels.wsResponseGetDialogs.self, from: Data(res.utf8)){
            guard let context = context else {return}
            for dialog in getDialogsRequest.payload{
                let fetchRequest = Dialog.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "dialog_id LIKE %@", dialog.dialog_id)
                var dialogData: [Dialog] = []
                
                do{
                    dialogData = try context.fetch(fetchRequest)
                    if dialogData.count == 1{
                        guard let messages = dialog.messages else {return}
                        for (id, message) in messages{
                            let fetchRequest = Message.fetchRequest()
                            fetchRequest.predicate = NSPredicate(format: "message_id LIKE %@", id)
                            var messageData: [Message] = []
                            
                            do{
                                messageData = try context.fetch(fetchRequest)
                                
                                if messageData.count == 0{
                                    let newMessage = newMessageCoreData(user_id: message.user_id, message_id: message.message_id, message_text: message.message_text, time: message.time)
                                    newMessage.dialog = dialogData[0]
                                    try? context.save()
                                    
                                }
                            }
                            catch{
                                
                            }
                        }
                    }
                    else{
                        let newDialog = newDialogCoreData(dialog_id: dialog.dialog_id, lastMessageTime: Int64(dialog.lastMessageTime))
                        
                        for member in dialog.members{
                            if(defaults.string(forKey: "phone") != member){
                                fetchUserData(phone: member, dialog_id: dialog.dialog_id)
                            }
                        }
                        
                        guard let messages = dialog.messages else {return}
                        for (id, message) in messages{
                            let newMessage = newMessageCoreData(user_id: message.user_id, message_id: message.message_id, message_text: message.message_text, time: message.time)
                            newMessage.dialog = newDialog
                            
                            
                            
                        }
                        
                        try? context.save()
                    }
                }
                catch{
                    
                }
            }
            
            self.localFetchDialogs()
            
        }
        //TODO: Обработка еще двух роутов, которые описаны ниже
//        case "getDialogs":
//            break
        
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        default:
            var lastMessage: String = "Новый диалог создан"
            var image: UIImage = UIImage()
            var name: String = "Name"
            var surname: String = "Surname"
            
            if let dialog = dataSource[indexPath.row] as? Dialog{
                if let messages = dialog.messages{
                    if var messages = messages.allObjects as? [Message]{
                        if messages.count > 0{
                            let orderedMessages = messages.sorted{ $0.time > $1.time }
                            if let text = orderedMessages[0].message_text{
                                lastMessage = text
                            }
                        }
                    }
                }
                
                if let user = dialog.user{
                    if let n = user.name{
                        name = n
                    }
                    if let s = user.surname{
                        surname = s
                    }
                    if let imgBlob = user.imageBlob{
                        image = UIImage.convertBase64StringToImage(imageBase64String: imgBlob)
                    }
                    
                }
            }
            
            if let messageCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? MessageCell{
                messageCell.configure(nameSurname: name + " " + surname,
                                      image: image,
                                      lastMessage: lastMessage)
                return messageCell
            }
        }
        
        return UITableViewCell()
    }
    
    
}

extension ChatsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dialog = dataSource[indexPath.row] as? Dialog{
            let dialogController = DialogViewController()
            dialogController.dialogConfigure(dialog_id: dialog.dialog_id ?? "")
            navigationController?.pushViewController(dialogController, animated: true)
            self.userOnMessageScreen = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
