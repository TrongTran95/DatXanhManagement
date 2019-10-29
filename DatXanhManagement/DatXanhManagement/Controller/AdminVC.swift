//
//  AdminVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 10/24/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit
import Toaster

enum UserType: Int {
	case Team = 0
	case Personal = 1
	case Admin = 2
}

class AdminVC: UIViewController {

	@IBOutlet weak var viewAddUser: UIView!
	
	@IBOutlet weak var txtUsername: UITextField!
	
	@IBOutlet weak var txtPassword: UITextField!
	
	@IBOutlet weak var txtFirstName: UITextField!
	
	@IBOutlet weak var txtLastName: UITextField!
	
	@IBOutlet weak var smType: UISegmentedControl!
	
	@IBOutlet weak var csCenterYOfViewAddUser: NSLayoutConstraint!
	
	@IBOutlet weak var viewRealAddUser: UIView!
	
	@IBOutlet weak var tvUserList: UITableView!
	
	@IBOutlet weak var btnShowAddView: UIButton!
	
	@IBOutlet weak var pvProject: UIPickerView!
	
	var userType = UserType(rawValue: 0)!
	
	var keyboardHeight: CGFloat = 0.0
	var viewAddUserHeight: CGFloat!
	var screenHeight: CGFloat!
	var topBarHeight: CGFloat!
	var spaceBetweenViewAddAndMainScreen:CGFloat!
	
	var users:[User] = []
	
	var projects: [Project] = []
	var chosenProject: String = ""
	
