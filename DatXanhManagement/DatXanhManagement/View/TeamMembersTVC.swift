//
//  TeamMemberTVC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/19/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class TeamMemberTVC: UITableViewCell {
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblNumber: UILabel!
    
	@IBOutlet weak var imgNumber: UIImageView!
	override func awakeFromNib() {
        super.awakeFromNib()
		imgNumber.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
