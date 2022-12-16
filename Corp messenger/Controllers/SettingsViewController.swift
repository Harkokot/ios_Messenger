//
//  SettingsViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 09.12.2022.
//

import UIKit
import CoreData

final class SettingsViewController: UIViewController{
    //MARK: Storages
    private let defaults = UserDefaults.standard
    private var context: NSManagedObjectContext?
    private var currentUser: User?
    //MARK: UI elements
    private let spinner = UIActivityIndicatorView(style: .large)
    private let container = UIView()
    private let userImageButton = UIButton()
    private let nameLabel = UILabel()
    private let surnameLabel = UILabel()
    private let phoneLabel = UILabel()
    private let logoutButton = UIButton()
    
    //MARK: Bar button
    private let editButton = UIBarButtonItem()
    
    //MARK: - Controller config
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false) //сокрытие навбара
        navigationController?.navigationBar.topItem?.title = "Settings"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.topItem?.setRightBarButton(editButton, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let context = UIApplication.shared.delegate as? AppDelegate{
            self.context = context.persistentContainer.viewContext
        }
        
        setupViews()
        
        getUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //MARK: - Setting up views
    private func setupViews(){
        setupView()
        setupSpinner()
        setupContainer()
        setupBarButton()
    }
    
    private func setupView(){
        self.view.layer.backgroundColor = CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00)
    }
    
    private func setupBarButton(){
        editButton.isHidden = true
        editButton.title = "Edit"
        editButton.target = self
        editButton.action = #selector(barBurronTapped)
    }
    
    private func setupSpinner(){
        spinner.startAnimating()
        spinner.isHidden = false
        spinner.color = .white
        self.view.addSubview(spinner)
              
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContainer(){
        setupContainerContent()
        
        container.isHidden = true
        container.layer.backgroundColor = CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00)
        
        self.view.addSubview(container)
        
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        container.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContainerContent(){
        //view settings
        userImageButton.backgroundColor = .gray
        userImageButton.layer.cornerRadius = 75
        userImageButton.clipsToBounds = true
        userImageButton.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        userImageButton.layer.borderWidth = 2
        
        nameLabel.text = ""
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 30)
        
        phoneLabel.text = ""
        phoneLabel.textColor = .lightGray
        phoneLabel.textAlignment = .center
        phoneLabel.font = UIFont.systemFont(ofSize: 20)
        
        logoutButton.setTitle("Sign out", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.setTitleColor(.gray, for: .focused)
        logoutButton.layer.backgroundColor = CGColor(red: 1, green: 0.03, blue: 0, alpha: 1)
        logoutButton.layer.cornerRadius = 10
        logoutButton.titleLabel?.font = logoutButton.titleLabel?.font.withSize(25)
        
        //adding subviews
        container.addSubview(userImageButton)
        container.addSubview(nameLabel)
        container.addSubview(phoneLabel)
        container.addSubview(logoutButton)
        
        //constraints
        userImageButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        userImageButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        userImageButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        userImageButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
        userImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: userImageButton.bottomAnchor, constant: 10).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        phoneLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -50).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
    }
    
    //MARK: - UserData
    private func getUserData(){
        //Setting up request
        guard let context = context else {return}
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        guard let phone = defaults.string(forKey: "phone") else {return}
        fetchRequest.predicate = NSPredicate(format: "phone LIKE %@", phone)
        var data: [User] = []
        
        //Request
        do{
            data = try context.fetch(fetchRequest)
            
            print(data)
            if data.count == 1{
                self.userImageButton.setImage(UIImage.convertBase64StringToImage(imageBase64String: data[0].imageBlob ?? ""), for: .normal)
                self.phoneLabel.text = "+7" + (data[0].phone ?? "")
                self.nameLabel.text = (data[0].name ?? "") + " " + (data[0].surname ?? "")
                
                self.spinner.isHidden = true
                self.container.isHidden = false
                self.editButton.isHidden = false
                
                self.currentUser = data[0]
            }
            else if data.count == 0{
                fetchUserData()
            }
            else{
                throw "Core data has more than 1 entity with equals phone"
            }
        }
        catch{
            
            for user in data{
                context.delete(user)
            }
            
            //data saving
            do{
                try context.save()
            }
            catch{
                return
            }
            
            self.defaults.removeObject(forKey: "phone")
            self.defaults.removeObject(forKey: "token")
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
    //MARK: - Fetches
    
    private func fetchUserData(){
        guard let context = context else {return}
        guard let phone = defaults.string(forKey: "phone") else {return}
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
                        
                        self.getUserData()
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
    private func barBurronTapped(){
        //TODO: Открыть всплывающее окно
    }
    
    @objc
    private func logoutButtonPressed(){
        guard let context = context else {return}
        let alert = UIAlertController(title: "Sign out?", message: "You can always access your account by signing back in", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let logoutAction = UIAlertAction(title: "Sign out", style: .destructive){(action) in
            guard let user = self.currentUser else {return}
            
            context.delete(user)
            
            //data saving
            do{
                try context.save()
            }
            catch{
                return
            }
            
            CoreDataBase.deleteAllData()
            
            self.defaults.removeObject(forKey: "phone")
            self.defaults.removeObject(forKey: "token")
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(logoutAction)
        
        self.present(alert, animated: true)
    }
    
}
