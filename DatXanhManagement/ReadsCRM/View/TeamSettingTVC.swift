//
//  TeamSettingTVC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/13/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class TeamSettingTVC: UITableViewCell {
	var delegate:TeamSettingTVController!
    
    @IBOutlet weak var stReceiveNumber: UIStepper!
    
    @IBOutlet weak var lblReceiveNumber: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgOrder: UIImageView!
    
    @IBOutlet weak var lblOrder: UILabel!
    
    @IBAction func ReceiveNumberChange(_ sender: UIStepper) {
		//Update UI
		lblReceiveNumber.text = "\(Int(sender.value).description) lượt"
		//Update data
		delegate.user.userEmailDetailList[sender.tag].setReceiveQuantity(receiveQuantity: Int(sender.value))
		//Turn on changes flag
		if (!delegate.flagChangeReceiveQuantity) {
			delegate.flagChangeReceiveQuantity = true
		}
    }
    
    func setStepperEnable(value: Bool){
        stReceiveNumber.isEnabled = value
    }
	
	func setStepperTag(tag: Int){
		stReceiveNumber.tag = tag
	}
    
    func setUserPersonalEmail(emailAddress: String){
        lblName.text = emailAddress
    }
    
    func setReceiveNumber(receiveNumber: Int){
        lblReceiveNumber.text = "\(receiveNumber) lượt"
    }
    
    func setOrder(orderNumber: Int){
        lblOrder.text = "\(orderNumber)"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
		setupStepper()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(){
        imgOrder.layer.cornerRadius = 10
    }
	
	func setupStepper(){
		//wraps: Stepping beyond maximum value will return to minimumvalue
		//autorepeat: user pressing and holding on the stepper repeatedly alters value
		stReceiveNumber.wraps = true
		stReceiveNumber.autorepeat = true
		stReceiveNumber.minimumValue = 1
//        stReceiveNumber.isEnabled = false
	}
    
    func setupStepperData(currentValue: Int, maximumValue: Int){
        stReceiveNumber.maximumValue = Double(maximumValue)
        stReceiveNumber.value = Double(currentValue)
    }

}
