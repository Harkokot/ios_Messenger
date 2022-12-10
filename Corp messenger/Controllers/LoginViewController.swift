//
//  LoginViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 07.12.2022.
//

import UIKit

final class LoginViewConroller: UIViewController{
    private let defaults = UserDefaults.standard
    
    //title
    private let titleLabel = UILabel()
    
    //form
    private let form = UIView()
    private let passwordLabel = UILabel()
    private let phoneLabel = UILabel()
    private let phoneInput = UITextField()
    private let passwordInput = UITextField()
    private let regButton = UIButton()
    
    private let loginButton = UIButton()
    
    override func viewDidLoad(){
        //navigationController?.setNavigationBarHidden(true, animated: false) //сокрытие навбара
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false) //сокрытие навбара
    }
    
    private func setupViews(){
        setupView()
        setupTitleLabel()
        setupLoginForm()
        setupLoginButton()
        setupRegButton()
    }
    
    private func setupView(){
        self.view.layer.backgroundColor = CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00)
    }
    
    private func setupTitleLabel(){
        titleLabel.text = "login"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = titleLabel.font.withSize(50)
        
        self.view.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLoginForm(){
        setupInputs()
        
        self.view.addSubview(form)
        
        form.widthAnchor.constraint(equalToConstant: 300).isActive = true
        form.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        form.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
        form.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLoginButton(){
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = loginButton.titleLabel?.font.withSize(25)
        loginButton.layer.cornerRadius = 10
        loginButton.layer.backgroundColor = CGColor(red: 0.00, green: 0.44, blue: 0.80, alpha: 1.00)
        
        self.view.addSubview(loginButton)
        
        
        loginButton.topAnchor.constraint(equalTo: form.bottomAnchor, constant: 150).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func loginButtonPressed(){
        phoneInput.layer.borderWidth = 0
        passwordInput.layer.borderWidth = 0
        let phone = phoneInput.text
        let password = passwordInput.text
        if let phoneLenght = phone?.count, var phone = phone, let password = password{
            if 10...12 ~= phoneLenght && password != ""{
                switch phoneLenght{
                    case 12:
                        phone.remove(at: phone.startIndex)
                        phone.remove(at: phone.startIndex)
                        break
                    case 11:
                        phone.remove(at: phone.startIndex)
                        break
                    default:
                        break
                }
                
                fetchLogin(phone: phone, password: password) //TODO: Uncomment later
            }
            else{
                if phone == "" || phoneLenght > 12 || phoneLenght < 10{
                    
                    phoneInput.layer.borderWidth = 2
                }
                
                if password == ""{
                    passwordInput.layer.borderWidth = 2
                }
            }
        }
    }
    
    private func fetchLogin(phone: String, password: String){
        let parameters: [String: Any] = ["phone": phone, "password": password]
        let headers: [String: String] = ["Content-Type": "application/json", "Accept": "application/json"]
        
        URLSession.dataFetch(url: "/auth/login", headers: headers, body: parameters, requestType: .POST){ statusCode, data in
            print("Callback")
            if 200...299 ~= statusCode{
                let responseJSON = try? JSONDecoder().decode(ResponseModels.loginResponse.self, from: data)
                if let responseJSON = responseJSON{
                    print(statusCode)
                    print(responseJSON.token)
                    DispatchQueue.main.async {
                        //TODO: Переключение на другой экран
                        self.defaults.set(responseJSON.token, forKey: "token")
                        self.defaults.set(phone, forKey: "phone")
                        self.navigationController?.pushViewController(MainTabBarController(), animated: false)
                    }
                }
            }
            else if statusCode == 503{
                print("Server unavailable")
            }
            else{
                DispatchQueue.main.async {
                    self.setInputsError()
                }
            }
        }
    }
    
    private func setInputsError(){
        phoneInput.layer.borderWidth = 2
        passwordInput.layer.borderWidth = 2
    }
    
    private func setupRegButton(){
        regButton.setTitle("Don't have account?", for: .normal)
        regButton.setTitleColor(UIColor(red: 0.96, green: 0.84, blue: 0.36, alpha: 1.00), for: .normal)
        regButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        regButton.titleLabel?.textAlignment = .left
        regButton.layer.backgroundColor = CGColor(gray: 1, alpha: 0)
        
        self.view.addSubview(regButton)
        
        regButton.leftAnchor.constraint(equalTo: form.leftAnchor).isActive = true
        regButton.topAnchor.constraint(equalTo: form.bottomAnchor, constant: 15).isActive = true
        regButton.translatesAutoresizingMaskIntoConstraints = false
        regButton.isEnabled = true
        regButton.addTarget(self, action: #selector(navToReg), for: .touchUpInside)
    }
    
    private func setupInputs(){
        //LABELS//
        phoneLabel.text = "Phone number"
        phoneLabel.textColor = .white
        phoneLabel.textAlignment = .left
        phoneLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        passwordLabel.text = "Password"
        passwordLabel.textColor = .white
        passwordLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        passwordLabel.textAlignment = .left
        
        //INPUTS//
        phoneInput.textAlignment = .left
        phoneInput.textColor = .black
        phoneInput.font = phoneInput.font?.withSize(25)
        phoneInput.placeholder = "+79876543210"
        phoneInput.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        phoneInput.isEnabled = true
        phoneInput.layer.cornerRadius = 10
        phoneInput.setLeftPaddingPoints(10)
        phoneInput.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        phoneInput.keyboardType = .phonePad
        
        passwordInput.placeholder = "********"
        passwordInput.textColor = .black
        passwordInput.textAlignment = .left
        passwordInput.font = passwordInput.font?.withSize(25)
        passwordInput.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        passwordInput.isSecureTextEntry = true
        passwordInput.layer.cornerRadius = 10
        passwordInput.setLeftPaddingPoints(10)
        passwordInput.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        //ADDING SUBVIEW//
        form.addSubview(phoneLabel)
        form.addSubview(phoneInput)
        form.addSubview(passwordInput)
        form.addSubview(passwordLabel)
        
        //CONSTRAINTS//
        phoneInput.topAnchor.constraint(equalTo: form.topAnchor).isActive = true
        phoneInput.centerXAnchor.constraint(equalTo: form.centerXAnchor).isActive = true
        phoneInput.widthAnchor.constraint(equalToConstant: 300).isActive = true
        phoneInput.heightAnchor.constraint(equalToConstant: 55).isActive = true
        phoneInput.translatesAutoresizingMaskIntoConstraints = false
        
        passwordInput.bottomAnchor.constraint(equalTo: form.bottomAnchor).isActive = true
        passwordInput.centerXAnchor.constraint(equalTo: form.centerXAnchor).isActive = true
        passwordInput.widthAnchor.constraint(equalToConstant: 300).isActive = true
        passwordInput.heightAnchor.constraint(equalToConstant: 55).isActive = true
        passwordInput.topAnchor.constraint(equalTo: phoneInput.bottomAnchor, constant: 70).isActive = true
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        
        phoneLabel.topAnchor.constraint(equalTo: phoneInput.bottomAnchor, constant: 5).isActive = true
        phoneLabel.leftAnchor.constraint(equalTo: phoneInput.leftAnchor).isActive = true
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordLabel.bottomAnchor.constraint(equalTo: passwordInput.topAnchor, constant: -5).isActive = true
        passwordLabel.rightAnchor.constraint(equalTo: passwordInput.rightAnchor).isActive = true
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc
    private func navToReg(){
        navigationController?.pushViewController(RegViewConroller(), animated: true)
    }
}
