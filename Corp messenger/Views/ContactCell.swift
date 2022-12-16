//
//  ContactCell.swift
//  Corp messenger
//
//  Created by Никита Думкин on 16.12.2022.
//

import UIKit

final class ContactCell: UITableViewCell{
    
    let nameLabel: UILabel = {
        let tempLabel = UILabel()
        
        tempLabel.text = ""
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 20)
        
        
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
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func setupViews(){
        self.backgroundColor = UIColor(cgColor: CGColor(red: 0.09, green: 0.25, blue: 0.38, alpha: 1.00))
        
        addSubview(nameLabel)
        addSubview(image)
        
        image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        image.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        //image.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(nameSurname: String, image: UIImage){
        nameLabel.text = nameSurname
        self.image.image = image
    }
    
}
