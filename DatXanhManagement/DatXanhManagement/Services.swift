//
//  Services.swift
//  DatXanhManagement
//
//  Created by ivc on 8/19/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class Services {
    public static let shared = Services()
    
    private init(){}
    
    func addNewUserMember(emailTeam: String, emailPersonal: String, completion: @escaping (Bool) -> Void) {
        let strParams = "emailTeam=" + emailTeam + "&emailPersonal=" + emailPersonal
        getJsonUsingPost(strURL: urlAddUserMember, strParams: strParams) { (json) in
            completion(json["error"] as! Bool)
        }
    }
    
    func getUserMemberList(emailTeam: String, completion: @escaping ([[String:Any]]) -> Void){
        let strParams = "emailTeam=" + emailTeam
        getJsonUsingPost(strURL: urlGetUserMemberList, strParams: strParams) { (json) in
            completion(json["userMemberList"] as! [[String:Any]])
        }
    }
    
    func checkUserExist(emailTeam: String, emailPersonal: String, completion: @escaping (Bool) -> Void){
        let strParams = "emailTeam=" + emailTeam + "&emailPersonal=" + emailPersonal
        getJsonUsingPost(strURL: urlCheckUserExist, strParams: strParams) { (json) in
            completion(json["error"] as! Bool)
        }
    }
}
