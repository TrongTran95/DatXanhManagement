//
//  UserVC.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
	
	@IBOutlet weak var tbProjects: UITableView!
	
	
	var user = User()
	var projects = [Project]()
	var customers = [Project]()
	var chosenProjectIndex = 0
	var customerDic = [String:[Customer]]()
	
	var checkIfProjectAreSelectedBefore: Bool = false
	
	//Information for push notification
	var emailTeam = ""
	var emailPersonal = ""
	var customerId = 0
	var pushIndex = 0
	
	var loadingView: UIView!
	
	@IBOutlet weak var lblEmail: UILabel!
	
	@IBOutlet weak var userDetailView: UIView!
	
	@IBAction func ActionClickedButton(_ sender: UIButton) {
		switch sender.currentTitle {
		case "Change password":
			self.performSegue(withIdentifier: "showChangePassword", sender: self)
		case "Sign out":
			let alert = create1ActionAlert(title: "Sign out", message: "You won't receive new customer notification after signed out", actionTitle: "Yes", cancelTitle: "No", cancelCompletion: {
				
			}, actionCompletion: {
				//Remove iOS token
				Services.shared.updateIOSToken(emailAddress: self.user.emailAddress, completion: { (error) in
					if (error) {
						self.present(createCancelAlert(title: "Can't sign out", message: "Something wrong happend", cancelTitle: "Cancel"), animated: true, completion: nil)
						return
					}
					DispatchQueue.main.async {
						let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
						defaults.set("", forKey: KEY_USER_EMAIL)
						defaults.set("", forKey: KEY_USER_PASSWORD)
						defaults.set("", forKey: KEY_USER_DEVICE_TOKEN)
						
						appDelegate.window?.rootViewController = loginVC
						appDelegate.window?.makeKeyAndVisible()
						self.present(loginVC, animated: true, completion: nil)
					}
				})
			})
			self.present(alert, animated: true, completion: nil)
		default:
			UIView.animate(withDuration: 0.3) {
				self.userDetailView.alpha = 0
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//Hide back button
//		self.navigationItem.setHidesBackButton(true, animated:true);
		
		//Set up table view
		tbProjects.delegate = self
		tbProjects.dataSource = self
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.viewControllers = [self]
		appDelegate.window!.rootViewController = self.navigationController
		//Setup project information
		getUserProjects()
		setupUI()
	}
	
	@objc func accountButtonClicked(){
		if (userDetailView.alpha == 0) {
			UIView.animate(withDuration: 0.3) {
				self.userDetailView.alpha = 1
			}
		} else {
			UIView.animate(withDuration: 0.3) {
				self.userDetailView.alpha = 0
			}
		}
	}
	
	func setupUI(){
		let accountButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Account"), style: .plain, target: self, action: #selector(accountButtonClicked))
		self.navigationItem.leftBarButtonItems = [accountButton]
		
		lblEmail.adjustsFontSizeToFitWidth = true
		lblEmail.text = user.emailAddress
	}
	
	func setupLoadingView(){
		loadingView = createLoadingView()
		if (self.projects.count != 0){
			loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
		}
		self.view.addSubview(loadingView)
		let constraints = AutoLayout.shared.getTopLeftBottomRightConstraint(currentView: loadingView, destinationView: self.view, constant: [0,0,0,0])
		self.view.addConstraints(constraints)
	}
	
	//Get project list of user
	func getUserProjects(){
		setupLoadingView()
		projects = []
		//Chua có user email address
		Services.shared.getUserProjects(emailAddress: user.emailAddress) { (userProjects) in
			if (userProjects.count == 0) {
				DispatchQueue.main.async {
					self.loadingView.removeFromSuperview()
				}
				return
			}
			for i in 0..<userProjects.count{
				//Add a new null project
				self.projects.append(Project())
				//Set project info
				let currentProject = userProjects[i]
				self.projects[i].setName(projectName: currentProject["projectName"] as! String)
				let currentEmailTeam = currentProject["emailTeam"] as! String
				self.projects[i].setEmailTeam(emailTeam: currentEmailTeam)
				if (self.emailTeam == currentEmailTeam) {
					self.pushIndex = i
				}
				//Get project's customer quantity
				self.projects[i].getCustomerQuantity(url: urlGetCustomerQuantity, emailPersonal: self.user.emailAddress, emailTeam: self.projects[i].emailTeam, completion: {
					//Get quantity of customer that still not contact yet
					self.projects[i].getCustomerQuantity(url: urlGetCustomerStillNotContactQuantity, emailPersonal: self.user.emailAddress, emailTeam: self.projects[i].emailTeam, completion: {
						//Get project info and set project name
						self.projects[i].getProjectInfo(completion: {
							DispatchQueue.main.async {
								//Only reload after got all project
								if (i == userProjects.count - 1) {
									self.projects.sort(by: { $0.name < $1.name })
									self.tbProjects.reloadData()
									self.loadingView.removeFromSuperview()
									if (defaults.object(forKey: KEY_ISPUSH) as? Bool) == true {
										self.selectProject(At: self.pushIndex)
									}
								}
							}
						})
					})
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
	
	func selectProject(At index: Int){
		setupLoadingView()
		//Check and Reset customer list before get a new one
		projects[index].checkAndResetCustomerList()
		
		//Save the choosen index
		self.chosenProjectIndex = index
		
		//Get customer list before segue to customer list screen
		projects[index].getCustomerList(emailTeam: projects[index].emailTeam, emailAddress: user.emailAddress) {
			let currentProject = self.projects[index]
			if (currentProject.customerListSeperated[KEY_STILL_NOT]!.count == 0 && currentProject.customerListSeperated[KEY_ALREADY]!.count == 0) {
				DispatchQueue.main.async {
					self.loadingView.removeFromSuperview()
				}
				return
			}
			DispatchQueue.main.async {
				//Go to customer list page
				self.performSegue(withIdentifier: "showCustomerListPage", sender: self)
				self.loadingView.removeFromSuperview()
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//destination is customer list page
		if segue.identifier == "showCustomerListPage" {
			guard let customerListVC = segue.destination as? CustomerListVC else {return}
			//Assign project
			customerListVC.project = self.projects[chosenProjectIndex]
			customerListVC.emailPersonal = self.user.emailAddress
			if (defaults.object(forKey: KEY_ISPUSH) as? Bool) == true {
				customerListVC.pushCustomerId = self.customerId
			}
		} else if segue.identifier == "showChangePassword" {
			guard let changePasswordVC = segue.destination as? ChangePasswordVC else {return}
			changePasswordVC.emailAddress = self.user.emailAddress
		}
	}
}

extension UserVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return projects.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "projectTVC", for: indexPath) as! ProjectTVC
		
		let currentRow: Int = indexPath.row
//		if (projects[currentRow].thumbnail != "") {
			//Download and upload image
//			print(projects[currentRow].thumbnail)
		
//			let imgURL:URL = URL(string: projects[currentRow].thumbnail)!
//			downloadImage(from: imgURL) { (data) in
//				DispatchQueue.main.async {
//
//					//Show image after download from server
//					cell.imgProjectThumbnail.image = UIImage(data: data)
//					//Stop activity indicator
////					cell.aiLoadingImage.stopAnimating()
//				}
//			}
			
			//Change project name
		cell.projectName.text = projects[currentRow].name
		
		cell.lblSupervisor.text = projects[currentRow].emailTeam
		//Change customer quantity
		let total = projects[currentRow].customerQuantity
		let stillNot = projects[currentRow].customerStillNotContactQuantity
		cell.numberOfCustomer.text = "\(total - stillNot)/\(total)"
		//Change customer quantity
		//			cell.numberOfCustomerNeedContact.text = "Chưa liên lạc: \(projects[currentRow].customerStillNotContactQuantity)"
		//		}
		//		Start activity indicator
		//		cell.aiLoadingImage.startAnimating()
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectProject(At: indexPath.row)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
}
