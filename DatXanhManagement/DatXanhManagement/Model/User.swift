//
//  User.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import Foundation


class User {
	private(set) public var emailAddressPersonal:String
	private(set) public var password:String
	private(set) public var firstName:String
	private(set) public var lastName:String
	private(set) public var emailAddressTeam:String
	private(set) public var emailAddressBusiness:String
	private(set) public var emailAddressCompany:String
	
	init(){
		self.emailAddressPersonal = ""
		self.password = ""
		self.firstName = ""
		self.lastName = ""
		self.emailAddressTeam = ""
		self.emailAddressCompany = ""
		self.emailAddressBusiness = ""
	}
	
	func getProject(completion: @escaping([String]) -> Void){
		let strParams: String = "emailAddressPersonal=" + self.emailAddressPersonal
		getJsonUsingPost(strURL: urlGetUserProjects, strParams: strParams) { (json) in
			let projectCodes = json["projects"] as! [String]
			completion(projectCodes)
		}
	}

	func login(userName: String, password: String, completion: @escaping() -> Void){
		let strParams: String = "emailAddressPersonal=" + userName + "&password=" + password
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
				if let emailAddressPersonal: String = userJson["emailAddressPersonal"] as? String {
					self.emailAddressPersonal = emailAddressPersonal
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
				if let emailAddressTeam: String = userJson["emailAddressTeam"] as? String {
					self.emailAddressTeam = emailAddressTeam
				}
				if let emailAddressBusiness: String = userJson["emailAddressBusiness"] as? String {
					self.emailAddressBusiness = emailAddressBusiness
				}
				if let emailAddressCompany: String = userJson["emailAddressCompany"] as? String {
					self.emailAddressCompany = emailAddressCompany
				}
				completion()
			}
		}
	}
	
}
