//
//  ChartVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 10/26/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class ChartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.tabBarController?.navigationItem.title = "Chart"
		self.tabBarController?.navigationItem.rightBarButtonItems = []

	}
}
