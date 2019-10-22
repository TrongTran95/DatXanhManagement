//
//  CustomerListVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/16/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit
import CallKit
import Cosmos

class CustomerListVC: UIViewController {
	
	var project = Project()

//	@IBOutlet weak var lblCustomerQuantity: UILabel!
	
	@IBOutlet weak var tbCustomerList: UITableView!
	
	@IBOutlet weak var lblCustomerName: UILabel!
	
	@IBOutlet weak var tbCustomerDetail: UITableView!
	
	@IBOutlet weak var viewCustomerDetailContainer: UIView!
	
	@IBOutlet weak var txtvNote: UITextView!
	
	@IBOutlet weak var csBottomOfDetailCustomerView: NSLayoutConstraint!
	
	@IBOutlet weak var viewNoteContainer: UIView!
	
	@IBOutlet weak var viewRating: UIView!
	
	@IBOutlet weak var btnInfoEdit: UIButton!
	
	lazy var cosmosView: CosmosView = {
		let view = CosmosView()
		view.settings.filledImage = #imageLiteral(resourceName: "star_yellow").withRenderingMode(.alwaysOriginal)
		view.settings.emptyImage = #imageLiteral(resourceName: "star_gray").withRenderingMode(.alwaysOriginal)
		view.settings.totalStars = 5
		view.settings.starSize = 30
		view.settings.starMargin = 5
		view.settings.fillMode = .full
		view.translatesAutoresizingMaskIntoConstraints = false
		//https://www.youtube.com/watch?v=Y4A_y29cy7Q
		return view
	}()
	
	var lblPlaceHolderNote : UILabel!
	
	var chosenCustomer = Customer()
	
	let arrImageTitle = ["mansion", "message", "source", "call-green", "fb", "email", "date", "gender", "birthday", "call-green-status", "call-green-times", "call-green-clock"]
	
	let arrTitle = ["Dự án", "Thông điệp", "Nguồn", "Số điện thoại", "Facebook", "Email", "Ngày liên lạc", "Giới tính", "Ngày sinh", "Tình trạng liên lạc", "Số lần liên lạc thành công", "Thời gian liên lạc thành công"]
	
	//For using callkit and catching event
	var callObserver: CXCallObserver!
	
	//To determine if customer accept the calling
	var connectFlag:Bool = false
	
	//If customer accept the calling, calculate the success minutes
	var startMoment = DateComponents()
	var endMoment = DateComponents()
	
	var emailPersonal: String = ""
	
	var pushCustomerId: Int = 0
	
	var flagStar: Bool = false
	var flagNote: Bool = false
	
	@IBAction func editOrInfoButtonClicked(_ sender: UIButton) {
		if sender.currentImage == #imageLiteral(resourceName: "edit") {
			viewNoteContainer.isHidden = false
			btnInfoEdit.setImage(#imageLiteral(resourceName: "info"), for: .normal)
		} else {
			viewNoteContainer.isHidden = true
			btnInfoEdit.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
		}
		txtvNote.resignFirstResponder()
	}
	
	//Cancel button, turn off customer detail view, back to customer list
	@IBAction func backToCustomerListButtonClicked(_ sender: Any) {
		flagStar = true
		if (flagStar == true || flagNote == true){
			let alert = create1ActionAlert(title: ALERT_DATA_CHANGED, message: ALERT_ASK_FOR_SAVE, actionTitle: "Save", cancelTitle: "Cancel", cancelCompletion: {
				//Handle for cancel action
				self.handleCancelingAfterChooseInAlert()
			}) {
				//self.handleCancelingAfterChooseInAlert()
				//Handle for save action
				//Change in both rating star and note
				if (self.flagStar == true && self.flagNote == true) {
					//Check 400 characters
					if self.txtvNote.text.count > 400 {
						
					} else {
						self.flagNote = false
					}
					
					self.flagStar = false
					
				}
				//Change in rating star
				else if (self.flagStar == true && self.flagNote == false){
					self.flagStar = false
				}
				//Change in and note
				else {
					self.flagNote = false
				}
			}
			self.present(alert, animated: true, completion: nil)
		}
		
	}
	
