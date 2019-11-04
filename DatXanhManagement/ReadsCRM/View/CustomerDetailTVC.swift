//
//  CustomerDetailTVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/16/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class CustomerDetailTVC: UITableViewCell {
	
	@IBOutlet weak var imgTitle: UIImageView!
	
	@IBOutlet weak var lblTitle: UILabel!
	
	@IBOutlet weak var lblDescription: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
