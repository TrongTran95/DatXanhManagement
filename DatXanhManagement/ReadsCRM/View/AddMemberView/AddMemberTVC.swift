//
//  AddMemberTVC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/22/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class AddMemberTVC: UITableViewCell {
    var delegate: AddMemberView!
    
    @IBOutlet weak var lblEmailAddress: UILabel!
    
    @IBOutlet weak var switchAdd: UISwitch!
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        delegate.dicSwitchValue[sender.tag] = sender.isOn
    }
    
    func setData(emailAddress: String){
        lblEmailAddress.text = emailAddress
    }
    
    func setSwitchStatus(status: Bool) {
        switchAdd.isOn = status
    }
    
    func setSwitchTag(tag: Int) {
        switchAdd.tag = tag
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblEmailAddress.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
