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
    var user: User!
	var projectName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
		setupData()
		
		Services.shared.getUserProjects(emailAddress: self.user.emailAddress) { (arrProject) in
			self.projectName = arrProject[0]["projectName"] as! String
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
		
		firstTab.emailTeam = self.user.emailAddress
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
}
