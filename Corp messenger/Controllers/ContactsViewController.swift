//
//  ContactsViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 09.12.2022.
//

import UIKit

final class ContactsViewController: UIViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false) //сокрытие навбара
        navigationController?.navigationBar.topItem?.title = "Contacts"
        navigationController?.navigationBar.topItem?.titleView?.tintColor = .white
        navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.backgroundColor = CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Contacts")
    }
    
}
