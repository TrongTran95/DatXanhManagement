//
//  ChangePasswordVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 10/26/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

	@IBOutlet weak var txtOldPassword: DesignableUITextField!
	
	@IBOutlet weak var txtNewPassword: DesignableUITextField!
	
	@IBOutlet weak var txtConfirmNewPassword: DesignableUITextField!
	
	@IBOutlet weak var btnSubmit: UIButton!
	
	@IBOutlet weak var csCenterYOfChangePasswordView: NSLayoutConstraint!
	
	@IBOutlet weak var viewChangePassword: UIStackView!
	
	var emailAddress: String!
	
	@IBAction func actChangePassword(_ sender: Any) {
		let oldPassword = txtOldPassword.text ?? ""
		let newPassword = txtNewPassword.text ?? ""
		let confirmPassword = txtConfirmNewPassword.text ?? ""
		//Old = new = confirm = ""
		if (oldPassword == "" || newPassword == "" || confirmPassword == "") {
			let alert = createCancelAlert(title: "Blank found", message: "Please fill out all field", cancelTitle: "Cancel")
			DispatchQueue.main.async {
				self.present(alert, animated: true, completion: nil)
			}
			return
		}
		
		Services.shared.checkPassword(emailAddress: emailAddress, password: oldPassword) { (error) in
			//Wrong password
			if (error == true) {
				let alert = createCancelAlert(title: "Wrong password", message: "", cancelTitle: "Cancel")
				DispatchQueue.main.async {
					self.present(alert, animated: true, completion: nil)
				}
				return
			}
			//Old = new
			if (oldPassword == newPassword) {
				let alert = createCancelAlert(title: "Duplicated password", message: "New password must be different from old password", cancelTitle: "Cancel")
				DispatchQueue.main.async {
					self.present(alert, animated: true, completion: nil)
				}
				return
			}
			//New != confirm
			if (newPassword != confirmPassword) {
				let alert = createCancelAlert(title: "Wrong confirm password", message: "Confirm password must be different from new password", cancelTitle: "Cancel")
				DispatchQueue.main.async {
					self.present(alert, animated: true, completion: nil)
				}
				return
			}
			
			Services.shared.changePassword(emailAddress: self.emailAddress, password: newPassword, completion: { (error) in
				if (error == true) {
					let alert = createCancelAlert(title: "Can't change password", message: "Something wrong happened", cancelTitle: "Cancel")
					DispatchQueue.main.async {
						self.present(alert, animated: true, completion: nil)
					}
					return
				} else {
					let alert = createCancelAlertWithAction(title: "Successfully changed password", message: "", cancelTitle: "Ok", cancelCompletion: {
						DispatchQueue.main.async {
							self.navigationController?.popToRootViewController(animated: true)
						}
					})
					DispatchQueue.main.async {
						self.present(alert, animated: true, completion: nil)
					}
				}
			})
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		btnSubmit.layer.cornerRadius = 5
    }
	
	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
	}

}


// MARK: Text view delegate
extension ChangePasswordVC {
	@objc func keyboardWillAppear(notification: NSNotification?) {
		self.csCenterYOfChangePasswordView.constant = -75
		
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}
	
	// Hide Keyboard when tapped somewhere on screen
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	@objc func keyboardWillDisappear(notification: NSNotification?) {
		self.csCenterYOfChangePasswordView.constant = 0
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}
}
