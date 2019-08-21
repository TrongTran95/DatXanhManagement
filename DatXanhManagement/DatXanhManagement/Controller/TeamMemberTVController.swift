//
//  TeamMemberTVController.swift
//  DatXanhManagement
//
//  Created by ivc on 8/19/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit
import Toaster

class TeamMemberTVController: UITableViewController {
    
    var emailTeam: String = ""
    
    var memberQuantity = { (quantity: Int) in
        return "Member quantity: \(quantity)"
    }
    
    var userMembers: [UserMember] = []
    
    var tempUserMembers: [UserMember] = []
    
    var flagRemove: Bool = false
    
    var arrRemoveIndex:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        setupData()
    }
	override func viewDidLayoutSubviews() {
		setupUI()
	}
    
    func setupUI(){
        self.tabBarController?.navigationItem.title = "Team members"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        self.tabBarController?.navigationItem.rightBarButtonItems = [addButton, self.editButtonItem]
    }
    
    func setupData(){
        Services.shared.getUserMemberList(emailTeam: emailTeam, completion: { (dic) in
            for user in dic {
				let newMember = UserMember(id: user["id"] as! Int, emailPersonl: user["emailPersonal"] as! String)
                self.userMembers.append(newMember)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // Toggles the actual editing actions appearing on a table view
        self.tableView.setEditing(editing, animated: true)
        //Edit button, begin editing processs
        if (self.isEditing) {
            //Begin editing, save current data in case of any changes happen and we want to get the original data
            self.tempUserMembers = self.userMembers
        }
        //Done button, save new data (if avaiable)
        else {
			if flagRemove == true {
				showAlert()
			} else {
				resetData()
			}
        }
    }
	
	func showAlert(){
		let alert = UIAlertController(title: "Data changed", message: "Do you want to save new data ?", preferredStyle: .alert)
		//Handler for cancel button
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
			//Get data back from temporary user email detail list
			self.userMembers = self.tempUserMembers
			//Update new data of table view
			self.tableView.reloadData()
			//Release data
			self.resetData()
		}
		//Handler for save button
		let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
			//Nothing in the UI change because we've made change every time we do something in an editing process
			//Update new data to server
			//Remove user email detail from server
			for index in self.arrRemoveIndex {
				self.removeUserMember(emailAddress: self.tempUserMembers[index].emailPersonal)
			}
			
			//Release data
			self.resetData()
		}
		alert.addAction(cancelAction)
		alert.addAction(saveAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func resetData(){
		//Turn off flag remove
		flagRemove = false
		arrRemoveIndex = []
		tempUserMembers = []
	}
	
	func removeUserMember(emailAddress: String){
		Services.shared.removeUserMember(emailTeam: self.emailTeam, emailPersonal: emailAddress) { (error) in
			if !error {
				DispatchQueue.main.async {
					Toast(text: "Successed", duration: Delay.short).show()
				}
			} else {
				DispatchQueue.main.async {
					Toast(text: "Failed", duration: Delay.short).show()
				}
			}
		}
	}
    
    @objc func addButtonClicked (){
        let alert = UIAlertController(title: "Add new member", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField(textField:))
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0]
            //Check empty text field
            if textField.text == "" {
                self.present(createCancelAlert(title: "Found blank", message: "Please input email address", cancelTitle: "Cancel"), animated: true, completion: nil)
                return
            }
            
            let newMemberEmailAdress: String = textField.text!
			//Check if user existing in table view
			if self.tempUserMembers.contains(where: {$0.emailPersonal == newMemberEmailAdress}) {
				self.present(createCancelAlert(title: "User existed", message: "This user already existed in member list", cancelTitle: "Cancel"), animated: true, completion: nil)
				return
			}
            //Check if user existing in database, if not then add new member
            self.checkAndAddUserMember(newMemberEmailAdress)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkAndAddUserMember(_ newMemberEmailAdress: String){
        Services.shared.checkUserExist(emailTeam: self.emailTeam, emailPersonal: newMemberEmailAdress, completion: { (error) in
            //User is not existing in database
            if (!error) {
                //Add new member to database
                self.addUserMember(newMemberEmailAdress)
            }
                //Add to database failed
            else {
                self.present(createCancelAlert(title: "User existed", message: "This user already existed in member list", cancelTitle: "Cancel"), animated: true, completion: nil)
                return
            }
        })
    }
    
    func addUserMember(_ newMemberEmailAdress: String){
        Services.shared.addNewUserMember(emailTeam: self.emailTeam, emailPersonal: newMemberEmailAdress, completion: { (error) in
            //Add successed
            if (!error) {
                //Update UI
                DispatchQueue.main.async {
                    //Add new member to user array
					var newUserMember = UserMember()
					newUserMember.emailPersonal = newMemberEmailAdress
                    self.userMembers.append(newUserMember)
                    //Reload UI
                    self.tableView.reloadData()
                    //Show annoucement
                    Toast(text: "Successed", duration: Delay.short).show()
                }
            }
                //Add failed
            else {
                Toast(text: "Failed", duration: Delay.short).show()
                return
            }
        })
    }
    
    func configurationTextField(textField: UITextField) {
        textField.placeholder = "Please input new member's email"
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return memberQuantity(userMembers.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMembers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMembersCell", for: indexPath) as! TeamMemberTVC
        cell.lblEmail.text = userMembers[indexPath.row].emailPersonal
        cell.lblNumber.text = "\(indexPath.row + 1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Save id of row need to remove
            arrRemoveIndex.append(indexPath.row)
            
            //Delete from the array
            userMembers.remove(at: indexPath.row)
            
            //Delete row and update new order
            self.tableView.reloadData()
            
            //Turn on remove flag to show alert
            flagRemove = true
        }
    }
    
}
