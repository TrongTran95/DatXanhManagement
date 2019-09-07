//
//  TeamSettingTVC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/13/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit
import Toaster

class TeamSettingTVController: UITableViewController {
    
    
    var user:User!
    var tempUser: User = User()
	var arrRemovedID: [Int] = []
	
    var flagChangeOrder: Bool = false
    var flagRemove: Bool = false
    var flagChangeReceiveQuantity: Bool = false
    
    var addView: AddMemberView? = nil
    var projectName: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	func setupUI(){
		self.tabBarController?.navigationItem.title = "Order Sample"
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddMemberView))
		self.tabBarController?.navigationItem.rightBarButtonItems = [addButton, self.editButtonItem]
	}
	
	@objc func showAddMemberView(){
        Services.shared.getUserMemberList(emailTeam: user.emailAddress, completion: { (dic) in
            var userMembers:[UserMember] = []
            for user in dic {
                let newMember = UserMember(id: user["id"] as! Int, emailPersonl: user["emailPersonal"] as! String)
                userMembers.append(newMember)
            }
            DispatchQueue.main.async {
                if (self.addView == nil) {
                    self.setupAddMemberView(transfer: userMembers)
                } else {
                    self.addView?.userMembers = userMembers
                    self.addView?.tvUserMemberList.reloadData()
                }
            }
        })
	}
    
    //Handler for cancel button
    func turnOffAddView(){
        addView?.removeFromSuperview()
        addView = nil
    }
    
    func addNewUserEmailDetail(){
        var arrEmailPersonal: [String] = []
        //Filter email personal list where switch have been change to ON (true)
        for key in addView!.dicSwitchValue.keys {
            if addView?.dicSwitchValue[key] == true {
                arrEmailPersonal.append(self.addView!.userMembers[key].emailPersonal)
            }
        }
        //Check if any switch has been turned on
        //Switch that turned on available
        if (arrEmailPersonal.count != 0) {
            //Start the add user email detail process (count is params to make a recursive function)
            Services.shared.addUserEmailDetail(count: 0, emailTeam: self.user.emailAddress, emailPersonal: arrEmailPersonal, projectName: self.projectName) { (error) in
                //All add successed
                if (!error) {
                    //Get new user email detail list to update UI
                    Services.shared.getUserEmailDetailList(emailTeam: self.user.emailAddress, projectName: self.projectName, completion: { (userEmailDetailList) in
                        //Set new user email detail list
                        self.user.setUserEmailDetailList(userEmailDetailList: userEmailDetailList)
                        DispatchQueue.main.async {
                            //Update UI
                            self.tableView.reloadData()
                            //Turn off add view and show annoucement
                            self.turnOffAddView()
                            Toast(text: "Successed", duration: Delay.short).show()
                        }
                    })
                }
                //There's some error while adding new user email detail, show annoucement
                else {
                    DispatchQueue.main.async {
                        Toast(text: "Failed", duration: Delay.short).show()
                    }
                }
            }
        }
        //All switch is currently being turned off
        else {
            Toast(text: "Please choose at least 1 member to add", duration: Delay.short).show()
        }
    }
    
    func setupAddMemberView(transfer userMembers: [UserMember]){
        addView = AddMemberView()
        addView!.userMembers = userMembers
        addView?.delegate = self
        let height = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
        
        self.navigationController!.view.insertSubview(addView!, belowSubview: self.navigationController!.navigationBar)
        self.navigationController!.view.addConstraints(AutoLayout.shared.getTopLeftBottomRightConstraint(currentView: addView!, destinationView: self.navigationController!.view, constant: [height, 0, 0, 0]))
    }
	
	func setActiveForStepper(numberOfRow: Int, flag: Bool){
		for i in 0..<numberOfRow {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? TeamSettingTVC {
                cell.stReceiveNumber.isEnabled = flag
            }
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setupUI()
	}

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // Toggles the actual editing actions appearing on a table view
        self.tableView.setEditing(editing, animated: true)
		let currentUEDL = self.user.userEmailDetailList
		//Edit button, begin editing processs
        if (self.isEditing) {
            //Begin editing, save current data in case of any changes happen and we want to get the original data
			self.tempUser.setUserEmailDetailList(userEmailDetailList: currentUEDL)
			//Allow end user use stepper to change receive quantity
			setActiveForStepper(numberOfRow: currentUEDL.count, flag: true)
        }
		//Done button, save new data (if avaiable)
		else {
			//Check if changes have been made
            if (flagRemove || flagChangeOrder || flagChangeReceiveQuantity) {
				//Determine save new data or get back the original data
                showAlert()
            } else {
				/*Doing nothing here because there're no changes have been made from end user*/
			}
			//Unallow end user use stepper to change receive quantity
			setActiveForStepper(numberOfRow: currentUEDL.count, flag: false)
        }
    }
	
	func resetData(){
		//Set flag of changed to false
		flagRemove = false
		flagChangeReceiveQuantity = false
		flagChangeOrder = false
		//Remove data of temporary user email detail list to release memory
		self.tempUser.setUserEmailDetailList(userEmailDetailList: [])
		//Clear ID stored
		self.arrRemovedID = []
	}
    
    func showAlert(){
        let alert = UIAlertController(title: "Data changed", message: "Do you want to save new data ?", preferredStyle: .alert)
		//Handler for cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
			//Get data back from temporary user email detail list
			self.user.setUserEmailDetailList(userEmailDetailList: self.tempUser.userEmailDetailList)
			//Update new data of table view
			self.tableView.reloadData()
			//reset data
			self.resetData()
        }
		//Handler for save button
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            //Nothing in the UI change because we've made change every time we do something in an editing process
			//Update new data to server
			//Remove user email detail from server and reorder
			if (self.flagRemove) {
				self.removeUED()
			}
			
			//Update user email detail order
			if (self.flagChangeOrder) {
				self.makeChangeUserEmailDetailOrder()
			}
			
			//Update user email detail receive quantity
			if (self.flagChangeReceiveQuantity) {
				self.makeChangeUserEmailDetailReceiveQuantity()
			}
			
			//reset data
			self.resetData()
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }
	
	func removeUED(){
		for i in 0..<self.arrRemovedID.count {
			self.user.removeUserEmailDetail(id: self.arrRemovedID[i], completion: { (error) in
				if (error) {
					print("fail remove")
					return
				} else {
					print("success remove")
					self.makeChangeUserEmailDetailOrder()
				}
			})
		}
	}
	
	func makeChangeUserEmailDetailReceiveQuantity(){
		for i in 0..<self.user.userEmailDetailList.count {
			let currentUED = self.user.userEmailDetailList[i]
			self.user.updateUEDReceiveQuantity(id: currentUED.id, receiveQuantity: currentUED.receiveQuantity, completion: { (error) in
				if (error) {
					print("fail receive quantity")
					return
				} else {
					print("sucess receive quantity")
				}
			})
		}
	}
	
	func makeChangeUserEmailDetailOrder(){
		for i in 0..<self.user.userEmailDetailList.count {
			let currentUED = self.user.userEmailDetailList[i]
			self.user.updateUEDOrderNumber(userEmailDetail: currentUED, completion: { (error) in
				if (error) {
					print("fail order")
					return
				} else {
					print("sucess order")
				}
			})
		}
	}
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.userEmailDetailList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamSettingTVC
        let currentUED = self.user.userEmailDetailList[indexPath.row]
        if (tableView.isEditing == false) {
            cell.setStepperEnable(value: false)
        }
        cell.setOrder(orderNumber: currentUED.orderNumber)
        cell.setReceiveNumber(receiveNumber: currentUED.receiveQuantity)
        cell.setUserPersonalEmail(emailAddress: currentUED.emailPersonal)
		cell.setStepperTag(tag: indexPath.row)
        cell.setupStepperData(currentValue: currentUED.receiveQuantity, maximumValue: 10)
		cell.delegate = self
        return cell
    }
    
    //Height of table view cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // Allow move rows
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Handle for move rows (after stop holding row)
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //Get current and destination row index
        var currentRow = sourceIndexPath.row
        var destinationRow = destinationIndexPath.row
        
        //Change position in user email detai list
        //Save a temporary user email detail
        let userToMove = self.user.userEmailDetailList[currentRow]
        //Remove original UED at original row
        self.user.removeUserEmailDetail(at: currentRow)
        //Insert temporary UED to destination row
        self.user.insertUserEmailDetail(userToMove, at: destinationRow)
        
        //Change order of UED from current row to destination row
        //Check if move from large position to small position for handler below
        if currentRow > destinationRow {
            let temp = currentRow
            currentRow = destinationRow
            destinationRow = temp
        }
        //Set order number of user email detail
        for i in currentRow...destinationRow {
            self.user.userEmailDetailList[i].setOrderNumber(orderNumber: i+1)
        }
        
        //Upload layout
        self.tableView.reloadData()
        
        //Update flag to know that rows has been changed
        flagChangeOrder = true
    }
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			//Save id of row need to remove
			arrRemovedID.append(self.user.userEmailDetailList[indexPath.row].id)
			
			//Delete from the array
			self.user.removeUserEmailDetail(at: indexPath.row)
			
			//Set new order after remove
			for i in indexPath.row..<self.user.userEmailDetailList.count {
				self.user.userEmailDetailList[i].setOrderNumber(orderNumber: i+1)
			}
			
			//Delete row and update new order
			tableView.reloadData()
			
			//Turn on remove flag to show alert
			flagRemove = true
		}
	}

}
