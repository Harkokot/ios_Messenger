//
//  CoreData_extension.swift
//  Corp messenger
//
//  Created by Никита Думкин on 15.12.2022.
//

import CoreData
import UIKit

final class CoreDataBase{
    
    static func deleteAllData()
    {
        let arr = ["User", "Message", "Dialog"]
        for entity in arr{
            if let delegate = UIApplication.shared.delegate as? AppDelegate{
                let context = delegate.persistentContainer.viewContext
                
                let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
                do { try context.execute(DelAllReqVar) }
                catch { print(error) }
            }
        }
    }
}
