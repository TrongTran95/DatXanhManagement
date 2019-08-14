//
//  TeamSettingTVC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/13/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class TeamSettingTVC: UITableViewCell {
    
    @IBOutlet weak var stReceiveNumber: UIStepper!
    
    @IBOutlet weak var lblReceiveNumber: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgOrder: UIImageView!
    

    @IBAction func ReceiveNumberChange(_ sender: UIStepper) {
        lblReceiveNumber.text = "Còn \(Int(sender.value).description) lượt"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupStepper(maximumValue: Int){
        //wraps: Stepping beyond maximum value will return to minimumvalue
        //autorepeat: user pressing and holding on the stepper repeatedly alters value
        stReceiveNumber.wraps = true
        stReceiveNumber.autorepeat = true
        stReceiveNumber.minimumValue = 1
        stReceiveNumber.maximumValue = Double(maximumValue)
    }

}
