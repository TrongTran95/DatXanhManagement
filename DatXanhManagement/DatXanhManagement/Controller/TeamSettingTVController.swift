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
    var tempUEDList: [UserEmailDetail] = []
    
    var flagChangeOrder: Bool = false
    var flagRemove: Bool = false
    var flagChangeReceiveQuantity: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.setEditing(true, animated: true)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func abc(){
        print("a")
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // Toggles the actual editing actions appearing on a table view
        self.tableView.setEditing(editing, animated: true)
        if (self.isEditing) {
            //Begin editing, save current data in case of any changes happen
//            self.tempUEDList = self.user.userEmailDetailList
            self.tempUEDList = copyUEDLFrom(currentUEDL: self.user.userEmailDetailList)
        } else {
            //Done button, save new data (if avaiable)
            if (flagRemove || flagChangeOrder || flagChangeReceiveQuantity) {
                showAlert()
                flagRemove = false
                flagChangeReceiveQuantity = false
                flagChangeOrder = false
            } else {
                
            }
        }
    }
    
    func copyUEDLFrom(currentUEDL: [UserEmailDetail]) -> [UserEmailDetail]{
        var newUEDL:[UserEmailDetail] = []
        for i in 0..<currentUEDL.count {
            newUEDL.append(UserEmailDetail())
            newUEDL[i].setOrderNumber(orderNumber: currentUEDL[i].orderNumber)
        }
        return newUEDL
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Data changed", message: "Do you want to save new data ?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print(self.tempUEDList[0].orderNumber)
            self.user.setUserEmailDetailList(newUEDL: self.tempUEDList)
            self.tableView.reloadData()
            self.tempUEDList = []
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.userEmailDetailList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamSettingTVC
        let currentUED = self.user.userEmailDetailList[indexPath.row]
        cell.setOrder(orderNumber: currentUED.orderNumber)
        cell.setReceiveNumber(receiveNumber: currentUED.receiveQuantity)
        cell.setUserPersonalEmail(emailAddress: currentUED.emailPersonal)
        cell.setupStepper(currentValue: currentUED.receiveQuantity, maximumValue: 10)
        return cell
    }
    
    //Height of table view cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // Allow move rows
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Handle for move rows (after stop holding row)
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //Get current and destination row index
        var currentRow = sourceIndexPath.row
        var destinationRow = destinationIndexPath.row
        
        //Change position in user email detai list
        //Save a temporary user email detail
        let userToMove = self.user.userEmailDetailList[currentRow]
        //Remove original UED at original row
        self.user.removeUserEmailDetail(at: currentRow)
        //Insert temporary UED to destination row
        self.user.insertUserEmailDetail(userToMove, at: destinationRow)
        
        //Change order of UED from current row to destination row
        //Check if move from large position to small position for handler below
        if currentRow > destinationRow {
            let temp = currentRow
            currentRow = destinationRow
            destinationRow = temp
        }
        //Set order number of user email detail
        for i in currentRow...destinationRow {
            self.user.userEmailDetailList[i].setOrderNumber(orderNumber: i+1)
        }
        
        //Upload layout
        self.tableView.reloadData()
        
        //Update flag to know that rows has been changed
        flagChangeOrder = true
    }

}
