//
//  UserListTVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 10/24/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class UserListTVC: UITableViewCell {

	@IBOutlet weak var lblEmail: UILabel!
	
	@IBOutlet weak var lblName: UILabel!
	
	@IBOutlet weak var viewUserType: UIView!
	
	@IBOutlet weak var lblUserType: UILabel!
	
	func setDescription(email: String, name: String, userType: Int){
		self.lblName.text = name
		self.lblEmail.text = email
		self.lblUserType.text = "\(UserType(rawValue: userType)!)"
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		viewUserType.layer.cornerRadius = 5
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
