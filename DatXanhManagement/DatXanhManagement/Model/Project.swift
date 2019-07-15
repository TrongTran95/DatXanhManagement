//
//  Project.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import Foundation

class Project {
	private(set) public var projectCode:String
	private(set) public var projectName:String
	private(set) public var projectStatusID:Int
	private(set) public var projectThumbnail:String
	private(set) public var customerQuantity:Int
	private(set) public var customerList:[Customer]
	
	init() {
		projectCode = ""
		projectName = ""
		//Default is project still working
		projectStatusID = 2
		projectThumbnail = ""
		customerQuantity = 0
		customerList = [Customer]()
	}
	
	//This method will set the value of project code
	func setProjectCode(projectCode: String){
		self.projectCode = projectCode
	}
	
	//This method will get and set customer quantity of project
	func getCustomerQuantityOfProject(){
		let strParams: String = "projectCode=" + self.projectCode
		getJsonUsingPost(strURL: urlGetCustomerQuantityOfProject, strParams: strParams) { (json) in
			let quantity = json["customerQuantity"] as! Int
			self.customerQuantity = quantity
		}
	}
	
	//This method will set the value of project code
	func getCustomerListBaseOnProjectCode(completion: @escaping() -> Void){
		let strParams: String = "projectCode=" + self.projectCode
		getJsonUsingPost(strURL: urlGetCustomerListBaseOnProjectCode, strParams: strParams) { (json) in
			let arrCustomer = json["customers"] as! [[String:Any]]
			//Assign customer list
			for i in 0..<arrCustomer.count {
				let currentJsonCustomer = arrCustomer[i]
				let customer = Customer()
				if let idCustomer = currentJsonCustomer["idCustomer"] as? Int {
					customer.setIDCustomer(idCustomer: idCustomer)
				}
				if let gender = currentJsonCustomer["gender"] as? String {
					customer.setGender(gender: gender)
				}
				if let firstName = currentJsonCustomer["firstName"] as? String {
					customer.setFirstName(firstName: firstName)
				}
				if let lastName = currentJsonCustomer["lastName"] as? String {
					customer.setLastName(lastName: lastName)
				}
				if let dayOfBirth = currentJsonCustomer["dayOfBirth"] as? String {
					customer.setDayOfBirth(dayOfBirth: dayOfBirth)
				}
				if let phoneNumber = currentJsonCustomer["phoneNumber"] as? String {
					customer.setPhoneNumber(phoneNumber: phoneNumber)
				}
				if let email = currentJsonCustomer["email"] as? String {
					customer.setEmail(email: email)
				}
				if let fbAccount = currentJsonCustomer["fbAccount"] as? String {
					customer.setFbAccount(fbAccount: fbAccount)
				}
				if let projectCode = currentJsonCustomer["projectCode"] as? String {
					customer.setProjectCode(projectCode: projectCode)
				}
				if let source = currentJsonCustomer["source"] as? String {
					customer.setSource(source: source)
				}
				if let dateContact = currentJsonCustomer["dateContact"] as? String {
					customer.setDateContact(dateContact: dateContact)
				}
				if let message = currentJsonCustomer["message"] as? String {
					customer.setMessage(message: message)
				}
				if let customerStatusID = currentJsonCustomer["customerStatusID"] as? Int {
					customer.setCustomerStatusID(customerStatusID: customerStatusID)
				}
				self.customerList.append(customer)
			}
			completion()
		}
	}
	
	
	func getProjectInfo(completion: @escaping() -> Void){
		let strParams: String = "projectCode=" + self.projectCode
		getJsonUsingPost(strURL: urlGetProjectInfo, strParams: strParams) { (json) in
			let projectJson = json["project"]! as! Dictionary<String, Any>
			self.projectName = projectJson["projectName"] as! String
			self.projectStatusID = projectJson["projectStatusID"] as! Int
			self.projectThumbnail = projectJson["projectThumbnail"] as! String
			completion()
		}
	}
}