	func handleCancelingAfterChooseInAlert(){
		//Hide Customer detail view
		viewCustomerDetailContainer.isHidden = true
		UIView.animate(withDuration: 0.5) {
			self.viewCustomerDetailContainer.alpha = 0
		}
		txtvNote.resignFirstResponder()
		viewNoteContainer.isHidden = false
		btnInfoEdit.setImage(#imageLiteral(resourceName: "info"), for: .normal)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		//Setup UI
		setupUI()
		//Setup table view
		setupTableView()
		//Setup data for page
		setupPagesInfo()
		//Setup calling manager
		setupCallingManager()
		
		//Setup push (if available)
		if (defaults.object(forKey: KEY_ISPUSH) as? Bool) == true {
			let customerList = project.customerListSeperated[KEY_STILL_NOT]!
			for i in 0..<customerList.count{
				if customerList[i].idCustomer == pushCustomerId {
					chosenCustomer = customerList[i]
					break
				}
			}
			showViewCustomerDetail()
			defaults.set(false, forKey: KEY_ISPUSH)
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
	}
	
	func setupUI() {
		viewRating.addSubview(cosmosView)
		viewRating.layer.cornerRadius = 20
		
		let contraints = AutoLayout.shared.getCenterConstraint(currentView: cosmosView, destinationView: viewRating)
		viewRating.addConstraints(contraints)
		
		cosmosView.didTouchCosmos = { rating in

		}
		
		txtvNote.delegate = self
		if chosenCustomer.note == "" {
			txtvNote.text = NOTE_PLACE_HOLDER
			txtvNote.textColor = UIColor.lightGray
		} else {
			txtvNote.text = chosenCustomer.note
			txtvNote.textColor = UIColor.black
		}
	}
	
	//Set up delegate and data source for tableviews
	func setupTableView(){
		tbCustomerList.delegate = self
		tbCustomerList.dataSource = self
		tbCustomerDetail.delegate = self
		tbCustomerDetail.dataSource = self
		tbCustomerDetail.rowHeight = UITableView.automaticDimension
		tbCustomerDetail.estimatedRowHeight = 600
	}
	
	//Setup data for first time
	func setupPagesInfo(){
		//Hide back button title
		self.navigationController?.navigationBar.topItem!.title = " "
		//Set page's title (name of project)
		self.title = self.project.name
		//Set customer quantity information
		//setupCustomerQuantity()
	}
	
//	Set customer quantity information
//	func setupCustomerQuantity() {
//		let quantityStillNot = project.customerListSeperated[KEY_STILL_NOT]!.count
//		let quantityAlready = project.customerListSeperated[KEY_ALREADY]!.count
//		self.lblCustomerQuantity.text = "\(quantityStillNot)/\(quantityStillNot + quantityAlready) khách hàng cần được tư vấn"
//	}
	
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
	
	func showViewCustomerDetail(){
		//Reset scroll position to 0
		tbCustomerDetail.contentOffset = CGPoint.zero
		
		//Reload table customer detail to update new values
		DispatchQueue.main.async {
			self.tbCustomerDetail.reloadData()
		}
		
		//Show Customer detail view
		viewCustomerDetailContainer.isHidden = false
		UIView.animate(withDuration: 0.5) {
			self.viewCustomerDetailContainer.alpha = 1
		}
	}
}

// MARK: Table view
extension CustomerListVC: UITableViewDelegate, UITableViewDataSource {
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
				return project.customerListSeperated[KEY_STILL_NOT]!.count
			}
				//Already contacted customer list
			else {
				return project.customerListSeperated[KEY_ALREADY]!.count
			}
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
			
			//Get current customer from customer list depend on which section
			let currentCustomer: Customer!
			//From Still not contact customer list
			if indexPath.section == 0 {
				currentCustomer = project.customerListSeperated[KEY_STILL_NOT]![indexPath.row]
				//Set section
				cell.section = KEY_STILL_NOT
			}
				//From Already contacted customer list
			else {
				currentCustomer = project.customerListSeperated[KEY_ALREADY]![indexPath.row]
				//Set section
				cell.section = KEY_ALREADY
			}
			
			//Set customer name (3 checks)
			var displayName: String = ""
			//Check if customer don't have first name (access facebook)
			if (currentCustomer.firstName.contains("facebook.com")){
				displayName = "Truy cập FB khách"
			} else {
				//Check if customer don't have last name
				if (currentCustomer.lastName != "") {
					displayName += "\(currentCustomer.lastName) "
				}
				displayName += "\(currentCustomer.firstName)"
				
				//Check if customer name too long
				let limitLength = 18
				if (displayName.count > limitLength){
					displayName = "..\(displayName.maxLengthFromRightToLeft(length: limitLength))"
				}
			}
			cell.lblCustomerName.text = displayName
			
			//Set customer phone number
			cell.lblPhoneNumber.text = currentCustomer.phoneNumber
			
			//Set order of customer
			cell.lblOrder.text = "\(indexPath.row + 1)"
			
			//Set color for called customer
			if (indexPath.section == 1) {
				cell.viewOrder.backgroundColor = UIColor(red: 36/255, green: 161/255, blue: 94/255, alpha: 1)
			} else {
				cell.viewOrder.backgroundColor = UIColor(red: 221/255, green: 80/255, blue: 94/255, alpha: 1)
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
			
			//Check if customer name too long
			let displayName = "\(chosenCustomer.lastName) \(chosenCustomer.firstName)"
			let limitLength = 18
			if (displayName.count > limitLength){
				self.lblCustomerName.text = "..\(displayName.maxLengthFromRightToLeft(length: limitLength))"
			}
			//Set customer name
			self.lblCustomerName.text = "\(chosenCustomer.lastName) \(chosenCustomer.firstName)"
			//Set title thumbnail
			cell.imgTitle.image = UIImage(named: arrImageTitle[currentRow])
			//Set title
			cell.lblTitle.text = arrTitle[currentRow]
			//let arrTitle = ["Dự án", "Thông điệp", "Nguồn", "Số điện thoại", "Facebook", "Email", "Ngày liên lạc", "Giới tính", "Ngày sinh", "Liên lạc", "Số lần liên lạc thành công", "Thời gian liên lạc thành công"]
			//Get description
			var description = ""
			switch currentRow {
			case 0: //Project name
				description = project.name
			case 1: //Message
				description = chosenCustomer.message
			case 2: //Source
				description = chosenCustomer.source
			case 3: //Phone number
				description = chosenCustomer.phoneNumber
			case 4: //Facebook account
				description = chosenCustomer.fbAccount
			case 5: //Email address
				description = chosenCustomer.email
			case 6: //Contact date
				description = chosenCustomer.dateContact
			case 7: //Gender
				description = chosenCustomer.gender
			case 8: //Birthday
				description = chosenCustomer.dayOfBirth
			case 9: //Call status
				description = chosenCustomer.callStatus == 0 ? "Chưa liên lạc" : "Đã liên lạc"
			case 10: //Call success times
				description = "Đã liên lạc \(chosenCustomer.callSuccessTimes) lần"
			case 11: //Call success minutes
				description = "Đã liên lạc được \(Int(round(chosenCustomer.callSuccessMinutes))) phút"
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//Table customer list
		if tableView == tbCustomerList {
			tbCustomerDetail.reloadInputViews()
			//Set chosen customser when click to any customer
			//From Still not contact customer list
			if indexPath.section == 0 {
				chosenCustomer = project.customerListSeperated[KEY_STILL_NOT]![indexPath.row]
			}
				//From Already contacted customer list
			else {
				chosenCustomer = project.customerListSeperated[KEY_ALREADY]![indexPath.row]
			}
			showViewCustomerDetail()
		}
			//Table customer detail
		else {
			//Phone call row
			if (indexPath.row == 3) {
				let phoneNumber = chosenCustomer.phoneNumber
				print(phoneNumber)
				//				let trongs = "0783636848"
				phoneNumber.makeAColl()
			}
		}
	}
}

// MARK: Text view delegate
extension CustomerListVC: UITextViewDelegate {
	@objc func keyboardWillAppear(notification: NSNotification?) {
		
		guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}
		
		let keyboardHeight: CGFloat
		if #available(iOS 11.0, *) {
			keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
		} else {
			keyboardHeight = keyboardFrame.cgRectValue.height
		}
		
		self.csBottomOfDetailCustomerView.constant = keyboardHeight + 30.0
		UIView.animate(withDuration: 0.5) {
			self.view.layoutIfNeeded()
		}
	}
	
