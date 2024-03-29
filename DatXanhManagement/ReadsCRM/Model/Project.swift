//
//  Project.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import Foundation

class Project {
	private(set) public var name:String
	private(set) public var emailTeam:String
	private(set) public var thumbnail:String
	
	private(set) public var customerQuantity:Int
	private(set) public var customerStillNotContactQuantity:Int
	private(set) public var customerListSeperated:[String:[Customer]]
	
	init() {
		self.name = ""
		self.thumbnail = ""
		self.emailTeam = ""
		
		self.customerQuantity = 0
		self.customerStillNotContactQuantity = 0
		self.customerListSeperated = [KEY_STILL_NOT:[], KEY_ALREADY:[]]
	}
	
	//This method will set the value of project name
	func setName(projectName: String){
		self.name = projectName
	}
	
	func setEmailTeam(emailTeam: String) {
		self.emailTeam = emailTeam
	}
	
	//Check and reset customer list
	func checkAndResetCustomerList(){
		if (self.customerListSeperated[KEY_STILL_NOT]?.count != 0 || self.customerListSeperated[KEY_ALREADY]?.count != 0) {
			customerListSeperated = [KEY_STILL_NOT:[], KEY_ALREADY:[]]
		}
	}
	
	//If url = urlGetCustomerQuantity: This method will get and set customer quantity of project
	//If url = customerStillNotContactQuantity: This method will get and set the quantity of customer that still not contact yet
	func getCustomerQuantity(url: String, emailPersonal: String, emailTeam: String, completion: @escaping() -> Void){
		let strParams: String = "emailTeam=" + emailTeam + "&emailPersonal=" + emailPersonal
		print("aaaaa\(strParams)")
		getJsonUsingPost(strURL: url, strParams: strParams) { (json) in
			let quantity = json["quantity"] as! Int
			if (url == urlGetCustomerQuantity) {
				self.customerQuantity = quantity
			} else {
				self.customerStillNotContactQuantity = quantity
			}
			completion()
		}
	}
	
	//This method will get all information of customer and return a list of them
	func getCustomerList(emailTeam: String, emailAddress: String, completion: @escaping() -> Void){
		let strParams: String = "emailTeam=" + emailTeam + "&emailPersonal=" + emailAddress
		print(strParams)
		getJsonUsingPost(strURL: urlGetCustomerList, strParams: strParams) { (json) in
			let arrCustomer = json["customers"] as! [[String:Any]]
			if (arrCustomer.count == 0) {
				completion()
				return
			}
			//Assign customer list
			for i in 0..<arrCustomer.count {
				let currentJsonCustomer = arrCustomer[i]
				let customer = Customer()
				
				//Set customer detail
				if let idCustomer = currentJsonCustomer["idCustomer"] as? Int {
					customer.setIDCustomer(idCustomer: idCustomer)
				}
				if let messageCode = currentJsonCustomer["messageCode"] as? String {
					customer.setMessageCode(messageCode: messageCode)
				}
				if let projectName = currentJsonCustomer["projectName"] as? String {
					customer.setProjectName(projectName: projectName)
				}
				if let source = currentJsonCustomer["source"] as? String {
					customer.setSource(source: source)
				}
				if let dateContact = currentJsonCustomer["dateContact"] as? String {
					customer.setDateContact(dateContact: dateContact)
				}
				if let gender = currentJsonCustomer["gender"] as? String {
					customer.setGender(gender: gender)
				}
				if let lastName = currentJsonCustomer["lastName"] as? String {
					customer.setLastName(lastName: lastName)
				}
				if let firstName = currentJsonCustomer["firstName"] as? String {
					customer.setFirstName(firstName: firstName)
				}
				if let phoneNumber = currentJsonCustomer["phoneNumber"] as? String {
					customer.setPhoneNumber(phoneNumber: phoneNumber)
				}
				if let fbAccount = currentJsonCustomer["fbAccount"] as? String {
					customer.setFbAccount(fbAccount: fbAccount)
				}
				if let email = currentJsonCustomer["email"] as? String {
					customer.setEmail(email: email)
				}
				if let dayOfBirth = currentJsonCustomer["dayOfBirth"] as? String {
					customer.setDayOfBirth(dayOfBirth: dayOfBirth)
				}
				if let message = currentJsonCustomer["message"] as? String {
					customer.setMessage(message: message)
				}
				
				//set User's email
				if let emailBusiness = currentJsonCustomer["emailBusiness"] as? String {
					customer.setEmailBusiness(emailBusiness: emailBusiness)
				}
				if let emailTeam = currentJsonCustomer["emailTeam"] as? String {
					customer.setEmailTeam(emailTeam: emailTeam)
				}
				if let emailPersonal = currentJsonCustomer["emailPersonal"] as? String {
					customer.setEmailPersonal(emailPersonal: emailPersonal)
				}
				
				//set calling's detail
				if let status = currentJsonCustomer["status"] as? Int {
					customer.setCallStatus(callStatus: status)
				}
				if let successTimes = currentJsonCustomer["successTimes"] as? Int {
					customer.setCallSuccessTimes(callSuccessTimes: successTimes)
				}
				if let successMinutes = (currentJsonCustomer["successMinutes"] as? NSNumber)?.floatValue {
					customer.setCallSuccessMinutes(callSuccessMinutes: successMinutes)
				}
                
                //set newcomer status for new customer
                if let statusNewcomer = currentJsonCustomer["statusNewcomer"] as? Int {
                    customer.setStatusNewcomer(statusNewcomer: statusNewcomer)
                }
				
				if let note = currentJsonCustomer["note"] as? String {
					customer.setNote(note: note)
				}
				
				if let star = currentJsonCustomer["star"] as? Int {
					customer.setStar(star: star)
				}
				
				//Add customer to list seperated by calling status
				if (customer.callStatus == 0) {
					self.customerListSeperated[KEY_STILL_NOT]?.append(customer)
				} else {
					self.customerListSeperated[KEY_ALREADY]?.append(customer)
				}
				
				//After get all calling detail of customer, do completion
				if (self.customerListSeperated[KEY_STILL_NOT]!.count + self.customerListSeperated[KEY_ALREADY]!.count == arrCustomer.count) {
					//Sort
					self.customerListSeperated[KEY_STILL_NOT] = self.customerListSeperated[KEY_STILL_NOT]?.sorted(by: {$0.dateContact < $1.dateContact})
					//Sort
					self.customerListSeperated[KEY_ALREADY] = self.customerListSeperated[KEY_ALREADY]?.sorted(by: {$0.dateContact < $1.dateContact})
					completion()
				}
			}
		}
	}
	
	func getProjectInfo(completion: @escaping() -> Void){
		let strParams: String = "projectName=" + self.name
		getJsonUsingPost(strURL: urlGetProjectInfo, strParams: strParams) { (json) in
			let projectJson = json["project"]! as! Dictionary<String, Any>
			//self.name = projectJson["name"] as! String
			self.thumbnail = projectJson["thumbnail"] as! String
			completion()
		}
	}
}
