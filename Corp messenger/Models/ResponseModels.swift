//
//  ResponseModels.swift
//  Corp messenger
//
//  Created by Никита Думкин on 08.12.2022.
//

import Foundation

enum ResponseModels{
    struct loginResponse: Decodable {
        let message: String
        let token: String
    }
    
    struct userDataResponse: Decodable{
        let message: String
        let data: userData
    }
    
    struct userData: Decodable{
        let username: String
        let name: String
        let surname: String
        let imageBlob: String
        let lastTimeOnline: String
        let isOnline: Bool
        let phone: String
    }
    
}
