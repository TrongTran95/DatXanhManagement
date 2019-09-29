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
	
	//Use this function to copy a new user email detail list
	func setUserEmailDetailList(userEmailDetailList: [UserEmailDetail]){
		self.userEmailDetailList = []
		for ued in userEmailDetailList {
			self.userEmailDetailList.append(UserEmailDetail(id: ued.id, emailPersonal: ued.emailPersonal, orderNumber: ued.orderNumber, receiveQuantity: ued.receiveQuantity))
		}
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

	func login(userName: String, password: String, ios_token: String, completion: @escaping(Bool) -> Void){
		let strParams: String = "emailAddress=" + userName + "&password=" + password + "&ios_token=" + ios_token
		getJsonUsingPost(strURL: urlLogin, strParams: strParams) { (json) in
			var errorExist:Bool!
			//Get the error json
			errorExist = json["error"] as! Bool?
			//Check if any error
			if errorExist == true{
				print(json["message"] as! String)
				completion(false)
			} else {
				//Login information is correct
				let userJson:[String:Any] = json["user"] as! [String : Any]
                print(userJson)
				if let emailAddress: String = userJson["emailAddress"] as? String {
					self.emailAddress = emailAddress
				}
                if let type: Int = userJson["type"] as? Int {
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
				completion(true)
			}
		}
	}
    
    
	
	//Remove user email detail from database
	func removeUserEmailDetail(id: Int, completion:@escaping(Bool) -> Void){
		let strParams: String = "id=\(id)"
		getJsonUsingPost(strURL: urlRemoveUserEmailDetail, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	//Update order of user email detail in database
	func updateUEDOrderNumber(userEmailDetail:UserEmailDetail, completion:@escaping(Bool) -> Void){
		let strParams: String = "id=\(userEmailDetail.id)" + "&orderNumber=\(userEmailDetail.orderNumber)"
		getJsonUsingPost(strURL: urlUpdateUserEmailDetailOrderNumber, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	//Update receive quantity of user email detail in database
	func updateUEDReceiveQuantity(id: Int, receiveQuantity: Int, completion:@escaping(Bool) -> Void){
		let strParams: String = "id=\(id)" + "&receiveQuantity=\(receiveQuantity)"
		getJsonUsingPost(strURL: urlUpdateUserEmailDetailReceiveQuantity, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	
}
