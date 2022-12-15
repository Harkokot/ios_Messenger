//
//  RegViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 08.12.2022.
//

import UIKit
import Photos
import PhotosUI


final class RegViewConroller: UIViewController{
    //MARK: - Variables setup
    private let defaults = UserDefaults.standard
    
    //title
    private let titleLabel = UILabel()
    
    //form
    private let uploadImageButton = UIButton()
    
    private let form = UIScrollView()//UIView()
    private let phoneInput = UITextField()
    private let nameInput = UITextField()
    private let surnameInput = UITextField()
    private let usernameInput = UITextField()
    private let usernameAtLabel = UILabel()
    private let passwordInput = UITextField()
    private let passwordRepeatInput = UITextField()
    
    private let regButton = UIButton()
    
    //image
    var imageType: String = ""
    
    //MARK: - ViewController Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) //сокрытие навбара
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Setup views
    private func setupViews(){
        setupView()
        setupTitleLabel()
        //setupUploadImageButton()
        setupRegButton()
        setupForm()
    }
    
    //MARK: Setup self.view
    private func setupView(){
        self.view.layer.backgroundColor = CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00)
    }
    
    private func setupRegButton(){
        regButton.setTitle("Sign up", for: .normal)
        regButton.setTitleColor(.white, for: .normal)
        regButton.titleLabel?.font = regButton.titleLabel?.font.withSize(25)
        regButton.layer.cornerRadius = 10
        regButton.layer.backgroundColor = CGColor(red: 0.00, green: 0.44, blue: 0.80, alpha: 1.00)
        
        self.view.addSubview(regButton)
        
        
        regButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        regButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        regButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        regButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        regButton.translatesAutoresizingMaskIntoConstraints = false
        regButton.addTarget(self, action: #selector(regButtonPressed), for: .touchUpInside)
    }
    
    private func setupForm(){
        print("Hi")
        setupInputs()
        form.isScrollEnabled = true
        form.contentSize = CGSize(width: 300, height: 800)
        form.isUserInteractionEnabled = true
        self.view.addSubview(form)
        
        form.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        form.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        form.bottomAnchor.constraint(equalTo: regButton.topAnchor, constant: -20).isActive = true
        form.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        form.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        form.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupInputs(){
        let distanceBetweenInputs: CGFloat = 20
        
        //views
        uploadImageButton.setTitle("+", for: .normal)
        uploadImageButton.setTitleColor(UIColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00), for: .normal)
        uploadImageButton.layer.cornerRadius = 50
        uploadImageButton.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        uploadImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        uploadImageButton.contentVerticalAlignment = .center
        uploadImageButton.contentHorizontalAlignment = .center
        uploadImageButton.layer.borderWidth = 2
        uploadImageButton.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        phoneInput.placeholder = "+79876543210"
        phoneInput.textColor = .black
        phoneInput.textAlignment = .left
        phoneInput.font = phoneInput.font?.withSize(25)
        phoneInput.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        phoneInput.layer.cornerRadius = 10
        phoneInput.setLeftPaddingPoints(10)
        phoneInput.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        phoneInput.keyboardType = .phonePad
        
        nameInput.placeholder = "Name"
        nameInput.textColor = .black
        nameInput.textAlignment = .left
        nameInput.font = nameInput.font?.withSize(25)
        nameInput.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        nameInput.layer.cornerRadius = 10
        nameInput.setLeftPaddingPoints(10)
        nameInput.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        nameInput.keyboardType = .asciiCapable
        
        surnameInput.placeholder = "Surname"
        surnameInput.textColor = .black
        surnameInput.textAlignment = .left
        surnameInput.font = surnameInput.font?.withSize(25)
        surnameInput.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        surnameInput.layer.cornerRadius = 10
        surnameInput.setLeftPaddingPoints(10)
        surnameInput.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        surnameInput.keyboardType = .asciiCapable
        
        usernameInput.placeholder = "user_name"
        usernameInput.textColor = .black
        usernameInput.textAlignment = .left
        usernameInput.font = usernameInput.font?.withSize(25)
        usernameInput.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        usernameInput.layer.cornerRadius = 10
        usernameInput.setLeftPaddingPoints(35)
        usernameInput.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        usernameInput.keyboardType = .asciiCapable
        
        usernameAtLabel.text = "@"
        usernameAtLabel.textColor = .black
        usernameAtLabel.textAlignment = .left
        usernameAtLabel.layer.backgroundColor = CGColor(gray: 1, alpha: 0)
        usernameAtLabel.font = usernameAtLabel.font?.withSize(25)

        passwordInput.placeholder = "Password"
        passwordInput.textColor = .black
        passwordInput.textAlignment = .left
        passwordInput.font = passwordInput.font?.withSize(25)
        passwordInput.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        passwordInput.isSecureTextEntry = true
        passwordInput.layer.cornerRadius = 10
        passwordInput.setLeftPaddingPoints(10)
        passwordInput.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        passwordInput.keyboardType = .asciiCapable
        
        passwordRepeatInput.placeholder = "Repeat password"
        passwordRepeatInput.textColor = .black
        passwordRepeatInput.textAlignment = .left
        passwordRepeatInput.font = passwordRepeatInput.font?.withSize(25)
        passwordRepeatInput.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        passwordRepeatInput.isSecureTextEntry = true
        passwordRepeatInput.layer.cornerRadius = 10
        passwordRepeatInput.setLeftPaddingPoints(10)
        passwordRepeatInput.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        passwordRepeatInput.keyboardType = .asciiCapable
        
        //add subView
        form.addSubview(uploadImageButton)
        form.addSubview(phoneInput)
        form.addSubview(nameInput)
        form.addSubview(surnameInput)
        usernameInput.addSubview(usernameAtLabel)
        form.addSubview(usernameInput)
        form.addSubview(passwordInput)
        form.addSubview(passwordRepeatInput)
        
        //Constraints
        uploadImageButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        uploadImageButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        uploadImageButton.topAnchor.constraint(equalTo: form.topAnchor).isActive = true
        uploadImageButton.centerXAnchor.constraint(equalTo: form.centerXAnchor).isActive = true
        uploadImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        uploadImageButton.addTarget(self, action: #selector(pictUpload), for: .touchUpInside)
        
        phoneInput.topAnchor.constraint(equalTo: uploadImageButton.bottomAnchor, constant: distanceBetweenInputs).isActive = true
        phoneInput.centerXAnchor.constraint(equalTo: form.centerXAnchor).isActive = true
        phoneInput.widthAnchor.constraint(equalToConstant: 300).isActive = true
        phoneInput.heightAnchor.constraint(equalToConstant: 55).isActive = true
        phoneInput.translatesAutoresizingMaskIntoConstraints = false
        
        nameInput.topAnchor.constraint(equalTo: phoneInput.bottomAnchor, constant: distanceBetweenInputs).isActive = true
        nameInput.centerXAnchor.constraint(equalTo: form.centerXAnchor).isActive = true
        nameInput.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameInput.heightAnchor.constraint(equalToConstant: 55).isActive = true
        nameInput.translatesAutoresizingMaskIntoConstraints = false
        
        surnameInput.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: distanceBetweenInputs).isActive = true
        surnameInput.centerXAnchor.constraint(equalTo: form.centerXAnchor).isActive = true
        surnameInput.widthAnchor.constraint(equalToConstant: 300).isActive = true
        surnameInput.heightAnchor.constraint(equalToConstant: 55).isActive = true
        surnameInput.translatesAutoresizingMaskIntoConstraints = false
        surnameInput.tag = 1
        surnameInput.delegate = self
        
        usernameAtLabel.centerYAnchor.constraint(equalTo: usernameInput.centerYAnchor).isActive = true
        usernameAtLabel.leftAnchor.constraint(equalTo: usernameInput.leftAnchor, constant: 10).isActive = true
        usernameAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        usernameInput.topAnchor.constraint(equalTo: surnameInput.bottomAnchor, constant: distanceBetweenInputs).isActive = true
        usernameInput.centerXAnchor.constraint(equalTo: form.centerXAnchor).isActive = true
        usernameInput.widthAnchor.constraint(equalToConstant: 300).isActive = true
        usernameInput.heightAnchor.constraint(equalToConstant: 55).isActive = true
        usernameInput.translatesAutoresizingMaskIntoConstraints = false
        usernameInput.tag = 2
        usernameInput.delegate = self
        
        passwordInput.topAnchor.constraint(equalTo: usernameInput.bottomAnchor, constant: distanceBetweenInputs).isActive = true
        passwordInput.centerXAnchor.constraint(equalTo: form.centerXAnchor).isActive = true
        passwordInput.widthAnchor.constraint(equalToConstant: 300).isActive = true
        passwordInput.heightAnchor.constraint(equalToConstant: 55).isActive = true
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        passwordInput.tag = 3
        passwordInput.delegate = self
        
        passwordRepeatInput.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: distanceBetweenInputs).isActive = true
        passwordRepeatInput.centerXAnchor.constraint(equalTo: form.centerXAnchor).isActive = true
        passwordRepeatInput.widthAnchor.constraint(equalToConstant: 300).isActive = true
        passwordRepeatInput.heightAnchor.constraint(equalToConstant: 55).isActive = true
        passwordRepeatInput.translatesAutoresizingMaskIntoConstraints = false
        passwordRepeatInput.tag = 4
        passwordRepeatInput.delegate = self
        
    }
    
    private func setupTitleLabel(){
        titleLabel.text = "registration"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = titleLabel.font.withSize(50)
        
        self.view.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Fetch
    @objc
    private func regButtonPressed(){
        let phone = phoneInput.text
        let name = nameInput.text
        let surname = surnameInput.text
        let username = usernameInput.text
        let password = passwordInput.text
        let passwordRepeat = passwordRepeatInput.text
        let image = uploadImageButton.imageView?.image
        
        guard var phone = phone else{return}
        guard let name = name else{return}
        guard let surname = surname else{return}
        guard let username = username else{return}
        guard let password = password else{return}
        guard let passwordRepeat = passwordRepeat else{return}
        guard let image = image else{return}
        
        let imageBASE64 = UIImage.convertImageToBase64String(img: image, imageExtension: imageType)
        let phoneLenght = phone.count
        
        if 10...12 ~= phoneLenght && name.count > 0 && surname.count > 0 && username.count > 0 && password.count > 0 && password == passwordRepeat{
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
            
            fetchRegistration(phone: phone, name: name, surname: surname, username: username, password: password, imageBASE64: imageBASE64)
        }
        else{
            if phoneLenght < 10 || phoneLenght > 12{
                phoneInput.layer.borderWidth = 2
            }
            
            if name.count == 0{
                nameInput.layer.borderWidth = 2
            }
            
            if surname.count == 0{
                surnameInput.layer.borderWidth = 2
            }
            
            if username.count == 0{
                usernameInput.layer.borderWidth = 2
            }
            
            if password.count == 0{
                passwordInput.layer.borderWidth = 2
                passwordRepeatInput.text = ""
            }
            
            if passwordRepeat.count == 0{
                passwordRepeatInput.layer.borderWidth = 2
            }
            
            if passwordRepeat != password{
                passwordInput.layer.borderWidth = 2
                passwordRepeatInput.layer.borderWidth = 2
                
                passwordInput.text = ""
                passwordRepeatInput.text = ""
            }
        }
        
        
        
    }
    
    private func fetchRegistration(phone: String, name: String, surname: String, username: String, password: String, imageBASE64: String){
        
        let parameters: [String: Any] = [
            "phone": phone,
            "password": password,
            "name": name,
            "surname": surname,
            "username": username,
            "imageBASE64": imageBASE64
        ]
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        URLSession.dataFetch(url: "/auth/reg", headers: headers, body: parameters, requestType: .POST){ statusCode, data in
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
                    //self.setInputsError()
                }
            }
        }
    }
    
}

