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
							//			nc.viewControllers = [loginVC]
							let nc = UINavigationController()
							nc.viewControllers = [userVC]
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
	override func viewWillAppear(_ animated: Bool) {
//		self.navigationItem.titleView = setTitle(title: "abc", subtitle: "xyz")

	}
	override func viewDidAppear(_ animated: Bool) {
//		self.navigationItem.titleView = setTitle(title: "abc", subtitle: "xyz")

	}
	
	override func viewDidLayoutSubviews() {

	}
	func setupUI(){
		btnLogin.layer.cornerRadius = 5
		let grayNum:CGFloat = 161/255
		let grayColor = UIColor(red: grayNum, green: grayNum, blue: grayNum, alpha: 1.0).cgColor
		txtPassword.layer.borderColor = grayColor
		txtUsername.layer.borderColor = grayColor
	}
	
//	func setTitle(title:String, subtitle:String) -> UIView {
//		let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
//
//		titleLabel.backgroundColor = UIColor.clear
//		titleLabel.textColor = UIColor.gray
//		titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
//		titleLabel.text = title
//		titleLabel.sizeToFit()
//
//		let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
//		subtitleLabel.backgroundColor = UIColor.clear
//		subtitleLabel.textColor = UIColor.black
//		subtitleLabel.font = UIFont.systemFont(ofSize: 12)
//		subtitleLabel.text = subtitle
//		subtitleLabel.sizeToFit()
//
//		let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
//		titleView.addSubview(titleLabel)
//		titleView.addSubview(subtitleLabel)
//
//		let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
//
//		if widthDiff < 0 {
//			let newX = widthDiff / 2
//			subtitleLabel.frame.origin.x = abs(newX)
//		} else {
//			let newX = widthDiff / 2
//			titleLabel.frame.origin.x = newX
//		}
//
//		return titleView
//	}

	
	
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

extension UINavigationItem {
	func setTitle(title:String, subtitle:String) {
		
		let one = UILabel()
		one.text = title
		one.font = UIFont.systemFont(ofSize: 17)
		one.sizeToFit()
		
		let two = UILabel()
		two.text = subtitle
		two.font = UIFont.systemFont(ofSize: 12)
		two.textAlignment = .center
		two.sizeToFit()
		
		
		
		let stackView = UIStackView(arrangedSubviews: [one, two])
		stackView.distribution = .equalCentering
		stackView.axis = .vertical
		stackView.alignment = .center
		
		let width = max(one.frame.size.width, two.frame.size.width)
		stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
		
		one.sizeToFit()
		two.sizeToFit()
		
		
		
		self.titleView = stackView
	}
}
