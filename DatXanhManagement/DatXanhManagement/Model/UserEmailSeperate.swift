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
	private(set) public var receiveDate:String
	private(set) public var customerID:Int
	
	init() {
		self.emailPersonal = ""
		self.orderNumber = 0
		self.receiveDate = ""
		self.customerID = 0
	}
	
	func setEmailPersonal(emailPersonal: String) {
		self.emailPersonal = emailPersonal
	}
	
	func setOrderNumber(orderNumber: Int) {
		self.orderNumber = orderNumber
	}
}
