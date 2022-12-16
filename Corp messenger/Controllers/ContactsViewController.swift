//
//  ContactsViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 09.12.2022.
//

import UIKit
import CoreData

final class ContactsViewController: UIViewController{
    
    //MARK: Storages
    private let defaults = UserDefaults.standard
    private var context: NSManagedObjectContext?
    
    private let addButton = UIBarButtonItem()
    private let tableView = UITableView()
    
    private var dataSource: [User] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false) //сокрытие навбара
        navigationController?.navigationBar.topItem?.title = "Contacts"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        
        
        navigationController?.navigationBar.topItem?.setRightBarButton(addButton, animated: true)
        localFetching()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.backgroundColor = CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00)
        
        if let context = UIApplication.shared.delegate as? AppDelegate{
            self.context = context.persistentContainer.viewContext
        }
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func setupViews(){
        setupTableView()
        setupBarButton()
    }
    
    private func setupBarButton(){
        addButton.image = UIImage(systemName: "plus")
        addButton.action = #selector(barBurronTapped)
        addButton.target = self
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.register(ContactCell.self , forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = false
        
        self.view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func localFetching(){
        guard let phone = defaults.string(forKey: "phone") else {return}
        
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "phone != %@", phone)
        var data: [User] = []
        
        guard let context = context else {return}
        do{
            data = try context.fetch(fetchRequest)
            
            dataSource = data
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }
    
    //MARK: - Url fetching
    private func fetchNewUser(phone: String){
        let request = "{'contact': '\(phone)'}"
        
        guard let token = defaults.string(forKey: "token") else {return}
        let parameters: [String: String] = ["phone": phone]
        let headers: [String: String] = ["Authorization":"Bearer " + token]
        
        URLSession.dataFetch(url: "/api/userData", parameters: parameters, headers: headers, requestType: .GET){ statusCode, data in
            if 200...299 ~= statusCode{
                DispatchQueue.main.async {
                    self.fetchUserData(phone: phone)
                }
            }
            else if statusCode == 503{
                print("Server unavailable")
            }
            else{
                DispatchQueue.main.async {
                    self.showMessageAlert()
                }
            }
        }
    }
    
    private func fetchUserData(phone: String){ //TODO: Correct
        guard let context = context else {return}
        guard let token = defaults.string(forKey: "token") else {return}
        let parameters: [String: String] = ["phone": phone]
        let headers: [String: String] = ["Authorization":"Bearer " + token]
        
        URLSession.dataFetch(url: "/api/userData", parameters: parameters, headers: headers, requestType: .GET){ statusCode, data in
            print("Callback")
            print(statusCode)
            if 200...299 ~= statusCode{
                if let responseJSON = try? JSONDecoder().decode(ResponseModels.userDataResponse.self, from: data)
                {
                    print(statusCode)
                    let responseData = responseJSON.data
                    DispatchQueue.main.sync {
                        let newUser = User(context: context)
                        
                        newUser.surname =  responseData.surname
                        newUser.name = responseData.name
                        newUser.phone = responseData.phone
                        newUser.imageBlob = responseData.imageBlob
                        
                        do{
                            try context.save()
                        }
                        catch{
                            
                        }
                        DispatchQueue.main.async {
                            self.localFetching()
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
                
            }
        }
    }
    
    private func showMessageAlert(){
        let alert = UIAlertController(title: "Ошибка", message: "Пользователь не существует",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createNewDialog(phone: String){
        
        let payload = wsRequestModels.members(members: [phone])
        let request = wsRequestModels.wsRequestNewDialog(route: "newDialog", payload: payload)
        
        do{
            let message = try JSONEncoder().encode(request)
            
            guard let count = navigationController?.children.count else{return}
            
            if let viewController = navigationController?.children[count - 1] as? UITabBarController{
                guard let vc = viewController.viewControllers else {return}
                guard let vc = vc[1] as? ChatsViewController else {return}
                vc.wsSend(message: String(decoding: message, as: UTF8.self))
                print("New dialog")
            }
            
        }
        catch{
            print("error")
        }
    }
    
    //MARK: - Objc
    @objc
    private func barBurronTapped(){
        let alertController = UIAlertController(title: "Add new contact", message: "Phone number without country code", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                self.fetchNewUser(phone: text)
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
    
}

extension ContactsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = dataSource[indexPath.row]
        guard let phone = user.phone else {return}
        
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "phone LIKE %@", phone)
        var data: [User] = []
        
        guard let context = context else {return}
        do{
            data = try context.fetch(fetchRequest)
            if let dialogId = data[0].dialog{
                guard let dialog_id = data[0].dialog?.dialog_id else {return}
                
                let dialogController = DialogViewController()
                dialogController.dialogConfigure(dialog_id: dialog_id)
                navigationController?.pushViewController(dialogController, animated: true)
            }
        }
        catch{
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ContactsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        default:
            let user = dataSource[indexPath.row]
            guard let name = user.name else {return ContactCell()}
            guard let surname = user.surname else {return ContactCell()}
            guard let imageBlob = user.imageBlob else {return ContactCell()}
            
            if let contactCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? ContactCell{
                contactCell.configure(nameSurname: name + " " + surname, image: UIImage.convertBase64StringToImage(imageBase64String: imageBlob))
                return contactCell
            }
        }
        return UITableViewCell()
    }
    
    
}
