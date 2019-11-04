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
	private(set) public var messageCode:String
	private(set) public var projectName:String
	private(set) public var source:String
	private(set) public var dateContact:String
	private(set) public var gender:String
	private(set) public var lastName:String
	private(set) public var firstName:String
	private(set) public var phoneNumber:String
	private(set) public var fbAccount:String
	private(set) public var email:String
	private(set) public var dayOfBirth:String
	private(set) public var message:String
	private(set) public var emailBusiness:String
	private(set) public var emailTeam:String
	private(set) public var emailPersonal:String
	
	private(set) public var callStatus:Int
	private(set) public var callSuccessTimes:Int
	private(set) public var callSuccessMinutes:Float
	private(set) public var callingDetailList:[CallingDetail]
    
    private(set) public var statusNewcomer:Int
	
	private(set) public var note:String
	private(set) public var star:Int
	
	
	
	
	init() {
		self.idCustomer = 0
		self.messageCode = ""
		self.projectName = ""
		self.source = ""
		self.dateContact = ""
		self.gender = ""
		self.lastName = ""
		self.firstName = ""
		self.phoneNumber = ""
		self.fbAccount = ""
		self.email = ""
		self.dayOfBirth = ""
		self.message = ""
		self.emailBusiness = ""
		self.emailTeam = ""
		self.emailPersonal = ""
		
		self.callStatus = 0
		self.callSuccessTimes = 0
        self.callSuccessMinutes = 0
		self.callingDetailList = []
        
        self.statusNewcomer = 0
		self.note = ""
		self.star = 0
	}
	
	func setCallingDetailList(callingDetailList: [CallingDetail]){
		self.callingDetailList = callingDetailList
	}
	
	func setStar(star: Int){
		self.star = star
	}
	
	func setNote(note: String){
		self.note = note
	}
    
    func setStatusNewcomer(statusNewcomer: Int) {
        self.statusNewcomer = statusNewcomer
    }
	
	func setIDCustomer(idCustomer: Int) {
		self.idCustomer = idCustomer
	}
	
	func setProjectName(projectName: String) {
		self.projectName = projectName
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
	
	func setMessageCode(messageCode: String) {
		self.messageCode = messageCode
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
	
	func setEmailTeam(emailTeam: String) {
		self.emailTeam = emailTeam
	}
	
	func setEmailBusiness(emailBusiness: String) {
		self.emailBusiness = emailBusiness
	}
	
	func setEmailPersonal(emailPersonal: String) {
		self.emailPersonal = emailPersonal
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
	
	//Update customer calling detail after user success contact with customer
	func updateCustomerCallingDetail(completion:@escaping(Bool) -> Void){
		let strParams: String = "status=\(self.callStatus)" + "&successTimes=\(self.callSuccessTimes)" + "&successMinutes=\(self.callSuccessMinutes)" + "&idCustomer=\(self.idCustomer)"
		print(strParams)
		getJsonUsingPost(strURL: urlUpdateCustomerCallingDetail, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
}

class BriefCustomer {
	private(set) public var lastName:String
	private(set) public var firstName:String
	private(set) public var phoneNumber:String
	
	init() {
		self.lastName = ""
		self.firstName = ""
		self.phoneNumber = ""
	}
	
	func setFirstName(firstName: String) {
		self.firstName = firstName
	}
	
	func setLastName(lastName: String) {
		self.lastName = lastName
	}
	
	func setPhoneNumber(phoneNumber: String) {
		self.phoneNumber = phoneNumber
	}
}