	@IBAction func DidChangeValueUserType(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			pvProject.alpha = 1
			pvProject.isUserInteractionEnabled = true
		default:
			pvProject.alpha = 0.5
			pvProject.isUserInteractionEnabled = false
		}
	}
	
	@IBAction func DidSelectUserType(_ sender: UISegmentedControl) {
		userType = UserType(rawValue: sender.selectedSegmentIndex)!
	}
	
	@IBAction func actAddUser(_ sender: Any) {
		let userName = txtUsername.text ?? ""
		let password = txtPassword.text ?? ""
		let type = smType.selectedSegmentIndex
		let firstName = txtFirstName.text ?? ""
		let lastName = txtLastName.text ?? ""
		if (userName == "" || password == "" || firstName == "" || lastName == "") {
			let alert = createCancelAlert(title: "Blank found", message: "", cancelTitle: "OK")
			DispatchQueue.main.async {
				self.present(alert, animated: true, completion: nil)
			}
			return
		}
		Services.shared.checkAccountExist(emailAddress: userName) { (exist) in
			if (exist == true) {
				let alert = createCancelAlert(title: "Existed user name", message: "", cancelTitle: "OK")
				DispatchQueue.main.async {
					self.present(alert, animated: true, completion: nil)
				}
				return
			}
			Services.shared.addUser(emailAddress: userName, type: type, password: password, firstName: firstName, lastName: lastName) { (error) in
				if (error == true) {
					let alert = createCancelAlert(title: "Can't add user", message: "Something wrong happened", cancelTitle: "OK")
					DispatchQueue.main.async {
						self.present(alert, animated: true, completion: nil)
					}
					return
				}
				if (type == 0) {
					if (self.chosenProject == "") {
						self.chosenProject = self.projects[0].name
					}
					Services.shared.addUserProject(email: userName, projectName: self.chosenProject, emailTeam: "", completion: { (error) in
						if (error == true) {
							let alert = createCancelAlert(title: "Can't add user", message: "Something wrong happened", cancelTitle: "OK")
							DispatchQueue.main.async {
								self.present(alert, animated: true, completion: nil)
							}
							return
						}
						self.HandleAddUserSuccess()
					})
				} else {
					self.HandleAddUserSuccess()
				}
			}
		}
		
	}
	
	@IBAction func actCancelAddUser(_ sender: Any) {
		viewAddUser.isHidden = true
		UIView.animate(withDuration: 0.3) {
			self.viewAddUser.alpha = 0
		}
	}
	
	@IBAction func actShowAddUserView(_ sender: Any) {
		viewAddUser.isHidden = false
		UIView.animate(withDuration: 0.3) {
			self.viewAddUser.alpha = 1
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		viewRealAddUser.translatesAutoresizingMaskIntoConstraints = false
		
		viewAddUserHeight = viewRealAddUser.frame.size.height
		screenHeight = UIScreen.main.bounds.size.height
		topBarHeight = UIApplication.shared.statusBarFrame.size.height +
			(self.navigationController?.navigationBar.frame.height ?? 0.0)
		spaceBetweenViewAddAndMainScreen = (screenHeight - topBarHeight - viewAddUserHeight)/2
		
		btnShowAddView.layer.cornerRadius = btnShowAddView.frame.size.height / 2
		
		pvProject.delegate = self
		pvProject.dataSource = self
		
		Services.shared.getAllUser { (users) in
			self.users = users
			DispatchQueue.main.async {
				self.tvUserList.reloadData()
			}
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		Services.shared.getAllProject { (projects) in
			self.projects = projects
			DispatchQueue.main.async {
				self.pvProject.reloadAllComponents()
			}
		}
		
		let signoutButton = UIBarButtonItem(image: #imageLiteral(resourceName: "sign-out"), style: .plain, target: self, action: #selector(signOut))
		self.navigationItem.leftBarButtonItem = signoutButton

	}
	
	@objc func signOut(){
		let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
		defaults.set("", forKey: KEY_USER_EMAIL)
		defaults.set("", forKey: KEY_USER_PASSWORD)
		defaults.set("", forKey: KEY_USER_DEVICE_TOKEN)
		
		appDelegate.window?.rootViewController = loginVC
		appDelegate.window?.makeKeyAndVisible()
		self.present(loginVC, animated: true, completion: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
	}
	
	func HandleAddUserSuccess(){
		DispatchQueue.main.async {
			Toast(text: "Add successed", duration: Delay.short).show()
			Services.shared.getAllUser(completion: { (users) in
				self.users = users
				DispatchQueue.main.async {
					self.tvUserList.reloadData()
					self.smType.selectedSegmentIndex = 0
					self.pvProject.selectRow(0, inComponent: 0, animated: false)
					self.txtUsername.text = ""
					self.txtPassword.text = ""
					self.txtFirstName.text = ""
					self.txtLastName.text = ""
				}
			})
		}
	}
}

extension AdminVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserListTVC
		let currentUser = users[indexPath.row]
		cell.setDescription(email: currentUser.emailAddress, name: "\(currentUser.firstName) \(currentUser.lastName)", userType: currentUser.type)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
}

extension AdminVC {
	@objc func keyboardWillAppear(notification: NSNotification?) {
		guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}
		if #available(iOS 11.0, *) {
			keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
		} else {
			keyboardHeight = keyboardFrame.cgRectValue.height
		}
		
		if (keyboardHeight > spaceBetweenViewAddAndMainScreen + 170) {
			let move = keyboardHeight - spaceBetweenViewAddAndMainScreen - 165
			self.csCenterYOfViewAddUser.constant = -move
		}
		
//		if (viewAddUser.selectedTextField == txtLastName) {
//			if (keyboardHeight > spaceBetweenViewAddAndMainScreen + 60) {
//				self.csCenterYOfViewAddUser.constant = -(keyboardHeight - 60 - spaceBetweenViewAddAndMainScreen)
//			}
//		} else if (viewAddUser.selectedTextField == txtFirstName) {
//			if (keyboardHeight > spaceBetweenViewAddAndMainScreen + 60 + 53) {
//				let newSpace:CGFloat = 60 + 53 + 10
//				self.csCenterYOfViewAddUser.constant = -keyboardHeight + newSpace + spaceBetweenViewAddAndMainScreen
//			}
//		} else if (viewAddUser.selectedTextField == txtPassword) {
//			if (keyboardHeight > spaceBetweenViewAddAndMainScreen + 70 + 106) {
//				let newSpace:CGFloat = 60 + 106 + 20
//				self.csCenterYOfViewAddUser.constant = -keyboardHeight + newSpace + spaceBetweenViewAddAndMainScreen
//			}
//		}
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}
	
	// Hide Keyboard when tapped somewhere on screen
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	@objc func keyboardWillDisappear(notification: NSNotification?) {
		self.csCenterYOfViewAddUser.constant = 0
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}
}

extension AdminVC: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return projects.count
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let label = (view as? UILabel) ?? UILabel()
		
		label.textColor = .black
		label.textAlignment = .center
		label.font = UIFont(name: "SanFranciscoText-Light", size: 18)
		
		// where data is an Array of String
		label.text = projects[row].name
		
		return label
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		chosenProject = projects[row].name
	}
}
