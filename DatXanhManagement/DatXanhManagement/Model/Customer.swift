//
//  Customer.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import Foundation

class Customer {
	private(set) public var idCustomer:Int
	private(set) public var gender:String
	private(set) public var firstName:String
	private(set) public var lastName:String
	private(set) public var dayOfBirth:String
	private(set) public var phoneNumber:String
	private(set) public var email:String
	private(set) public var fbAccount:String
	private(set) public var projectCode:String
	private(set) public var source:String
	private(set) public var dateContact:String
	private(set) public var message:String
	private(set) public var customerStatusID:Int
	
	private(set) public var idPhoneCall:Int
	private(set) public var callStatus:Int
	private(set) public var callSuccessTimes:Int
	private(set) public var callSuccessMinutes:Float
	
	init() {
		self.idCustomer = 0
		self.gender = ""
		self.firstName = ""
		self.lastName = ""
		self.dayOfBirth = ""
		self.phoneNumber = ""
		self.email = ""
		self.fbAccount = ""
		self.projectCode = ""
		self.source = ""
		self.dateContact = ""
		self.message = ""
		self.customerStatusID = 2
		
		self.idPhoneCall = 0
		self.callStatus = 0
		self.callSuccessTimes = 0
		self.callSuccessMinutes = 0
	}
	
	func setIDCustomer(idCustomer: Int) {
		self.idCustomer = idCustomer
	}
	
	func setGender(gender: String) {
		self.gender = gender
	}
	
	func setFirstName(firstName: String) {
		self.firstName = firstName
	}
	
	func setLastName(lastName: String) {
		self.lastName = lastName
	}
	
	func setDayOfBirth(dayOfBirth: String) {
		self.dayOfBirth = dayOfBirth
	}
	
	func setPhoneNumber(phoneNumber: String) {
		self.phoneNumber = phoneNumber
	}
	
	func setEmail(email: String) {
		self.email = email
	}
	
	func setFbAccount(fbAccount: String) {
		self.fbAccount = fbAccount
	}
	
	func setProjectCode(projectCode: String) {
		self.projectCode = projectCode
	}
	
	func setSource(source: String) {
		self.source = source
	}
	
	func setDateContact(dateContact: String) {
		self.dateContact = dateContact
	}
	
	func setMessage(message: String) {
		self.message = message
	}
	
	func setCustomerStatusID(customerStatusID: Int) {
		self.customerStatusID = customerStatusID
	}
	
	func setCallStatus(callStatus: Int) {
		self.callStatus = callStatus
	}
	
	func setCallSuccessTimes(callSuccessTimes: Int) {
		self.callSuccessTimes += callSuccessTimes
	}
	
	func setCallSuccessMinutes(callSuccessMinutes: Float) {
		self.callSuccessMinutes += callSuccessMinutes
	}
	
	func getCallingDetail(email: String, completion: @escaping() -> Void) {
		let strParams: String = "idCustomer=\(self.idCustomer)"  + "&userPersonalEmail=" + email
		getJsonUsingPost(strURL: urlGetCustomerCallingDetail, strParams: strParams) { (json) in
			let callingDetailJson = json["callingDetail"]! as! Dictionary<String, Any>
			self.idPhoneCall = callingDetailJson["idPhoneCall"] as! Int
			self.callStatus = callingDetailJson["status"] as! Int
			self.callSuccessTimes = callingDetailJson["successTimes"] as! Int
			self.callSuccessMinutes = ((callingDetailJson["successMinutes"] as? NSNumber)?.floatValue)!
			completion()
		}
	}
	
	//Update customer calling detail after user success contact with customer
	func updateCustomerCallingDetail(completion:@escaping() -> Void){
		let strParams: String = "status=\(self.callStatus)" + "&successTimes=\(self.callSuccessTimes)" + "&successMinutes=\(self.callSuccessMinutes)" + "&idPhoneCall=\(self.idPhoneCall)"
		getJsonUsingPost(strURL: urlUpdateCustomerCallingDetail, strParams: strParams) { (json) in
			completion()
		}
	}
	
}
