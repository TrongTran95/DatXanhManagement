//
//  SeperateVC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/23/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit
import Toaster

class SeperateVC: UIViewController {
    
    @IBOutlet weak var leftConstraintOfMovingView: NSLayoutConstraint!
    
    @IBOutlet weak var btnOld: UIButton!
    
    @IBOutlet weak var btnNew: UIButton!
    
    @IBOutlet weak var tvOldSeperated: UITableView!
    
    @IBOutlet weak var tvNewSeperate: UITableView!
    
    @IBOutlet weak var rightConstraintOfOldSeperatedTableView: NSLayoutConstraint!
	
	let blueColor = UIColor(red: 76, green: 139, blue: 246, alpha: 1.0)
	
	let grayColor = UIColor(red: 190, green: 190, blue: 190, alpha: 1.0)
	
	var addView: AddSeperateView!
	
	var emailTeam: String!
	var projectName: String!
	
	var userEmailSeperateListStillNotReceive: [UserEmailSeperate] = []
	var userEmailSeperateListReceived: [UserEmailSeperate] = []
	
	var addButton: UIBarButtonItem!
	var removeButton: UIBarButtonItem!
	
	
    @IBAction func tappedButtonOldOrNew(_ sender: UIButton) {
        let currentTitle = sender.currentTitle!
        setOldNewButtonAttribute(title: currentTitle)
        setOldNewTableViewAttribute(title: currentTitle)
		setDataForTableView(title: currentTitle)
		setBarButtonUI(title: currentTitle)
    }
	
	func setBarButtonUI(title: String) {
		switch title {
		case "Waiting":
			self.addButton.isEnabled = true
			self.removeButton.isEnabled = true
		default: //"Received"
			self.addButton.isEnabled = false
			self.removeButton.isEnabled = false
		}
	}
	
	func setDataForTableView(title: String) {
		switch title {
		case "Waiting":
			self.userEmailSeperateListReceived = []
			self.setupData()
		default: //"Received"
			self.userEmailSeperateListStillNotReceive = []
			self.getReceivedUserListAndBriefCustomerInfo()
		}
	}
    
