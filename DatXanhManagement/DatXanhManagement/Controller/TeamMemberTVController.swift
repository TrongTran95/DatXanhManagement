//
//  TeamMembersVC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/19/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit
import Toaster

class TeamMemberTVController: UITableViewController {
    
    @IBOutlet weak var lblMemberQuantity: UILabel!
    
    @IBOutlet weak var tvTeamMembers: UITableView!
    
    var emailTeam: String = ""
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvTeamMembers.delegate = self
        tvTeamMembers.dataSource = self
        
        self.tabBarController?.navigationItem.title = "Team members"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(abc))
        
        setupDataTable()
    }
    
    func setupDataTable(){
        Services.shared.getUserMemberList(emailTeam: emailTeam, completion: { (dic) in
            for user in dic {
                let newUser = User(emailAddress: user["emailPersonal"] as! String)
                self.users.append(newUser)
            }
            DispatchQueue.main.async {
                self.lblMemberQuantity.text = "Member quantity: \(self.users.count)"
                self.tvTeamMembers.reloadData()
            }
        })
    }
    
    @objc func abc (){
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
            if self.users.contains(where: {$0.emailAddress == newMemberEmailAdress}) {
                self.present(createCancelAlert(title: "User existed", message: "This user already existed in member list", cancelTitle: "Cancel"), animated: true, completion: nil)
                return
            }
            //Check if user existing in database
            Services.shared.checkUserExist(emailTeam: self.emailTeam, emailPersonal: newMemberEmailAdress, completion: { (error) in
                //User is not existing in database
                print(error)
                if (!error) {
                    //Add new member to database
                    Services.shared.addNewUserMember(emailTeam: self.emailTeam, emailPersonal: newMemberEmailAdress, completion: { (error) in
                        //Add successed
                        if (!error) {
                            //Add new member to user array
                            self.users.append(User(emailAddress: newMemberEmailAdress))
                            //Update UI
                            DispatchQueue.main.async {
                                self.tvTeamMembers.beginUpdates()
                                self.tvTeamMembers.insertRows(at: [IndexPath(row: self.users.count - 1, section: 0)], with: .automatic)
                                self.tvTeamMembers.endUpdates()
                                self.lblMemberQuantity.text = "Số thành viên: \(self.users.count)"
                            }
                            //Show annoucement
                            Toast(text: "Successed", duration: Delay.short).show()
                        }
                        //Add failed
                        else {
                            Toast(text: "Failed", duration: Delay.short).show()
                            return
                        }
                    })
                }
                //Add to database failed
                else {
                    self.present(createCancelAlert(title: "User existed", message: "This user already existed in member list", cancelTitle: "Cancel"), animated: true, completion: nil)
                    return
                }
            })
            
            //Check if user existing in database
            //Get and set user name, update table view
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func configurationTextField(textField: UITextField) {
        textField.placeholder = "Please input new member's email"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMembersCell", for: indexPath) as! TeamMemberTVC
        cell.lblEmail.text = users[indexPath.row].emailAddress
        cell.lblNumber.text = "\(indexPath.row + 1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
