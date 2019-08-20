//
//  LoginVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/14/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
	
	
	@IBOutlet weak var txtUsername: UITextField!
	
	@IBOutlet weak var txtPassword: UITextField!
	
	@IBOutlet weak var smTestUsername: UISegmentedControl!
	
	let user = User()
	
	@IBAction func clickedLoginToUsersPage(_ sender: Any) {
		let userName: String = txtUsername.text!
		let password: String = txtPassword.text!
		//Check if the username or password is nil
		if (userName != "" && password != "") {
			//Start the login process
			user.login(userName: userName, password: password) {
				//Login success
				if(self.user.emailAddress != ""){
					DispatchQueue.main.async {
//                        self.performSegue(withIdentifier: "showUserPage", sender: self)
                        self.performSegue(withIdentifier: "showTeamMenu", sender: self)
					}
				}
				//Wrong username or password
				else {
					print("Sai pass")
				}
			}
		}else {
			//username or password is nil
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
	}
	
	@IBAction func changeUsername(_ sender: Any) {
		if smTestUsername.selectedSegmentIndex == 0{
			txtUsername.text = "1ProjectsTest@gmail.com"
		} else if smTestUsername.selectedSegmentIndex == 1{
			txtUsername.text = "2ProjectsTest@gmail.com"
		} else {
			txtUsername.text = "3ProjectsTest@gmail.com"
		}
	}
	

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "showUserPage") {
			guard let userVC = segue.destination as? UserVC else { return }
			userVC.user = self.user
        } else if (segue.identifier == "showTeamMenu") {
            guard let teamTBC = segue.destination as? TeamTBC else { return }
            teamTBC.emailTeam = self.user.emailAddress
        }
	}
}

