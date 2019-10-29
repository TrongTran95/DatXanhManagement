//
//  ProjectListVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 10/27/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class ProjectListVC: UIViewController {

	@IBOutlet weak var btnAddProject: UIButton!
	
	@IBAction func actAddProject(_ sender: Any) {
		let alert = UIAlertController(title: "Add new Project", message: "", preferredStyle: .alert)
		
		alert.addTextField(configurationHandler: configurationTextField(textField:))
		let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
			let textField = alert.textFields![0]
			//Check empty text field
			if textField.text == "" {
				self.present(createCancelAlert(title: "Found blank", message: "Please input project name", cancelTitle: "Cancel"), animated: true, completion: nil)
				return
			}
			
			let newProjectName: String = textField.text!
			//Check if project existing in table view
//			if self.tempUserMembers.contains(where: {$0.emailPersonal == newMemberEmailAdress}) {
//				self.present(createCancelAlert(title: "User existed", message: "This user already existed in member list", cancelTitle: "Cancel"), animated: true, completion: nil)
//				return
//			}
//			//Check if user existing in database, if not then add new member
//			self.checkAndAddUserMember(newMemberEmailAdress)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(addAction)
		alert.addAction(cancelAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func configurationTextField(textField: UITextField) {
		textField.placeholder = "Please input new project name"
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }

}
