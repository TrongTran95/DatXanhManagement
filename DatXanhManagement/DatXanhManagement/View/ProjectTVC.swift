//
//  ProjectTVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class ProjectTVC: UITableViewCell {
    
	@IBOutlet weak var imgProjectThumbnail: UIImageView!
	
	@IBOutlet weak var projectName: UILabel!
	
	@IBOutlet weak var numberOfCustomer: UILabel!
	
//	@IBOutlet weak var aiLoadingImage: UIActivityIndicatorView!
	
	@IBOutlet weak var lblSupervisor: UILabel!
	
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
}
