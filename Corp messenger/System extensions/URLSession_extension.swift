//
//  fetchController.swift
//  Corp messenger
//
//  Created by Никита Думкин on 08.12.2022.
//

import Foundation

extension URLSession{
    
    enum requestType{
        case GET
        case POST
    }
    
    enum urls: String{
        case DEV = "http://10.192.240.149:3000"
        case PROD = "https://nikitadumkin.fun/iOS" //TODO: Поменять
    }
    
    static func dataFetch(url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, body: [String: Any]? = nil, requestType: requestType, completion: @escaping (Int, Data) -> ()){
        
        //MARK: - Setting up query params
        var urlWithParams = url
        if let parameters = parameters{
            urlWithParams += "?"
            for (name, value) in parameters{
                urlWithParams += name + "=" + value + "&"
            }
            urlWithParams.remove(at: urlWithParams.index(before: urlWithParams.endIndex))
        }
        
        //MARK: - Setting up request URL
        let url = URL(string: urls.DEV.rawValue + urlWithParams)
        guard let url else {return}
        var request = URLRequest(url: url)
        
        //MARK: - Setting up request HEADERS
        if let headers = headers{
            for (headerType, headerContent) in headers{
                request.setValue(headerContent, forHTTPHeaderField: headerType)
            }
        }
        
        //MARK: - Setting up request METHOD
        switch requestType{
        case .GET:
            request.httpMethod = "GET"
            break
        case .POST:
            request.httpMethod = "POST"
        }
        
        //MARK: - Setting up request QUERY
        //TODO: Сделать возможность добавлять к запросу параметры
        
        //MARK: - Setting up request BODY
        if let parameters = body{
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(503, Data())
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                completion(httpResponse.statusCode, data)
            }
        }
        
        task.resume()
    }
}
