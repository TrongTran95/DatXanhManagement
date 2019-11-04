//
//  AddMemberView.swift
//  DatXanhManagement
//
//  Created by ivc on 8/22/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class AddMemberView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var tvUserMemberList: UITableView!
    
    var userMembers: [UserMember]!
    
    var dicSwitchValue: [Int:Bool] = [:]
    
    var delegate: TeamSettingTVController!
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate.turnOffAddView()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate.addNewUserEmailDetail()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setupTableView(){
        tvUserMemberList.delegate = self
        tvUserMemberList.dataSource = self
        tvUserMemberList.register(UINib(nibName: "AddMemberTVC", bundle: nil), forCellReuseIdentifier: "AddMemberCell")
    }
    
    func setupRegistNib(){
        Bundle.main.loadNibNamed("AddMemberView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setup(){
        setupRegistNib()
        setupTableView()
        setupUI()
    }
    
    func setupUI(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension AddMemberView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMemberCell", for: indexPath) as! AddMemberTVC
        cell.delegate = self
        cell.setData(emailAddress: userMembers[indexPath.row].emailPersonal)
        cell.setSwitchTag(tag: indexPath.row)
        if (dicSwitchValue[indexPath.row] == nil) {
            dicSwitchValue[indexPath.row] = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (dicSwitchValue[indexPath.row] != nil) {
            (cell as! AddMemberTVC).setSwitchStatus(status: dicSwitchValue[indexPath.row]!)
        }
    }
    
    
}
