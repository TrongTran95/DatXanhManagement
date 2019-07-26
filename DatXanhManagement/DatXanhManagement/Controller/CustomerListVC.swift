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
	
	//For using callkit and catching event
	var callObserver: CXCallObserver!
	
	//To determine if customer accept the calling
	var connectFlag:Bool = false
	
	//If customer accept the calling, calculate the success minutes
	var startMoment = DateComponents()
	var endMoment = DateComponents()
	
	var userPersonalEmail: String = ""
	
	
	//Cancel button, turn off customer detail view, back to customer list
	@IBAction func backToCustomerListButtonClicked(_ sender: Any) {
		//Hide Customer detail view
		viewCustomerDetailContainer.isHidden = true
		UIView.animate(withDuration: 0.5) {
			self.viewCustomerDetailContainer.alpha = 0
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		//Setup table view
		setupTableView()
		//Setup data for page
		setupPagesInfo()
		//Setup calling manager
		setupCallingManager()
    }
	
	//Set up delegate and data source for tableviews
	func setupTableView(){
		tbCustomerList.delegate = self
		tbCustomerList.dataSource = self
		tbCustomerDetail.delegate = self
		tbCustomerDetail.dataSource = self
	}
	
	//Setup data for first time
	func setupPagesInfo(){
		//Hide back button title
		self.navigationController?.navigationBar.topItem!.title = " "
		//Set page's title (name of project)
		self.title = self.project.projectName
		//Set customer quantity information
		setupCustomerQuantity()
	}
	
	//Setup call management
	func setupCallingManager(){
		callObserver = CXCallObserver()
		callObserver.setDelegate(self, queue: nil) // nil queue means main thread
	}
	
	//Set customer quantity information
	func setupCustomerQuantity(){
		let quantityStillNot = project.customerListSeperated[STILL_NOT]!.count
		let quantityAlready = project.customerListSeperated[ALREADY]!.count
		self.lblCustomerQuantity.text = "\(quantityStillNot)/\(quantityStillNot + quantityAlready) khách hàng cần được tư vấn"
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
			//Still not contact customer list
			if section == 0 {
				return project.customerListSeperated[STILL_NOT]!.count
			}
			//Already contacted customer list
			else {
				return project.customerListSeperated[ALREADY]!.count
			}
		}
		//Table customer detail
		else {
			return arrTitle.count
		}
	}
	
	func getCurrentMoment() -> DateComponents {
		let date = Date()
		let calendar = Calendar.current
		return calendar.dateComponents([.hour, .minute, .second], from: date)
	}
	
	
	func calculateCalllMinutes() -> Float{
		endMoment = getCurrentMoment()
		
		var averageMins:Float = 0
		let hours = Float(endMoment.hour! - startMoment.hour!)
		let minutes = Float(endMoment.minute! - startMoment.minute!)
		let seconds = Float(endMoment.second! - startMoment.hour!)
		//1:?:? and 1:?:?
		if (hours == 0) {
			//1:14:12 and 1:14:20
			if (minutes == 0) {
				averageMins += seconds/60.0
			}
			//1:14:? and 1:15:?
			else {
				//1:14:12 and 1:15:12
				//1:14:12 and 1:15:15
				if (endMoment.second! >= startMoment.second!) {
					averageMins += minutes
					averageMins += seconds/60.0
				}
				//1:14:12 and 1:16:10
				else {
					averageMins += minutes - 1
					let realSeconds = Float(60 - startMoment.second! + endMoment.second!)
					averageMins += realSeconds/60.0
				}
			}
		}
		//1:?:? and 2:?:?
		else {
			//1:14:? and 2:14:?
			if (minutes == 0) {
				//1:14:09 and 2:14:09
				//1:14:09 and 2:14:14
				if (seconds >= 0) {
					averageMins += seconds/60.0
					averageMins += hours*60.0
				}
				//1:14:09 and 3:14:01	(2*60-1) + (60-9 + 1)/60
				else {
					averageMins += hours*60.0 - 1
					let realSeconds = Float(60 - startMoment.second! + endMoment.second!)
					averageMins += realSeconds/60.0
				}
			}
			//1:14:? and 2:15:?
			else if (minutes > 0) {
				averageMins += hours*60.0
				//1:14:12 and 2:15:12
				//1:14:12 and 2:15:15
				if (seconds >= 0) {
					averageMins += minutes
					averageMins += seconds/60.0
				}
				//1:14:12 and 2:15:10
				else {
					averageMins += minutes - 1
					let realSeconds = Float(60 - startMoment.second! + endMoment.second!)
					averageMins += realSeconds/60.0
				}
			}
			//1:14:? and 2:13:?
			else {
				//1:14:05 and 2:13:05
				//1:14:05 and 2:13:09
				if (seconds >= 0) {
					averageMins += seconds/60.0
					let realMinutes = Float(60 - startMoment.minute! + endMoment.minute!)
					averageMins += realMinutes
				}
				//1:14:05 and 2:13:02
				else {
					let realMinutes = Float(60 - startMoment.minute! + endMoment.minute!) - 1
					averageMins += realMinutes
					let realSeconds = Float(60 - startMoment.second! + endMoment.second!)
					averageMins += realSeconds/60.0
				}
			}
		}
		
		if averageMins < 0 {
			averageMins = -averageMins
		}
		
		return averageMins
	}
	
	//Appearance of every cell of table
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//Table customer list
		if tableView == tbCustomerList {
			let cell = tbCustomerList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomerListTVC
			
			//Get current customer from customer list depend on which section
			let currentCustomer: Customer!
			//From Still not contact customer list
			if indexPath.section == 0 {
				currentCustomer = project.customerListSeperated[STILL_NOT]![indexPath.row]
				//Set section
				cell.section = STILL_NOT
			}
			//From Already contacted customer list
			else {
				currentCustomer = project.customerListSeperated[ALREADY]![indexPath.row]
				//Set section
				cell.section = ALREADY
			}
			
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
			//From Still not contact customer list
			if indexPath.section == 0 {
				chosenCustomer = project.customerListSeperated[STILL_NOT]![indexPath.row]
			}
			//From Already contacted customer list
			else {
				chosenCustomer = project.customerListSeperated[ALREADY]![indexPath.row]
			}
			
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
		
		//End the phone call
		if call.hasEnded == true {
			print("Disconnected")
			//Customer accept the calling, change call status of customer and reset customer list
			if (connectFlag == true) {
				//Calculate times(mins) that user had called customer
				let averageMins:Float = calculateCalllMinutes()
				
				//Update call's status
				chosenCustomer.setCallStatus(callStatus: 1)
				//Update call's success times
				chosenCustomer.setCallSuccessTimes(callSuccessTimes: 1)
				//Update call's success minutes
				chosenCustomer.setCallSuccessMinutes(callSuccessMinutes: averageMins)
				//Update to server
				chosenCustomer.updateCustomerCallingDetail {
					//Reset customer list
					self.project.checkAndResetCustomerList()
					//reload table's data
					DispatchQueue.main.async {
						self.tbCustomerList.reloadData()
					}
					//Get customer list
					self.project.getCustomerListBaseOnProjectCode(userPersonalEmail: self.userPersonalEmail) {
						//reload table's data
						DispatchQueue.main.async {
							self.tbCustomerList.reloadData()
							self.setupCustomerQuantity()
							//Set call flag to false to reuse
							self.connectFlag = false
						}
					}
				}
			}
			//Customer not accept the calling, change call fail times
			else {
				
			}
		}
		//User call customer
		if call.isOutgoing == true && call.hasConnected == false {
			print("Dialing")
		}
		//Customer call while using app
		if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
			print("Incoming")
		}
		//Customer or user accept call
		if call.hasConnected == true && call.hasEnded == false {
			connectFlag = true
			print("Connected")
			startMoment = getCurrentMoment()
		}
	}
	
	func didPressCallButton(section: String, row: Int) {
		chosenCustomer = project.customerListSeperated[section]![row]
//		let phoneNumber = chosenCustomer.phoneNumber
		let trongs = "0783636848"
		trongs.makeAColl()
	}
}
