//
//  UserMember.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 8/21/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

struct UserMember {
	var id:Int
	var emailPersonal: String
	
	init(){
		self.id = 0
		self.emailPersonal = ""
	}
	
	init(id: Int, emailPersonl: String) {
		self.id = id
		self.emailPersonal = emailPersonl
	}
}
