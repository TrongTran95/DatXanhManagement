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
    
    @IBOutlet weak var lblOrder: UILabel!
    
    @IBAction func ReceiveNumberChange(_ sender: UIStepper) {
        lblReceiveNumber.text = "Còn \(Int(sender.value).description) lượt"
    }
    
    func setUserPersonalEmail(emailAddress: String){
        lblName.text = emailAddress
    }
    
    func setReceiveNumber(receiveNumber: Int){
        lblReceiveNumber.text = "Còn: \(receiveNumber) lượt"
    }
    
    func setOrder(orderNumber: Int){
        lblOrder.text = "\(orderNumber)"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(){
        imgOrder.layer.cornerRadius = 10
    }
    
    func setupStepper(currentValue: Int, maximumValue: Int){
        //wraps: Stepping beyond maximum value will return to minimumvalue
        //autorepeat: user pressing and holding on the stepper repeatedly alters value
        stReceiveNumber.wraps = true
        stReceiveNumber.autorepeat = true
        stReceiveNumber.minimumValue = 1
        stReceiveNumber.maximumValue = Double(maximumValue)
        stReceiveNumber.value = Double(currentValue)
    }

}
