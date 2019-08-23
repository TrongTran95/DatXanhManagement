//
//  SeperateVC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/23/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class SeperateVC: UIViewController {
    
    @IBOutlet weak var leftConstraintOfMovingView: NSLayoutConstraint!
    
    @IBOutlet weak var btnOld: UIButton!
    
    @IBOutlet weak var btnNew: UIButton!
    
    @IBOutlet weak var tvOldSeperated: UITableView!
    
    @IBOutlet weak var tvNewSeperate: UITableView!
    
    @IBOutlet weak var rightConstraintOfOldSeperatedTableView: NSLayoutConstraint!
    @IBAction func tappedButtonOldOrNew(_ sender: UIButton) {
        let currentTitle = sender.currentTitle!
        setOldNewButtonAttribute(title: currentTitle)
        setOldNewTableViewAttribute(title: currentTitle)
    }
    
    func setOldNewTableViewAttribute(title: String){
        UIView.animate(withDuration: 0.2) {
            switch title {
            case "New":
                self.rightConstraintOfOldSeperatedTableView.constant = 0
            default: //"New"
                self.rightConstraintOfOldSeperatedTableView.constant = -self.tvOldSeperated.frame.size.width
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func setOldNewButtonAttribute(title: String){
        UIView.animate(withDuration: 0.2, animations: {
            switch title {
            case "Old":
                self.leftConstraintOfMovingView.constant = 0
            default: //"New"
                self.leftConstraintOfMovingView.constant = self.btnOld.frame.size.width
            }
            self.view.layoutIfNeeded()
        }, completion: { (complete) in
            switch title {
            case "Old":
                self.btnOld.setTitleColor(UIColor.white, for: .normal)
                self.btnNew.setTitleColor(UIColor.black, for: .normal)
            default: //"New"
                self.btnOld.setTitleColor(UIColor.black, for: .normal)
                self.btnNew.setTitleColor(UIColor.white, for: .normal)
            }
        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
