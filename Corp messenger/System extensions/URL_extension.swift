//
//  URL_extension.swift
//  Corp messenger
//
//  Created by Никита Думкин on 09.12.2022.
//

import Foundation

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
}