//MARK: - UITextFiledDelegate
extension RegViewConroller: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1{
            form.scrollToBottom(animated: true)
            print("Move")
        }
//        else if textField.tag == 2{
//            UIView.animate(withDuration: 0.2, animations: {
//                self.view.transform = self.view.transform.translatedBy(x: 0, y: -105)
//            })
//        }
//        else if textField.tag == 3{
//            UIView.animate(withDuration: 0.2, animations: {
//                self.view.transform = self.view.transform.translatedBy(x: 0, y: -135)
//            })
//        }
//        else if textField.tag == 4{
//            UIView.animate(withDuration: 0.2, animations: {
//                self.view.transform = self.view.transform.translatedBy(x: 0, y: -140)
//            })
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.tag == 1{
//            UIView.animate(withDuration: 0.2, animations: {
//                self.view.transform = self.view.transform.translatedBy(x: 0, y: 30)
//            })
//        }
//        else if textField.tag == 2{
//            UIView.animate(withDuration: 0.2, animations: {
//                self.view.transform = self.view.transform.translatedBy(x: 0, y: 105)
//            })
//        }
//        else if textField.tag == 3{
//            UIView.animate(withDuration: 0.2, animations: {
//                self.view.transform = self.view.transform.translatedBy(x: 0, y: 135)
//            })
//        }
//        else if textField.tag == 4{
//            UIView.animate(withDuration: 0.2, animations: {
//                self.view.transform = self.view.transform.translatedBy(x: 0, y: 140)
//            })
//        }
        
        if textField.tag == 4{
            form.setContentOffset(.zero, animated: true)
        }
    }
}

//MARK: - Photo Piker
extension RegViewConroller: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    let uploadingImage = UIImage.cropToBounds(image: image, width: 1000, height: 1000)
                    self.uploadImageButton.setImage(uploadingImage, for: .normal)
                    self.uploadImageButton.imageView?.layer.cornerRadius = 50
                    // TODO: - Here you get UIImage
                }
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] url, _ in
                    // TODO: - Here you get URL of image
                    if let url = url{
                        DispatchQueue.main.sync {
                            guard let imgExtension = url.typeIdentifier?.components(separatedBy: ".")[1] else{return}
                            self?.imageType = imgExtension
                        }
                    }
                }
            }
        }
    }
    
    @objc
    func pictUpload(){
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images])
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
}
