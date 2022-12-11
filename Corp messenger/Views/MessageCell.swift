//
//  MessageCell.swift
//  Corp messenger
//
//  Created by Никита Думкин on 10.12.2022.
//

import UIKit

final class MessageCell: UITableViewCell{
    
    let nameLabel: UILabel = {
        let tempLabel = UILabel()
        
        tempLabel.text = ""
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 15)
        
        
        return tempLabel
    }()
    
    let lastMessageLabel: UITextView = {
        let tempLabel = UITextView(frame: .zero, textContainer: .none)
        
        tempLabel.text = ""
        tempLabel.textColor = .lightGray
        tempLabel.textAlignment = .left
        tempLabel.textContainerInset.top = 0
        tempLabel.textContainerInset.left = 0
        tempLabel.backgroundColor = .clear
        tempLabel.font = UIFont.systemFont(ofSize: 15)
        tempLabel.textContainer.maximumNumberOfLines = 2
        //tempLabel.textContainer.lineBreakMode = .byTruncatingHead
        tempLabel.textContainer.lineBreakMode = .byTruncatingTail
        tempLabel.isScrollEnabled = false
        
        
        return tempLabel
    }()
    
    let readIndicator: UIView = {
        let tempLabel = UIView()
        
        tempLabel.backgroundColor = .white
        tempLabel.layer.cornerRadius = 5
        
        return tempLabel
    }()
    
    let image: UIImageView = {
        let tempLabel = UIImageView()
        
        tempLabel.layer.cornerRadius = 30
        tempLabel.clipsToBounds = true
        
        return tempLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        //дальнейшие настройки
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func setupViews(){
        self.backgroundColor = UIColor(cgColor: CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00))
        
        addSubview(nameLabel)
        addSubview(lastMessageLabel)
        addSubview(readIndicator)
        addSubview(image)
        
        image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        image.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        //image.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        lastMessageLabel.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 5).isActive = true
        lastMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        lastMessageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        lastMessageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        readIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //readIndicator.leftAnchor.constraint(equalTo: lastMessageLabel.rightAnchor, constant: 10).isActive = true
        readIndicator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -13).isActive = true
        readIndicator.widthAnchor.constraint(equalToConstant: 10).isActive = true
        readIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true
        readIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(nameSurname: String, image: UIImage, lastMessage: String){
        nameLabel.text = nameSurname
        self.image.image = image
        lastMessageLabel.text = lastMessage
    }
    
    func readen(_ isReaden: Bool){
        self.readIndicator.isHidden = isReaden
    }
    
}
