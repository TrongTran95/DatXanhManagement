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
	
	func removeAllUserEmailSeperateStillNotReceived(emailTeam: String, projectName: String, completion: @escaping (Bool) -> Void){
		let strParams = "emailTeam=" + emailTeam + "&projectName=" + projectName
		getJsonUsingPost(strURL: urlRemoveAllUserEmailSeperateStillNotReceived, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func getUserEmailSeperateListStillNotReceive(emailTeam: String, projectName: String, completion: @escaping ([UserEmailSeperate]) -> Void){
		let strParams = "emailTeam=" + emailTeam + "&projectName=" + projectName
		getJsonUsingPost(strURL: urlGetUserEmailSeperateListStillNotReceive, strParams: strParams) { (json) in
			let list = json["userEmailSeperateList"] as! [[String:Any]]
			var userEmailSeperateList: [UserEmailSeperate] = []
			for userEmailSeperate in list {
				let newUserEmailSeperate = UserEmailSeperate()
				newUserEmailSeperate.setEmailPersonal(emailPersonal: userEmailSeperate["emailPersonal"] as? String ?? "")
				newUserEmailSeperate.setOrderNumber(orderNumber: Int(userEmailSeperate["orderNumber"] as? String ?? "0")!)
				userEmailSeperateList.append(newUserEmailSeperate)
			}
			userEmailSeperateList.sort(by: {$0.orderNumber < $1.orderNumber})
			completion(userEmailSeperateList)
		}
	}
	
	func addUserEmailSeperate(emailTeam: String, userEmailDetailList: [UserEmailDetail], projectName: String, multiplier: Int, completion: @escaping () -> Void){
		
		//Get max number first
		getJsonUsingGet(strURL: urlGetUserEmailSeperateMaxOrder) { (json) in
			var maxOrder = 0
			let strMaxOrder = json["maxOrder"] as? String ?? "0"
			if (strMaxOrder != "0") {
				maxOrder = Int(strMaxOrder)!
			}

			let dispatchGroup = DispatchGroup()
			//Loop times to add seperate list
			for _ in 0..<multiplier {
				//Add data to Database process --------
				for userEmailDetail in userEmailDetailList {
					//Add user base on receive quantity
					for _ in 0..<userEmailDetail.receiveQuantity{
						dispatchGroup.enter()
						//Increse order number
						maxOrder += 1
						//Add data
						let strParams = "emailTeam=" + emailTeam + "&emailPersonal=" + userEmailDetail.emailPersonal + "&projectName=" + projectName + "&orderNumber=\(maxOrder)"
						getJsonUsingPost(strURL: urlAddUserEmailSeperate, strParams: strParams) { (json) in
							print("aaaa")
							dispatchGroup.leave()
						}
					}
				}
				//Add data to Database process --------
			}
			
			dispatchGroup.notify(queue: .main) {
				print("bbbb")
				completion()
			}
		}
	}
	
	
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
	
	//Add user email detail (recursion)
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
	
	func getUserProjects(emailAddress: String, completion: @escaping([[String:Any]]) -> Void){
		let strParams: String = "email=" + emailAddress
		getJsonUsingPost(strURL: urlGetUserProjects, strParams: strParams) { (json) in
			let projectJson = json["userProjects"] as! [[String:Any]]
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
	
	func getAllUser(completion: @escaping ([User]) -> ()){
		getJsonUsingGet(strURL: urlGetAllUser) { (json) in
			let usersJson = json["users"] as! [[String:Any]]
			var users: [User] = []
			for user in usersJson {
				let newUser = User()
				newUser.setEmailAddress(emailAddress: user["emailAddress"] as? String ?? "")
				newUser.setType(type: user["type"] as? Int ?? 0)
				newUser.setLastName(lastName: user["lastName"] as? String ?? "")
				newUser.setFirstName(firstName: user["firstName"] as? String ?? "")
				users.append(newUser)
			}
			users = users.sorted(by: {$0.type > $1.type})
			completion(users)
		}
	}
}
