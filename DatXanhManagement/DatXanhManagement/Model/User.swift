//
//  User.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import Foundation


class User {
	private(set) public var emailTeam:String
	private(set) public var password:String
	private(set) public var firstName:String
	private(set) public var lastName:String
	private(set) public var emailPersonal:String
	private(set) public var emailBusiness:String
	private(set) public var emailCompany:String
	
	init(){
		self.emailTeam = ""
		self.password = ""
		self.firstName = ""
		self.lastName = ""
		self.emailPersonal = ""
		self.emailBusiness = ""
		self.emailCompany = ""
	}
	
	func getUserProjects(completion: @escaping([String]) -> Void){
		let strParams: String = "emailTeam=" + self.emailTeam
		getJsonUsingPost(strURL: urlGetUserProjects, strParams: strParams) { (json) in
			let projectJson = json["projects"] as! [String]
			completion(projectJson)
		}
	}

	func login(userName: String, password: String, completion: @escaping() -> Void){
		let strParams: String = "emailTeam=" + userName + "&password=" + password
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
				if let emailTeam: String = userJson["emailTeam"] as? String {
					self.emailTeam = emailTeam
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
				if let emailPersonal: String = userJson["emailPersonal"] as? String {
					self.emailPersonal = emailPersonal
				}
				if let emailBusiness: String = userJson["emailBusiness"] as? String {
					self.emailBusiness = emailBusiness
				}
				if let emailCompany: String = userJson["emailCompany"] as? String {
					self.emailCompany = emailCompany
				}
				completion()
			}
		}
	}
	
}
