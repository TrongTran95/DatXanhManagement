//
//  CustomerListTVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/16/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class CustomerListTVC: UITableViewCell {
	
	@IBOutlet weak var viewOrder: UIView!
	@IBOutlet weak var lblOrder: UILabel!
	@IBOutlet weak var lblCustomerName: UILabel!
	@IBOutlet weak var lblPhoneNumber: UILabel!
	@IBOutlet weak var btnPhoneCall: UIButton!
	@IBOutlet weak var viewPhoneCall: UIView!
	
	var delegate: CustomerListTVCDelegate?
	var section = ""
	
	@IBAction func makeAPhoneCallButtonPressed(_ sender: UIButton) {
		delegate?.didPressCallButton(section: section, row: sender.tag)
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		viewOrder.layer.cornerRadius = 10
		viewPhoneCall.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

protocol CustomerListTVCDelegate: class {
	func didPressCallButton(section: String, row: Int)
}
