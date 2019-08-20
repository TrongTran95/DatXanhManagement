//
//  TeamTBC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/19/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class TeamTBC: UITabBarController {
    
    var emailTeam: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let firstTab = self.viewControllers![0] as! TeamMemberTVController
        firstTab.emailTeam = self.emailTeam
    }
}
