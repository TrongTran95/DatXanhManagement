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
	
	@IBOutlet weak var btnLogin: UIButton!
	
	@IBOutlet weak var smTestUsername: UISegmentedControl!
	
	let user = User()
	
	@IBAction func clickedLoginToUsersPage(_ sender: Any) {
		let userName: String = txtUsername.text!
		let password: String = txtPassword.text!
		//Check if the username or password is nil
		if (userName != "" && password != "") {
			//Start the login process
			user.login(userName: userName, password: password, ios_token: ios_device_token) { result in

				//Login success
				if result {
					defaults.set(userName, forKey: KEY_USER_EMAIL)
					defaults.set(password, forKey: KEY_USER_PASSWORD)
					defaults.set(ios_device_token, forKey: KEY_USER_DEVICE_TOKEN)
					DispatchQueue.main.async {
						//0 is team, 1 is personal
						if (self.user.type == 1){
							let userVC = mainStoryboard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
							userVC.user = self.user
							
							DispatchQueue.main.async {
								if (self.user.lastName == "" && self.user.firstName == ""){
									userVC.navigationItem.title = self.user.emailAddress
								} else {
									if (self.user.firstName == "" || self.user.lastName == ""){
										if (self.user.firstName == ""){
											userVC.navigationItem.setTitle(title: self.user.lastName, subtitle: self.user.emailAddress)
										}
										if (self.user.lastName == ""){
											userVC.navigationItem.setTitle(title: self.user.firstName, subtitle: self.user.emailAddress)
										}
									} else {
										userVC.navigationItem.setTitle(title: "\(self.user.firstName) \(self.user.lastName)", subtitle: self.user.emailAddress)
									}
								}
							}
							let nc = UINavigationController()
							nc.viewControllers = [userVC]
							appDelegate.window?.rootViewController = nc
							appDelegate.window?.makeKeyAndVisible()
							self.present(nc, animated: true, completion: nil)
							
						}
						else if (self.user.type == 2) {
							let adminVC = mainStoryboard.instantiateViewController(withIdentifier: "AdminVC") as! AdminVC
							adminVC.title = "Admin"
							let nc = UINavigationController()
							nc.viewControllers = [adminVC]
							appDelegate.window?.rootViewController = nc
							appDelegate.window?.makeKeyAndVisible()
							self.present(nc, animated: true, completion: nil)
						}
						else {
							self.performSegue(withIdentifier: "showTeamMenu", sender: self)
						}
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
        setupUI()
	}
	
	func setupUI(){
		btnLogin.layer.cornerRadius = 5
		let grayNum:CGFloat = 161/255
		let grayColor = UIColor(red: grayNum, green: grayNum, blue: grayNum, alpha: 1.0).cgColor
		txtPassword.layer.borderColor = grayColor
		txtUsername.layer.borderColor = grayColor
	}
	
	@IBAction func changeUsername(_ sender: Any) {
		if smTestUsername.selectedSegmentIndex == 0{
			txtUsername.text = "1ProjectsTest@gmail.com"
		} else if smTestUsername.selectedSegmentIndex == 1{
			txtUsername.text = "2ProjectsTest@gmail.com"
		} else {
			txtUsername.text = "test1@gmail.com"
		}
	}
	

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "showUserPage") {
			guard let userVC = segue.destination as? UserVC else { return }
			userVC.user = self.user
        } else if (segue.identifier == "showTeamMenu") {
            guard let teamTBC = segue.destination as? TeamTBC else { return }
            teamTBC.user = self.user
        }
	}
}
