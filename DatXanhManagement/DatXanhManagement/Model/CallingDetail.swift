//
//  CallingDetail.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 11/1/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import Foundation

class CallingDetail {
	private(set) public var id:Int
	private(set) public var date:String
	private(set) public var type:Int
	
	init() {
		self.id = 0
		self.date = ""
		self.type = 0
	}
	
	func setId(id: Int) {
		self.id = id
	}
	
	func setDate(date: String) {
		self.date = date
	}
	
	func setType(type: Int) {
		self.type = type
	}
	
}
