//
//  User.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import Foundation


class User {
	private(set) public var emailAddress:String
    private(set) public var type:Int
	private(set) public var password:String
	private(set) public var firstName:String
    private(set) public var lastName:String
    private(set) public var ios_token:String
    private(set) public var userEmailDetailList: [UserEmailDetail]
	
	init(){
		self.emailAddress = ""
        self.type = 0
		self.password = ""
		self.firstName = ""
		self.lastName = ""
		self.ios_token = ""
        self.userEmailDetailList = []
	}
    
    func setUserEmailDetailList(newUEDL: [UserEmailDetail]) {
        self.userEmailDetailList = newUEDL
    }
    
    //Use this function to remove a user email detail
    func removeUserEmailDetail(at position: Int) {
        self.userEmailDetailList.remove(at: position)
    }
    
    //Use this function to add a new user email detail to a specific position
    func insertUserEmailDetail(_ newUserEmailDetail: UserEmailDetail,at position: Int) {
        self.userEmailDetailList.insert(newUserEmailDetail, at: position)
    }
    
    //Use this function to reset all user email detail that got from server
    func resetUserEmailDetailList(){
        self.userEmailDetailList = []
    }
	
	func getUserProjects(completion: @escaping([String]) -> Void){
		let strParams: String = "emailTeam=" + self.emailAddress
		getJsonUsingPost(strURL: urlGetUserProjects, strParams: strParams) { (json) in
			let projectJson = json["projects"] as! [String]
			completion(projectJson)
		}
	}

	func login(userName: String, password: String, completion: @escaping() -> Void){
		let strParams: String = "emailAddress=" + userName + "&password=" + password
		print(strParams)
		getJsonUsingPost(strURL: urlLogin, strParams: strParams) { (json) in
			var errorExist:Bool!
			//Get the error json
			errorExist = json["error"] as! Bool?
			//Check if any error
			if errorExist == true{
				print(json["message"] as! String)
			} else {
				//Login information is correct
				let userJson:[String:Any] = json["user"] as! [String : Any]
                print(userJson)
				if let emailAddress: String = userJson["emailAddress"] as? String {
					self.emailAddress = emailAddress
				}
                if let type: Int = userJson["type"] as? Int {
                    print(type)
                    self.type = type
                }
				if let password: String = userJson["password"] as? String {
					self.password = password
				}
				if let firstName: String = userJson["firstName"] as? String {
					self.firstName = firstName
				}
				if let lastName: String = userJson["lastName"] as? String {
					self.lastName = lastName
				}
				if let ios_token: String = userJson["ios_token"] as? String {
					self.ios_token = ios_token
				}
//                self.ios_token = userJson["ios_token"] as? String ?? ""
				completion()
			}
		}
	}
    
    func getUserEmailDetailList(projectName: String, completion: @escaping () -> Void){
        let strParams: String = "emailTeam=" + self.emailAddress + "&projectName=" +  projectName
        getJsonUsingPost(strURL: urlGetUserEmailDetailList, strParams: strParams) { (json) in
            print(json)
            let userJson = json["userEmailDetailList"] as! [[String:Any]]
            for userEmailDetail in userJson {
                let newUED = UserEmailDetail()
                newUED.setID(id: userEmailDetail["id"] as? Int ?? 0)
                newUED.setEmailPersonal(emailPersonal: userEmailDetail["emailPersonal"] as? String ?? "")
                newUED.setOrderNumber(orderNumber: userEmailDetail["orderNumber"] as? Int ?? 0)
                newUED.setReceiveQuantity(receiveQuantity: userEmailDetail["receiveQuantity"] as? Int ?? 0)
                self.userEmailDetailList.append(newUED)
            }
            completion()
        }
    }
	
}
