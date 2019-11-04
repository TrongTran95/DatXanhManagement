//
//  CallingDetailVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 11/1/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

enum CallingDetailType: Int {
	case NotPickUp = 0
	case Received = 1
}

class CallingDetailVC: UIViewController {
	
	var callingDetailList: [CallingDetail]!
	
	@IBOutlet weak var tvCallingDetailList: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CallingDetailVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return callingDetailList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CallingDetailTVC", for: indexPath) as! CallingDetailTVC
		let currentCallingDetail = callingDetailList[indexPath.row]
		cell.setData(date: currentCallingDetail.date, type: CallingDetailType(rawValue: currentCallingDetail.type)!)
		return cell
	}
	
	
}
