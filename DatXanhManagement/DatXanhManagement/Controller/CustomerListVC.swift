//
//  CustomerListVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/16/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit
import CallKit

class CustomerListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var project = Project()

	@IBOutlet weak var lblCustomerQuantity: UILabel!
	
	@IBOutlet weak var tbCustomerList: UITableView!
	
	@IBOutlet weak var lblCustomerName: UILabel!
	
	@IBOutlet weak var tbCustomerDetail: UITableView!
	
	@IBOutlet weak var viewCustomerDetailContainer: UIView!
	
	var chosenCustomer = Customer()
	
	let arrImageTitle = ["mansion", "call-green", "date", "fb", "email", "gender", "birthday", "source", "message"]
	
	let arrTitle = ["Dự án", "Số điện thoại", "Ngày liên lạc", "Facebook", "Email", "Giới tính", "Ngày sinh", "Nguồn", "Thông điệp"]
	
	//Cancel button, turn off customer detail view, back to customer list
	@IBAction func backToCustomerListButtonClicked(_ sender: Any) {
		//Hide Customer detail view
		viewCustomerDetailContainer.isHidden = true
		UIView.animate(withDuration: 0.5) {
			self.viewCustomerDetailContainer.alpha = 0
		}
	}
	
	//For using callkit and catching event
	var callObserver: CXCallObserver!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		//Hide back button title
			self.navigationController?.navigationBar.topItem!.title = " "
		//Setup table view
		setupTableView()
		//Setup data for page
		setupData()
		
		
    }
	
	//Set up delegate and data source for tableviews
	func setupTableView(){
		tbCustomerList.delegate = self
		tbCustomerList.dataSource = self
		tbCustomerDetail.delegate = self
		tbCustomerDetail.dataSource = self
	}
	
	//setup data for first time
	func setupData(){
		//Set page's title (name of project)
		self.title = self.project.projectName
		//Set customer quantity information
		self.lblCustomerQuantity.text = "2/\(project.customerList.count * 2) khách hàng cần được tư vấn"
		//Setup call management
		callObserver = CXCallObserver()
		callObserver.setDelegate(self, queue: nil) // nil queue means main thread
	}
	
	//Number of section of table view
	func numberOfSections(in tableView: UITableView) -> Int {
		//Table customer list
		if tableView == tbCustomerList {
			return 2
		}
		//Table customer detail
		else {
			return 1
		}
	}
	
	//Set title for section
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		//Table customer list
		if tableView == tbCustomerList {
			if section == 0 {
				return "Chưa liên lạc"
			} else {
				return "Đã liên lạc"
			}
		}
		//Table customer detail
		else {
			return ""
		}
	}
	
	//Number of row in section
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//Table customer list
		if tableView == tbCustomerList {
			return project.customerList.count
		}
		//Table customer detail
		else {
			return arrTitle.count
		}
	}
	
	//Appearance of every cell of table
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//Table customer list
		if tableView == tbCustomerList {
			let cell = tbCustomerList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomerListTVC
			//Get current customer fro customer list
			let currentCustomer = project.customerList[indexPath.row]
			
			//Set customer name
			let limitLength = 20
			let customerName = "\(currentCustomer.lastName) \(currentCustomer.firstName)"
			var customerDisplayName = ""
			if (customerName.count > limitLength){
				customerDisplayName += ".."
			}
			customerDisplayName += customerName.maxLengthFromRightToLeft(length: limitLength)
			cell.lblCustomerName.text = customerDisplayName
			
			//Set customer phone number
			cell.lblPhoneNumber.text = currentCustomer.phoneNumber
			
			//Set order of customer
			cell.lblOrder.text = "\(indexPath.row + 1)"
			
			//Set color for called customer
			if (indexPath.section == 1) {
				cell.viewOrder.backgroundColor = UIColor(red: 36/255, green: 161/255, blue: 94/255, alpha: 1)
			}
			
			//Set tag for button phone call
			cell.btnPhoneCall.tag = indexPath.row
			
			//Set section
			cell.section = indexPath.section
			cell.delegate = self
			
			return cell
		}
			
		//Table customer detail
		else {
			let cell = tbCustomerDetail.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath) as! CustomerDetailTVC
			let currentRow = indexPath.row
			
			//Set customer name
			self.lblCustomerName.text = "\(chosenCustomer.lastName) \(chosenCustomer.firstName)"
			//Set title thumbnail
			cell.imgTitle.image = UIImage(named: arrImageTitle[currentRow])
			//Set title
			cell.lblTitle.text = arrTitle[currentRow]
			//Get description
			var description = ""
			switch currentRow {
			case 0: //Project name
				description = project.projectName
			case 1: //Phone number
				description = chosenCustomer.phoneNumber
			case 2: //Contact date
				description = chosenCustomer.dateContact
			case 3: //Facebook account
				description = chosenCustomer.fbAccount
			case 4: //Email address
				description = chosenCustomer.email
			case 5: //Gender
				description = chosenCustomer.gender
			case 6: //Birthday
				description = chosenCustomer.dayOfBirth
			case 7: //Source
				description = chosenCustomer.source
			case 8: //Message
				description = chosenCustomer.message
			default:
				description = "Chưa có thông tin"
			}
			//Set description
			if (description == "") {
				description = "Chưa có thông tin"
			}
			cell.lblDescription.text = description
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		//Table customer list
		if tableView == tbCustomerList {
			return 70
		}
			//Table customer detail
		else {
			return 44
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//Table customer list
		if tableView == tbCustomerList {
			//Set chosen customser when click to any customer
			chosenCustomer = project.customerList[indexPath.row]
			//Reload table customer detail to update new values
			tbCustomerDetail.reloadData()
			//Show Customer detail view
			viewCustomerDetailContainer.isHidden = false
			UIView.animate(withDuration: 0.5) {
				self.viewCustomerDetailContainer.alpha = 1
			}
		}
		//Table customer detail
		else {
			
		}

	}
}

extension CustomerListVC: CustomerListTVCDelegate, CXCallObserverDelegate{
	func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
		//https://stackoverflow.com/questions/36014975/detect-phone-calls-on-ios-with-ctcallcenter-swift
		//End the phone call
		if call.hasEnded == true {
			print("Disconnected")
			print("a")
		}
		//User call customer
		if call.isOutgoing == true && call.hasConnected == false {
			print("Dialing")
			print("b")
		}
		//Customer call while using app
		if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
			print("Incoming")
			print("c")
		}
		//Customer or user accept call
		if call.hasConnected == true && call.hasEnded == false {
			print("Connected")
			print("d")
		}
	}
	
	func didPressCallButton(tag: Int) {
		let phoneNumber = project.customerList[tag].phoneNumber
//		let trongs = "0783636848"
		phoneNumber.makeAColl()
	}
}
