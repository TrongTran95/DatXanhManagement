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
	
	var delegate: CustomerListTVCDelegate?
	var section = 0
	
	@IBAction func makeAPhoneCallButtonPressed(_ sender: UIButton) {
		delegate?.didPressCallButton(tag: sender.tag)
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		viewOrder.layer.cornerRadius = 10
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

protocol CustomerListTVCDelegate: class {
	func didPressCallButton(tag: Int)
}
