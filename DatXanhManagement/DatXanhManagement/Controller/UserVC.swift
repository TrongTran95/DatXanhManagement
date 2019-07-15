//
//  UserVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class UserVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	

	@IBOutlet weak var lblWelcome: UILabel!
	
	@IBOutlet weak var lblCurrentProject: UILabel!
	
	@IBOutlet weak var cvProjects: UICollectionView!
	
	var user = User()
	var projects = [Project]()
	var customers = [Project]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//Hide back button
//		self.navigationItem.setHidesBackButton(true, animated:true);
		cvProjects.delegate = self
		cvProjects.dataSource = self
		//Setup project information
		getProject()
		//Setup customer information
    }
	
	override func viewDidAppear(_ animated: Bool) {
	}
	
	//Get project list of user
	func getProject(){
		user.getProject { (projectCodes) in
			for i in 0..<projectCodes.count{
				//Add a new null project
				self.projects.append(Project())
				//Set project code
				self.projects[i].setProjectCode(projectCode: projectCodes[i])
				//Get project's customer quantity
				self.projects[i].getCustomerQuantityOfProject()
				//Get and set project name
				self.projects[i].getProjectInfo(completion: {
					DispatchQueue.main.async {
						//Only reload after got all project
						if (i == projectCodes.count - 1) {
							self.cvProjects.reloadData()
							self.lblWelcome.text = "\(self.user.firstName) \(self.user.lastName)"
							self.lblCurrentProject.text = "Your current project(s): \(self.projects.count)"
						}
					}
				})
			}
		}
	}
	
	func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
	}
	
	func downloadImage(from url: URL, completion: @escaping(Data) -> Void) {
		print("Download Started")
		getData(from: url) { data, response, error in
			guard let data = data, error == nil else { return }
			print(response?.suggestedFilename ?? url.lastPathComponent)
			print("Download Finished")
			DispatchQueue.main.async() {
				completion(data)
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return projects.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProjectCVC
		let currentRow: Int = indexPath.row
		if (projects[currentRow].projectThumbnail != "") {
			//Download and upload image
			let imgURL:URL = URL(string: projects[currentRow].projectThumbnail)!
			downloadImage(from: imgURL) { (data) in
				//Show image after download from server
				cell.imgProjectThumbnail.image = UIImage(data: data)
				//Stop activity indicator
				cell.aiLoadingImage.stopAnimating()
			}
			//Change project name
			cell.projectName.text = projects[currentRow].projectName
			//Change customer quantity
			cell.numberOfCustomer.text = "Số lượng khách hàng \(projects[currentRow].customerQuantity)"
		}
		//Start activity indicator
		cell.aiLoadingImage.startAnimating()
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//Get customer list before segue to customer list screen
		projects[indexPath.row].getCustomerListBaseOnProjectCode {
			
			//Test customer
			let cc = self.projects[indexPath.row].customerList[0]
			print("\(cc.customerStatusID) - \(cc.dateContact) - \(cc.dayOfBirth) - \(cc.email) - \(cc.fbAccount) - \(cc.firstName) - \(cc.gender) - \(cc.idCustomer) - \(cc.lastName) - \(cc.message) - \(cc.phoneNumber) - \(cc.projectCode)")
		}
	}
	

}
