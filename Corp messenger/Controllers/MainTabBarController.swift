//
//  MainTabBarController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 09.12.2022.
//

import UIKit

final class MainTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTabBar()
        setupTabBar()
    }
    
    private func generateTabBar(){
        viewControllers = [
            generateVC(viewController: ContactsViewController(), title: "Contacts", image: UIImage(systemName: "person.3.fill")),
            generateVC(viewController: ChatsViewController(), title: "Chats", image: UIImage(systemName: "message.fill")),
            generateVC(viewController: SettingsViewController(), title: "Settings", image: UIImage(systemName: "gear.circle.fill"))
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController{
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setupTabBar(){
        self.tabBar.backgroundColor = UIColor(cgColor: CGColor(red: 0.13, green: 0.39, blue: 0.60, alpha: 1.00))
        self.tabBar.tintColor = UIColor(red: 1.00, green: 0.90, blue: 0.00, alpha: 1.00)
        self.tabBar.unselectedItemTintColor = .white
        //self.tabBar.barTintColor = .darkGray
    }
}

//extension MainTabBarController: UITabBarControllerDelegate  {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
//          return false // Make sure you want this as false
//        }
//
//        if fromView != toView {
//            UIView.transition(from: fromView, to: toView, duration: 1.0, options: [.transitionFlipFromLeft], completion: nil)
//        }
//
//        return true
//    }
//}
