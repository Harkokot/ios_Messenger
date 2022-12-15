//
//  File.swift
//  Corp messenger
//
//  Created by Никита Думкин on 14.12.2022.
//

import UIKit

final class MessageView: UIView{
    
    enum sender{
        case user, companion
    }
    
    let messageText: UITextView = {
        let tempLabel = UITextView(frame: .zero, textContainer: .none)
        
        tempLabel.text = ""
        tempLabel.textColor = .white
        tempLabel.textAlignment = .left
//        tempLabel.textContainerInset.top = 0
//        tempLabel.textContainerInset.left = 0
        tempLabel.isEditable = false
        tempLabel.backgroundColor = .clear
        tempLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        tempLabel.textContainer.lineBreakMode = .byWordWrapping
        tempLabel.isScrollEnabled = false
        //tempLabel.textContainer.lineFragmentPadding = 5
        tempLabel.layer.cornerRadius = 5
        
        return tempLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(messageText)
        self.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    func configure(sender: sender, text: String){
        
        messageText.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        messageText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        messageText.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        messageText.translatesAutoresizingMaskIntoConstraints = false
        
        messageText.text = text
        
        if sender == .user{
            messageText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
            messageText.backgroundColor = .green
        }
        else{
            messageText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
            messageText.backgroundColor = .black
        }
    }
}
