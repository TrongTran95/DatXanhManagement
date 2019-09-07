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
	
	var addView: AddSeperateView!
	
	var emailTeam: String!
	var projectName: String!
	
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
            default: //"Old"
                self.rightConstraintOfOldSeperatedTableView.constant = -self.tvOldSeperated.frame.size.width
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func setOldNewButtonAttribute(title: String){
        UIView.animate(withDuration: 0.2, animations: {
            switch title {
            case "New":
				self.leftConstraintOfMovingView.constant = 0
            default: //"Old"
				self.leftConstraintOfMovingView.constant = self.btnOld.frame.size.width
            }
            self.view.layoutIfNeeded()
        }, completion: { (complete) in
            switch title {
            case "New":
				self.btnOld.setTitleColor(UIColor.black, for: .normal)
				self.btnNew.setTitleColor(UIColor.white, for: .normal)
            default: //"Old"
				self.btnOld.setTitleColor(UIColor.white, for: .normal)
				self.btnNew.setTitleColor(UIColor.black, for: .normal)
            }
        })
        
        
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setupUI()
	}
	
	func setupUI(){
		self.tabBarController?.navigationItem.title = "Seperate"
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showSeperateView))
		self.tabBarController?.navigationItem.rightBarButtonItems = [addButton]
	}
	
	@objc func showSeperateView(){
		//Get user email detail list
		Services.shared.getUserEmailDetailList(emailTeam: emailTeam, projectName: projectName) { (list) in
			DispatchQueue.main.async {
				self.setupAddSeperateView(transfer:list)
			}
		}
	}
	
	func setupAddSeperateView(transfer userEmailDetailList: [UserEmailDetail]){
		addView = AddSeperateView()
		addView!.userEmailDetailList = userEmailDetailList
//		addView?.delegate = self
		let height = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
		
		self.navigationController!.view.insertSubview(addView!, belowSubview: self.navigationController!.navigationBar)
		self.navigationController!.view.addConstraints(AutoLayout.shared.getTopLeftBottomRightConstraint(currentView: addView!, destinationView: self.navigationController!.view, constant: [height, 0, 0, 0]))
	}

}
