//
//  wsResponseModels.swift
//  Corp messenger
//
//  Created by Никита Думкин on 10.12.2022.
//

import Foundation

enum wsResponseModels{
    struct wsModel: Decodable {
        let route: String
        let payload: String
    }
    
    struct Message: Decodable {
        let message_id: String
        let user_id: String //phone
        let message_text: String
        let type: String
        let read: Bool
        let edited: Bool
        let media: String?
        let time: Int
        let tags: String?
    }
    
    struct Dialog: Decodable{
        let dialog_id: String
        let dialog_name: String
        let type: String
        let members: [String]
        let messages: [String: Message]?
        let settings: [String: String]?
        let imageBlob: String?
        let tags: [String: String]?
        let admin_id: String?
        let lastMessageTime: Int
    }
    
    struct wsResponseNewDialog: Decodable{
        let newDialog: Dialog
        let allDialogs: [Dialog]
    }
    
    struct wsResponseNewMessage: Decodable{
        let newMessage: Message
        let dialog: Dialog
        let allDialogs: [Dialog]
    }
    
}
