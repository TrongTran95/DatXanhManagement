//
//  TeamTBC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/19/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class TeamTBC: UITabBarController, UITabBarControllerDelegate {
	var firstTab: TeamMemberTVController!
	var secondTab: TeamSettingTVController!
	var thirdTab: SeperateVC!
	var forthTab: ChartVC!

    var user: User!
	var projectName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
		setupData()
		
		Services.shared.getUserProjects(emailAddress: self.user.emailAddress) { (arrProject) in
			self.projectName = arrProject[0]["projectName"] as! String
			self.firstTab.projectName = self.projectName
			Services.shared.getUserEmailDetailList(emailTeam: self.user.emailAddress, projectName: self.projectName) { (userEmailDetailList) in
				self.user.setUserEmailDetailList(userEmailDetailList: userEmailDetailList)
				//Setup for second screen
				self.secondTab.user = self.user
                self.secondTab.projectName = self.projectName
				
				//Setup for third screen
				self.thirdTab.emailTeam = self.user.emailAddress
				self.thirdTab.projectName = self.projectName
			}
		}
	}
	
	func setupData(){
		firstTab = self.viewControllers![0] as? TeamMemberTVController
		secondTab = self.viewControllers![1] as? TeamSettingTVController
		thirdTab = self.viewControllers![2] as? SeperateVC
		forthTab = self.viewControllers![3] as? ChartVC
		
		firstTab.emailTeam = self.user.emailAddress
		
		DispatchQueue.main.async {
			self.firstTab.title = "Team"
			self.secondTab.title = "Order"
			self.thirdTab.tabBarItem.title = "Seperate"
			self.forthTab.title = "Chart"
			
			UITabBar.appearance().tintColor = colorOrange
		}
		
		let accountButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Account"), style: .plain, target: self, action: #selector(showActionSheet))
		accountButton.tintColor = colorBlack
		self.navigationItem.leftBarButtonItem = accountButton
	}
	
	@objc func showActionSheet() {
		let alert = UIAlertController(title: "", message: "Choose action", preferredStyle: .actionSheet)
		let titleFont = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18.0)!]
		let titleAttrString = NSMutableAttributedString(string: user.emailAddress, attributes: titleFont)

//		let messageFont = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 0)!]
//		let messageAttrString = NSMutableAttributedString(string: "a", attributes: messageFont)

		alert.setValue(titleAttrString, forKey: "attributedTitle")
//		alert.setValue(messageAttrString, forKey: "attributedMessage")

		let actionChangePassword = UIAlertAction(title: "Change password", style: .default) { (action) in
			self.performSegue(withIdentifier: "showChangePassword", sender: self)
		}
		let actionSignOut = UIAlertAction(title: "Sign out", style: .destructive) { (action) in
			let alert = create1ActionAlert(title: "Sign out", message: "Are you sure you want to sign out", actionTitle: "Yes", cancelTitle: "No", cancelCompletion: {
				
			}, actionCompletion: {
				let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
				defaults.set("", forKey: KEY_USER_EMAIL)
				defaults.set("", forKey: KEY_USER_PASSWORD)
				defaults.set("", forKey: KEY_USER_DEVICE_TOKEN)
				
				appDelegate.window?.rootViewController = loginVC
				appDelegate.window?.makeKeyAndVisible()
				self.present(loginVC, animated: true, completion: nil)
			})
			self.present(alert, animated: true, completion: nil)

		}
		let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(actionChangePassword)
		alert.addAction(actionSignOut)
		alert.addAction(actionCancel)
		self.present(alert, animated: true, completion: nil)
	}
    
    func resetEditingMode(){
        firstTab.setEditing(false, animated: false)
        secondTab.setEditing(false, animated: false)
    }
	
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title! {
//        case "Team Members":
//        case "Order Sample":
//        case "Seperate":
//        case "Chart":
        default:
            resetEditingMode()
        }
	}
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showChangePassword" {
			guard let changePasswordVC = segue.destination as? ChangePasswordVC else {return}
			changePasswordVC.emailAddress = self.user.emailAddress
		}
	}
}
