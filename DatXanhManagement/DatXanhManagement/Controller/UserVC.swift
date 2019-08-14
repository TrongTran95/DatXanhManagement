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
	var chosenProjectIndex = 0
	var customerDic = [String:[Customer]]()
	
	var checkIfProjectAreSelectedBefore: Bool = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//Hide back button
//		self.navigationItem.setHidesBackButton(true, animated:true);
		
		//Set up collection view
		cvProjects.delegate = self
		cvProjects.dataSource = self
		
		//Setup project information
		getUserProjects()
    }
	
	//Get project list of user
	func getUserProjects(){
		user.getUserProjects { (projectNames) in
			for i in 0..<projectNames.count{
				//Add a new null project
				self.projects.append(Project())
				//Set project code
				self.projects[i].setName(projectName: projectNames[i])
				//Get project's customer quantity
				self.projects[i].getCustomerQuantity(url: urlGetCustomerQuantity, emailTeam: self.user.emailAddress, completion: {
					//Get quantity of customer that still not contact yet
					self.projects[i].getCustomerQuantity(url: urlGetCustomerStillNotContactQuantity, emailTeam: self.user.emailAddress, completion: {
						//Get project info and set project name
						self.projects[i].getProjectInfo(completion: {
							DispatchQueue.main.async {
								//Only reload after got all project
								if (i == projectNames.count - 1) {
									self.cvProjects.reloadData()
									self.lblWelcome.text = "\(self.user.firstName) \(self.user.lastName)"
									self.lblCurrentProject.text = "Your current project(s): \(self.projects.count)"
								}
							}
						})
					})
				})
				/*
				//Get quantity of customer that still not contact yet
				self.projects[i].getCustomerStillNotContactQuantity(emailTeam: self.user.emailTeam)
				//Get and set project name
				self.projects[i].getProjectInfo(completion: {
				DispatchQueue.main.async {
				//Only reload after got all project
				if (i == projectNames.count - 1) {
				self.cvProjects.reloadData()
				self.lblWelcome.text = "\(self.user.firstName) \(self.user.lastName)"
				self.lblCurrentProject.text = "Your current project(s): \(self.projects.count)"
				}
				}
				})
				*/
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
//			DispatchQueue.main.async() {
				completion(data)
//			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return projects.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProjectCVC
		let currentRow: Int = indexPath.row
		if (projects[currentRow].thumbnail != "") {
			//Download and upload image
			print(projects[currentRow].thumbnail)
			let imgURL:URL = URL(string: projects[currentRow].thumbnail)!
			downloadImage(from: imgURL) { (data) in
				DispatchQueue.main.async {
					
					//Show image after download from server
					cell.imgProjectThumbnail.image = UIImage(data: data)
					//Stop activity indicator
					cell.aiLoadingImage.stopAnimating()
				}
			}
			//Change project name
			cell.projectName.text = projects[currentRow].name
			//Change customer quantity
			cell.numberOfCustomer.text = "Số lượng khách hàng: \(projects[currentRow].customerQuantity)"
			//Change customer quantity
			cell.numberOfCustomerNeedContact.text = "Chưa liên lạc: \(projects[currentRow].customerStillNotContactQuantity)"
		}
		//Start activity indicator
		cell.aiLoadingImage.startAnimating()
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//Check and Reset customer list before get a new one
		projects[indexPath.row].checkAndResetCustomerList()
		
		//Save the choosen index
		self.chosenProjectIndex = indexPath.row
		
		//Get customer list before segue to customer list screen
		projects[indexPath.row].getCustomerList(emailAddress: user.emailAddress) {
			DispatchQueue.main.async {
				/*Test customer's all information
				let cc = self.projects[indexPath.row].customerList[1]
				print("\(cc.customerStatusID) - \(cc.dateContact) - \(cc.dayOfBirth) - \(cc.email) - \(cc.fbAccount) - \(cc.firstName) - \(cc.gender) - \(cc.idCustomer) - \(cc.lastName) - \(cc.message) - \(cc.phoneNumber) - \(cc.projectCode) - \(cc.callStatus) - \(cc.callSuccessTimes) - \(cc.callSuccessMinutes)")
				*/
				
				//Go to customer list page
                //self.performSegue(withIdentifier: "showCustomerListPage", sender: self)
			}
		}
        
        self.performSegue(withIdentifier: "showTeamSettingPage", sender: self)
        
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//destination is customer list page
		if segue.identifier == "showCustomerListPage" {
			guard let customerListVC = segue.destination as? CustomerListVC else {return}
			//Assign project
			customerListVC.project = self.projects[chosenProjectIndex]
			customerListVC.userTeamEmail = self.user.emailAddress
		} else if segue.identifier == "showTeamSettingPage" {
            guard let teamSettingTVC = segue.destination as? TeamSettingTVController else {return}
            teamSettingTVC.user = self.user
        }
	}
}
