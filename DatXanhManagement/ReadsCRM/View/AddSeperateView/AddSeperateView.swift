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
	
	@IBOutlet weak var lblMultiplier: UILabel!
	
	var delegate: SeperateVC!
	
	@IBAction func TappedCancelOrSaveButton(_ sender: UIButton) {
		if (sender.currentTitle == "Add") {
			delegate.addNewSeperate()
		} else {
			delegate.turnOffAddView()
		}
	}
	
	@IBAction func ChangeMultiplerValue(_ sender: Any) {
		lblMultiplier.text = "Multiplier: \(Int(stepperMultiplier.value))"
	}
	
	var userEmailDetailList: [UserEmailDetail]!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setupStepper(){
		stepperMultiplier.minimumValue = 1
		stepperMultiplier.value = 1
		lblMultiplier.text = "Multiplier: \(Int(stepperMultiplier.value))"
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
		setupStepper()
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
		cell.setData(emailAddress: userEmailDetailList[indexPath.row].emailPersonal, quantity: userEmailDetailList[indexPath.row].receiveQuantity)
		return cell
	}
	
	
}
