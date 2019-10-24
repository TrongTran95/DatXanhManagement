//
//  AdminVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 10/24/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

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
	
	var userType = UserType(rawValue: 0)!
	
	var activeTextField = UITextField()
	var keyboardHeight: CGFloat = 0.0
	
	@IBAction func DidSelectUserType(_ sender: UISegmentedControl) {
		userType = UserType(rawValue: sender.selectedSegmentIndex)!
	}
	
	@IBAction func actAddUser(_ sender: Any) {
		
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
	
	var viewAddUserHeight: CGFloat!
	var screenHeight: CGFloat!
	var topBarHeight: CGFloat!
	var spaceBetweenViewAddAndMainScreen:CGFloat!
	
	var users:[User] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
		viewRealAddUser.translatesAutoresizingMaskIntoConstraints = false
		txtLastName.delegate = self
		txtPassword.delegate = self
		txtUsername.delegate = self
		txtFirstName.delegate = self
		activeTextField.delegate = self
		
		viewAddUserHeight = viewRealAddUser.frame.size.height
		screenHeight = UIScreen.main.bounds.size.height
		topBarHeight = UIApplication.shared.statusBarFrame.size.height +
			(self.navigationController?.navigationBar.frame.height ?? 0.0)
		spaceBetweenViewAddAndMainScreen = (screenHeight - topBarHeight - viewAddUserHeight)/2
		
		btnShowAddView.layer.cornerRadius = btnShowAddView.frame.size.height / 2
		
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

extension AdminVC: UITextFieldDelegate {
	@objc func keyboardWillAppear(notification: NSNotification?) {
		guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}
		if #available(iOS 11.0, *) {
			keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
		} else {
			keyboardHeight = keyboardFrame.cgRectValue.height
		}
		
		if (viewAddUser.selectedTextField == txtLastName) {
			if (keyboardHeight > spaceBetweenViewAddAndMainScreen + 60) {
				self.csCenterYOfViewAddUser.constant = -(keyboardHeight - 60 - spaceBetweenViewAddAndMainScreen)
			}
		} else if (viewAddUser.selectedTextField == txtFirstName) {
			if (keyboardHeight > spaceBetweenViewAddAndMainScreen + 60 + 53) {
				let newSpace:CGFloat = 60 + 53 + 10
				self.csCenterYOfViewAddUser.constant = -keyboardHeight + newSpace + spaceBetweenViewAddAndMainScreen
			}
		} else if (viewAddUser.selectedTextField == txtPassword) {
			if (keyboardHeight > spaceBetweenViewAddAndMainScreen + 70 + 106) {
				let newSpace:CGFloat = 60 + 106 + 20
				self.csCenterYOfViewAddUser.constant = -keyboardHeight + newSpace + spaceBetweenViewAddAndMainScreen
			}
		}
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

extension UIView {
	var textFieldsInView: [UITextField] {
		return subviews
			.filter ({ !($0 is UITextField) })
			.reduce (( subviews.compactMap { $0 as? UITextField }), { summ, current in
				return summ + current.textFieldsInView
			})
	}
	var selectedTextField: UITextField? {
		return textFieldsInView.filter { $0.isFirstResponder }.first
	}
}
