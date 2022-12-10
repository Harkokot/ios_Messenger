//
//  SettingsViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 09.12.2022.
//

import UIKit

final class SettingsViewController: UIViewController{
    private let defaults = UserDefaults.standard
    
    private let userImage = UIImageView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false) //сокрытие навбара
        navigationController?.navigationBar.topItem?.title = "Settings"
        navigationController?.navigationBar.topItem?.titleView?.tintColor = .white
        navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00)
        
        //test
        userImage.layer.cornerRadius = 75
        userImage.clipsToBounds = true
        
        self.view.addSubview(userImage)
        
        userImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        userImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        fetchUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Settings")
    }
    
    private func fetchUserData(){
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
                    DispatchQueue.main.async {
                        self.userImage.image = UIImage.convertBase64StringToImage(imageBase64String: responseJSON.data.imageBlob)
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
    
}
