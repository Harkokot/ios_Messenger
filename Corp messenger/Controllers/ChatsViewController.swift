//
//  MessagesViewController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 09.12.2022.
//

import UIKit

final class ChatsViewController: UIViewController{
    
    private let label = UILabel()
    //private let temp = UITableView(frame: .zero, style: .plain)
    private let temp = UIView()
    
    private let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(barBurronTapped))
    
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
        self.view.layer.backgroundColor = CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00)
        
        temp.layer.backgroundColor = CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00)
        
        self.view.addSubview(temp)
        
        temp.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        temp.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        temp.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        temp.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    
    @objc
    func barBurronTapped(){
        
    }
    
}
