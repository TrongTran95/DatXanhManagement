//
//  NewSeperateTVCell.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 9/8/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class NewSeperateTVCell: UITableViewCell {

	@IBOutlet weak var imgOrder: UIImageView!
	
	@IBOutlet weak var lblOrderNumber: UILabel!
	
	@IBOutlet weak var lblEmailPersonal: UILabel!
	
	func setData(emailPersonal: String, orderNumber: Int){
		lblEmailPersonal.text = emailPersonal
		lblOrderNumber.text = "\(orderNumber)"
	}
	
	func setupUI(){
		imgOrder.layer.cornerRadius = 10
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
