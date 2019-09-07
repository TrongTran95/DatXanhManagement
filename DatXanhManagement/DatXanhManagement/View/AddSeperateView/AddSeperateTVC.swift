//
//  AddSeperateTVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 8/24/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class AddSeperateTVC: UITableViewCell {

	@IBOutlet weak var lblEmailAddress: UILabel!
	
	func setEmailAddress(emailAddress: String) {
		lblEmailAddress.text = emailAddress
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
