//
//  wsResponseModels.swift
//  Corp messenger
//
//  Created by Никита Думкин on 10.12.2022.
//

import Foundation

protocol multiplyTypes: Decodable { }

enum wsResponseModels{
    struct wsResponseText: Decodable {
        let route: String
        let payload: String
    }
    
    struct wsResponseNewDialog: Decodable{
        let route: String
        let payload: wsNewDialog
    }
    
    struct wsResponseNewMessage: Decodable{
        let route: String
        let payload: wsNewMessage
    }
    
    //Structs not for primary usage
    struct Message: Decodable {
        let message_id: String
        let user_id: String //phone
        let message_text: String
        let read: Bool
        let edited: Bool
        let time: Int
    }
    
    struct Dialog: Decodable{
        let dialog_id: String
        let dialog_name: String
        let members: [String]
        let messages: [String: Message]?
        let settings: [String: String]?
        let imageBlob: String?
        let tags: [String: String]?
        let admin_id: String?
        let lastMessageTime: Int
    }
    
    struct wsNewDialog: Decodable{
        let newDialog: Dialog
        let allDialogs: [Dialog]
    }
    
    struct wsNewMessage: Decodable{
        let newMessage: Message
        let dialog: Dialog
        let allDialogs: [Dialog]
    }
    
}
