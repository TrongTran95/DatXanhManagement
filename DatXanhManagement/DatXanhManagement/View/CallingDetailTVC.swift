//
//  CallingDetailTVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 11/1/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class CallingDetailTVC: UITableViewCell {

	@IBOutlet weak var imgType: UIImageView!
	
	@IBOutlet weak var lblDate: UILabel!
	
	func setData(date: String, type: CallingDetailType){
		lblDate.text = date
		switch type {
		case .NotPickUp:
			imgType.backgroundColor = UIColor.orange
		default:
			imgType.backgroundColor = UIColor.green
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		imgType.layer.cornerRadius = imgType.frame.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
