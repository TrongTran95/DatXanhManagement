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
    
    var users: [String] = []
    
    var tempUsers: [String] = []
    
    var flagRemove: Bool = false
    
    var arrRemoveIndex:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
    }
    
    func setupUI(){
        self.tabBarController?.navigationItem.title = "Team members"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        self.tabBarController?.navigationItem.rightBarButtonItems = [addButton, self.editButtonItem]
    }
    
    func setupData(){
        Services.shared.getUserMemberList(emailTeam: emailTeam, completion: { (dic) in
            for user in dic {
                self.users.append(user["emailPersonal"] as! String)
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
            self.tempUsers = self.users
        }
        //Done button, save new data (if avaiable)
        else {
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
            if (self.users.contains(newMemberEmailAdress)) {
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
                    self.users.append(newMemberEmailAdress)
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
        return memberQuantity(users.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMembersCell", for: indexPath) as! TeamMemberTVC
        cell.lblEmail.text = users[indexPath.row]
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
            users.remove(at: indexPath.row)
            
            //Set new order after remove
//            for i in indexPath.row..<self.users.count {
//                self.user.userEmailDetailList[i].setOrderNumber(orderNumber: i+1)
//            }
            
            //Delete row and update new order
            self.tableView.reloadData()
            
            //Turn on remove flag to show alert
            flagRemove = true
        }
    }
    
}
