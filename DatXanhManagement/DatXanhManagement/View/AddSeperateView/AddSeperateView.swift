//
//  AddSeperateView.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 8/24/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class AddSeperateView: UIView {

	@IBOutlet var contentView: UIView!
	
	@IBOutlet weak var stepperMultiplier: UIStepper!
	
	@IBOutlet weak var tvUserEmailDetailList: UITableView!
	
	var userEmailDetailList: [UserEmailDetail]!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setupTableView(){
		tvUserEmailDetailList.delegate = self
		tvUserEmailDetailList.dataSource = self
		tvUserEmailDetailList.register(UINib(nibName: "AddSeperateTVC", bundle: nil), forCellReuseIdentifier: "AddSeperateCell")
	}
	
	func setupRegistNib(){
		Bundle.main.loadNibNamed("AddSeperateView", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
	}
	
	func setup(){
		setupRegistNib()
		setupTableView()
		setupUI()
	}
	
	func setupUI(){
		self.translatesAutoresizingMaskIntoConstraints = false
	}

}


extension AddSeperateView: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return userEmailDetailList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AddSeperateCell", for: indexPath) as! AddSeperateTVC
		
		return cell
	}
	
	
}
