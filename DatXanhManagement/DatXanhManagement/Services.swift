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
	
	func getUserEmailDetailList(emailTeam: String, projectName: String, completion: @escaping ([UserEmailDetail]) -> Void){
		var userEmailDetailList: [UserEmailDetail] = []
		let strParams: String = "emailTeam=" + emailTeam + "&projectName=" +  projectName
		getJsonUsingPost(strURL: urlGetUserEmailDetailList, strParams: strParams) { (json) in
			let userJson = json["userEmailDetailList"] as! [[String:Any]]
			for userEmailDetail in userJson {
				let newUED = UserEmailDetail()
				newUED.setID(id: userEmailDetail["id"] as? Int ?? 0)
				newUED.setEmailPersonal(emailPersonal: userEmailDetail["emailPersonal"] as? String ?? "")
				newUED.setOrderNumber(orderNumber: userEmailDetail["orderNumber"] as? Int ?? 0)
				newUED.setReceiveQuantity(receiveQuantity: userEmailDetail["receiveQuantity"] as? Int ?? 0)
				userEmailDetailList.append(newUED)
			}
			//Sort user email detail list by order number
			userEmailDetailList = userEmailDetailList.sorted(by: { $0.orderNumber < $1.orderNumber })
			
			completion(userEmailDetailList)
		}
	}
    
    func addUserEmailDetail(count: Int, emailTeam: String, emailPersonal: [String], projectName: String, completion: @escaping (Bool) -> Void){
        let strParams = "emailTeam=" + emailTeam + "&emailPersonal=" + emailPersonal[count] + "&projectName=" + projectName
        getJsonUsingPost(strURL: urlAddUserEmailDetail, strParams: strParams) { (json) in
            if (count < emailPersonal.count - 1) {
                if !(json["error"] as! Bool) {
                    self.addUserEmailDetail(count: count + 1, emailTeam: emailTeam, emailPersonal: emailPersonal, projectName: projectName, completion: { (flag) in
                        completion(json["error"] as! Bool)
                    })
                } else {
                    completion(json["error"] as! Bool)
                    return
                }
            }
            else {
                completion(json["error"] as! Bool)
                return
            }
        }
    }
	
	func getUserProjects(emailTeam: String, completion: @escaping([String]) -> Void){
		let strParams: String = "emailTeam=" + emailTeam
		getJsonUsingPost(strURL: urlGetUserProjects, strParams: strParams) { (json) in
			let projectJson = json["projects"] as! [String]
			completion(projectJson)
		}
	}
    
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
	
	func removeUserMember(emailTeam: String, emailPersonal: String, completion: @escaping (Bool) -> Void){
		let strParams = "emailTeam=" + emailTeam + "&emailPersonal=" + emailPersonal
		getJsonUsingPost(strURL: urlRemoveUserMember, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
}
