//
//  ProjectListTVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 10/27/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class ProjectListTVC: UITableViewCell {

	@IBOutlet weak var lblOrderNumber: UILabel!
	
	@IBOutlet weak var lblProjectName: UILabel!
	
	@IBOutlet weak var imgOrderNumber: UIImageView!
	
	func setData(orderNumber: Int, projectName: String){
		lblOrderNumber.text = "\(orderNumber)"
		lblProjectName.text = projectName
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		imgOrderNumber.layer.cornerRadius = 5
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
