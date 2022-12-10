//
//  ViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 07.12.2022.
//

import UIKit

final class LaunchViewController: UIViewController {

    let label = UILabel()
    let spinner = UIActivityIndicatorView(style: .large)
    
    let defaults = UserDefaults.standard
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //try? defaults.removeObject(forKey: "token") //TODO: Delete later
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        loginHandler()
    }
    
    func setupViews(){
        setupView()
        setupSpinner()
        setupLabel()
    }
    
    func setupView(){
        self.view.layer.backgroundColor = CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00)
    }
    
    func setupSpinner(){
        spinner.startAnimating()
        spinner.isHidden = false
        spinner.color = .white
        self.view.addSubview(spinner)
              
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLabel(){
        label.text = "messenger"
        label.isHidden = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = label.font.withSize(50)
        
        self.view.addSubview(label)
        
        label.bottomAnchor.constraint(equalTo: spinner.topAnchor, constant: -95).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func loginHandler(){
        print("trying to login")
        let token = defaults.string(forKey: "token") //получаем токен из UserDefaults
        
        if let token = token{
            fetching(token, 0) //если токен существует, то мы проверяем его актуальность с помощью запроса
        }
        else{
            //TODO: Заменить спиннер кнопкой, которая так же будет перенаправлять на логин
            navigationController?.pushViewController(LoginViewConroller(), animated: false)
        }
    }
    
    func fetching(_ token: String,_ fetchCounter: Int){ //TODO: Протестировать
        if fetchCounter > 6{
            return
        }
        
        URLSession.dataFetch(url: "/auth/verifyJWT", headers: ["Authorization":"Bearer "+token],  requestType: .GET){ statusCode, data in
            
            print(statusCode)
            if 200...299 ~= statusCode{
                //TODO: then switch screen
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(MainTabBarController(), animated: false)
                }
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.fetching(token, fetchCounter + 1)
                }
            }
        }
    }
    


}

