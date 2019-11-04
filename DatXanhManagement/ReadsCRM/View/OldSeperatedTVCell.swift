//
//  OldSeperatedTVCell.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 9/8/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class OldSeperatedTVCell: UITableViewCell {
	
	@IBOutlet weak var imgOrderNumber: UIImageView!
	
	@IBOutlet weak var lblOrderNumber: UILabel!
	
	@IBOutlet weak var lblUserEmail: UILabel!
	
	@IBOutlet weak var lblCustomerBriefInfo: UILabel!
	
	func setData(userEmail: String, orderNumber: Int, customer: BriefCustomer){
		lblUserEmail.text = userEmail
		lblOrderNumber.text = "\(orderNumber)"
		lblCustomerBriefInfo.text = "\(customer.firstName) \(customer.lastName) - \(customer.phoneNumber)"
	}
	
	func setupUI(){
		imgOrderNumber.layer.cornerRadius = 10
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
