//
//  UserEmailDetail.swift
//  DatXanhManagement
//
//  Created by ivc on 8/13/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class UserEmailDetail {
    private(set) public var id:Int
    private(set) public var emailPersonal:String
    private(set) public var orderNumber:Int
    private(set) public var receiveQuantity:Int
    
    init() {
        id = 0
        emailPersonal = ""
        orderNumber = 0
        receiveQuantity = 0
    }
	
	init(id: Int, emailPersonal: String, orderNumber: Int, receiveQuantity: Int) {
		self.id = id
		self.emailPersonal = emailPersonal
		self.orderNumber = orderNumber
		self.receiveQuantity = receiveQuantity
	}
    
    //This method will set the value of id
    func setID(id: Int){
        self.id = id
    }
    
    //This method will set the value of emailAddress
    func setEmailPersonal(emailPersonal: String){
        self.emailPersonal = emailPersonal
    }
    
    //This method will set the value of orderNumber
    func setOrderNumber(orderNumber: Int){
        self.orderNumber = orderNumber
    }
    
    //This method will set the value of receiveQuantity
    func setReceiveQuantity(receiveQuantity: Int){
        self.receiveQuantity = receiveQuantity
    }
}
