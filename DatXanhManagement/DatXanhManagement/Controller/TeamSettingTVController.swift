//
//  TeamSettingTVC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/13/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class TeamSettingTVController: UITableViewController {
    
    
    var user:User!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.setEditing(true, animated: true)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.userEmailDetailList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamSettingTVC


        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

    }

}
