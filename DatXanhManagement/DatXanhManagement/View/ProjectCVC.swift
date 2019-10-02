//
//  ProjectCVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class ProjectCVC: UICollectionViewCell {
    
	@IBOutlet weak var imgProjectThumbnail: UIImageView!
	
	@IBOutlet weak var projectName: UILabel!
	
	@IBOutlet weak var numberOfCustomer: UILabel!
	
	@IBOutlet weak var numberOfCustomerNeedContact: UILabel!
	
	@IBOutlet weak var aiLoadingImage: UIActivityIndicatorView!
	
	@IBOutlet weak var lblSupervisor: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