	// Hide Keyboard when tapped somewhere on screen
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	@objc func keyboardWillDisappear(notification: NSNotification?) {
		self.csBottomOfDetailCustomerView.constant = 30.0
		UIView.animate(withDuration: 0.5) {
			self.view.layoutIfNeeded()
		}
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == UIColor.lightGray {
			textView.text = nil
			textView.textColor = UIColor.black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = NOTE_PLACE_HOLDER
			textView.textColor = UIColor.lightGray
		}
	}
}

// MARK: Calling
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
				chosenCustomer.updateCustomerCallingDetail { error in
					if !error {
						//Reset customer list
						self.project.checkAndResetCustomerList()
						//reload table's data
						DispatchQueue.main.async {
							self.tbCustomerList.reloadData()
						}
						//Get customer list
						self.project.getCustomerList(emailTeam: self.project.emailTeam, emailAddress: self.emailPersonal) {
							//reload table's data
							DispatchQueue.main.async {
								self.tbCustomerList.reloadData()
								//self.setupCustomerQuantity()
								//Set call flag to false to reuse
								self.connectFlag = false
							}
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
		//let phoneNumber = chosenCustomer.phoneNumber
		let phoneNumber = chosenCustomer.phoneNumber
		phoneNumber.makeAColl()
	}
	
	//Setup call management
	func setupCallingManager(){
		callObserver = CXCallObserver()
		callObserver.setDelegate(self, queue: nil) // nil queue means main thread
	}
}
