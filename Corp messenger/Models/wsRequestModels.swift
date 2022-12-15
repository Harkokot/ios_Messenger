//
//  wsRequestModels.swift
//  Corp messenger
//
//  Created by Никита Думкин on 15.12.2022.
//

import Foundation

enum wsRequestModels{
    struct wsRequestText: Encodable {
        let route: String
        let payload: String
    }
    
    struct wsRequestNewDialog: Encodable{
        let route: String
        let payload: members
    }
    
    struct wsRequestNewMessage: Encodable{
        let route: String
        let payload: message
    }
    
    struct members: Encodable{
        let members: [String]
    }
    
    struct message: Encodable{
        let dialog_id: String
        let user_id: String
        let message_text: String
    }
}
