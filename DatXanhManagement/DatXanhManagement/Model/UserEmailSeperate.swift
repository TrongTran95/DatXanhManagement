//
//  UserEmailSeperate.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 9/8/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import Foundation

class UserEmailSeperate {
	private(set) public var emailPersonal:String
	private(set) public var orderNumber:Int
	private(set) public var receivedDate:String
	private(set) public var customerID:Int
	private(set) public var briefCustomer:BriefCustomer
	
	init() {
		self.emailPersonal = ""
		self.orderNumber = 0
		self.receivedDate = ""
		self.customerID = 0
		self.briefCustomer = BriefCustomer()
	}
	
	func setEmailPersonal(emailPersonal: String) {
		self.emailPersonal = emailPersonal
	}
	
	func setOrderNumber(orderNumber: Int) {
		self.orderNumber = orderNumber
	}
	
	func setReceivedDate(receivedDate: String) {
		self.receivedDate = receivedDate
	}
	
	func setCustomerID(customerID: Int) {
		self.customerID = customerID
	}
	
	func setBriefCustomer(briefCustomer: BriefCustomer) {
		self.briefCustomer = briefCustomer
	}
}
