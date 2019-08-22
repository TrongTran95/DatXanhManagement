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
    var user: User!
	var projectName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
		firstTab = self.viewControllers![0] as? TeamMemberTVController
		secondTab = self.viewControllers![1] as? TeamSettingTVController
		
        firstTab.emailTeam = self.user.emailAddress
		
		Services.shared.getUserProjects(emailTeam: self.user.emailAddress) { (arrProject) in
			self.projectName = arrProject[0]
			Services.shared.getUserEmailDetailList(emailTeam: self.user.emailAddress, projectName: self.projectName) { (userEmailDetailList) in
				self.user.setUserEmailDetailList(userEmailDetailList: userEmailDetailList)
				self.secondTab.user = self.user
                self.secondTab.projectName = self.projectName
			}
		}
    }
	
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        switch item.title! {
//        case "Team Members":
//        case "Order Sample":
//        case "Seperate":
//        case "Chart":
//        default:
//        }
        print(item.title!)
	}
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		
	}
}
