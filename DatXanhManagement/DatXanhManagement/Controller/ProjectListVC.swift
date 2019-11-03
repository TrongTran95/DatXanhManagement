//
//  ProjectListVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 10/27/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit
import Toaster

class ProjectListVC: UIViewController {

	@IBOutlet weak var btnAddProject: UIButton!
	
	@IBOutlet weak var tvProjectList: UITableView!
	var projects: [Project] = []
	
	@IBAction func actAddProject(_ sender: Any) {
		let alert = UIAlertController(title: "Add new Project", message: "", preferredStyle: .alert)
		
		alert.addTextField(configurationHandler: configurationTextField(textField:))
		let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
			let textField = alert.textFields![0]
			//Check empty text field
			if textField.text == "" {
				self.present(createCancelAlert(title: "Found blank", message: "Please input project name", cancelTitle: "Cancel"), animated: true, completion: nil)
				return
			}
			
			let newProjectName: String = textField.text!

			//Check if project existing in database, if not then add new project
			self.checkAndAddProject(newProjectName)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(addAction)
		alert.addAction(cancelAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func checkAndAddProject(_ newProjectName: String){
		self.checkProject(newProjectName) {
			self.addProject(newProjectName) {
				//Update UI
				DispatchQueue.main.async {
					//Add new member to user array
					let newProject = Project()
					newProject.setName(projectName: newProjectName)
					self.projects.append(newProject)
					//Reload UI
					self.tvProjectList.reloadData()
					//Show annoucement
					Toast(text: "Successed", duration: Delay.short).show()
				}
			}
		}
	}
	
	func checkProject(_ newProjectName: String, completionHandler: @escaping () -> ()) {
		Services.shared.checkProjectExist(name: newProjectName) { (exist) in
			if (exist) {
				self.present(createCancelAlert(title: "This project is avaiable", message: "", cancelTitle: "Cancel"), animated: true, completion: nil)
				return
			}
			completionHandler()
		}
	}
	
	func addProject(_ newProjectName: String, completionHandler: @escaping () -> ()) {
		Services.shared.addProject(name: newProjectName, completion: { (error) in
			if (error) {
				self.present(createCancelAlert(title: "Can't add project", message: "Something happened", cancelTitle: "Cancel"), animated: true, completion: nil)
				return
			}
			completionHandler()
		})
	}

	
	func configurationTextField(textField: UITextField) {
		textField.placeholder = "Please input new project name"
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		btnAddProject.layer.cornerRadius = btnAddProject.frame.size.width/2
		setupData()
    }
	
	func setupData(){
		Services.shared.getAllProject { (projects) in
			self.projects = projects
			DispatchQueue.main.async {
				self.tvProjectList.reloadData()
			}
		}
	}

}

extension ProjectListVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return projects.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectListTVC", for: indexPath) as! ProjectListTVC
		cell.setData(orderNumber: indexPath.row + 1, projectName: projects[indexPath.row].name)
		return cell
	}
	
	
}