    func setOldNewTableViewAttribute(title: String){
        UIView.animate(withDuration: 0.2) {
            switch title {
            case "Waiting":
                self.rightConstraintOfOldSeperatedTableView.constant = 0
            default: //"Received"
                self.rightConstraintOfOldSeperatedTableView.constant = -self.tvOldSeperated.frame.size.width
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func setOldNewButtonAttribute(title: String){
        UIView.animate(withDuration: 0.2, animations: {
            switch title {
            case "Waiting":
				self.leftConstraintOfMovingView.constant = 0
            default: //"Received"
				self.leftConstraintOfMovingView.constant = self.btnOld.frame.size.width
            }
            self.view.layoutIfNeeded()
        })
    }
	
	func getReceivedUserListAndBriefCustomerInfo(){
		Services.shared.getUserEmailSeperateListReceived(emailTeam: self.emailTeam, projectName: self.projectName) { (userEmailSeperateList) in
			let dispatchGroup = DispatchGroup()
			self.userEmailSeperateListReceived = userEmailSeperateList
			for i in 0..<self.userEmailSeperateListReceived.count {
				dispatchGroup.enter()
				Services.shared.getBriefInfoOfCustomer(idCustomer: self.userEmailSeperateListReceived[i].customerID, completion: { (briefCustomer) in
					self.userEmailSeperateListReceived[i].setBriefCustomer(briefCustomer: briefCustomer)
					dispatchGroup.leave()
				})
			}
			dispatchGroup.notify(queue: .main) {
				DispatchQueue.main.async {
					//Show UI
					self.tvOldSeperated.reloadData()
				}
			}
		}
	}
	
	//Handler for cancel button
	func turnOffAddView(){
		addView?.removeFromSuperview()
		addView = nil
	}
	
	func addNewSeperate(){
		//Check at least 1 user email detail exist
		if (addView.userEmailDetailList.count != 0) {
			//Start Add user email seperate
			Services.shared.addUserEmailSeperate(emailTeam: emailTeam, userEmailDetailList: addView.userEmailDetailList, projectName: projectName, multiplier: Int(addView.stepperMultiplier.value)) {
				//Get user email seperate to display
				Services.shared.getUserEmailSeperateListStillNotReceive(emailTeam: self.emailTeam, projectName: self.projectName, completion: { (userEmailSeperateList) in
					self.userEmailSeperateListStillNotReceive = userEmailSeperateList
					DispatchQueue.main.async {
						//Show UI
						self.tvNewSeperate.reloadData()
						//Turn off addView screen and show Toast (main queue)
						self.turnOffAddView()
					}
				})
			}
		} else {
			//Show Toast
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func setupTableView(){
		tvNewSeperate.delegate = self
		tvNewSeperate.dataSource = self
		tvOldSeperated.delegate = self
		tvOldSeperated.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setupUI()
		setupTableView()
		setupData()
	}
	
	func setupData(){
		Services.shared.getUserEmailSeperateListStillNotReceive(emailTeam: self.emailTeam, projectName: self.projectName, completion: { (userEmailSeperateList) in
			DispatchQueue.main.async {
				self.userEmailSeperateListStillNotReceive = userEmailSeperateList
				self.tvNewSeperate.reloadData()
			}
		})
	}
	
	func setupUI(){
		self.tabBarController?.navigationItem.title = "Seperate"
		addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showSeperateView))
		addButton.tintColor = colorBlack
		removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeUserEmailSeperateList))
		removeButton.tintColor = colorBlack
		self.tabBarController?.navigationItem.rightBarButtonItems = [addButton, removeButton]
	}
	
	@objc func removeUserEmailSeperateList(){
		if (leftConstraintOfMovingView.constant == 0){
			if (userEmailSeperateListStillNotReceive.count != 0) {
				showAlertRemoveAll()
			}
		}
	}
	
	func showAlertRemoveAll(){
		let alert: UIAlertController = UIAlertController(title: "Remove all", message: "Remove users still not receive customer", preferredStyle: .alert)
		let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let removeAction: UIAlertAction = UIAlertAction(title: "Remove", style: .destructive) { (action) in
			self.removeAll()
		}
		alert.addAction(cancelAction)
		alert.addAction(removeAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func removeAll(){
		Services.shared.removeAllUserEmailSeperateStillNotReceived(emailTeam: emailTeam, projectName: projectName) { (error) in
			if !error {
				//Success, remove current data, update UI, show toast
				self.userEmailSeperateListStillNotReceive = []
				DispatchQueue.main.async {
					self.tvNewSeperate.reloadData()
				}
			} else {
				//
			}
		}
	}
	
	@objc func showSeperateView(){
		//Get user email detail list
		Services.shared.getUserEmailDetailList(emailTeam: emailTeam, projectName: projectName) { (list) in
			DispatchQueue.main.async {
				self.setupAddSeperateView(transfer:list)
			}
		}
	}
	
	func setupAddSeperateView(transfer userEmailDetailList: [UserEmailDetail]){
		addView = AddSeperateView()
		addView!.userEmailDetailList = userEmailDetailList
		addView?.delegate = self
		let height = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
		
		self.navigationController!.view.insertSubview(addView!, belowSubview: self.navigationController!.navigationBar)
		self.navigationController!.view.addConstraints(AutoLayout.shared.getTopLeftBottomRightConstraint(currentView: addView!, destinationView: self.navigationController!.view, constant: [height, 0, 0, 0]))
	}

}

extension SeperateVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (tableView == tvNewSeperate) {
			return userEmailSeperateListStillNotReceive.count
		} else {
			return userEmailSeperateListReceived.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (tableView == tvNewSeperate) {
			let cell = tableView.dequeueReusableCell(withIdentifier: "newSeperateCell", for: indexPath) as? NewSeperateTVCell
			let currentUser = userEmailSeperateListStillNotReceive[indexPath.row]
			cell!.setData(emailPersonal: currentUser.emailPersonal, orderNumber: currentUser.orderNumber)
			return cell!
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "oldSeperatedCell", for: indexPath) as? OldSeperatedTVCell
			let currentUser = userEmailSeperateListReceived[indexPath.row]
			cell?.setData(userEmail: currentUser.emailPersonal, orderNumber: indexPath.row + 1, customer: currentUser.briefCustomer)
			return cell!
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
}
