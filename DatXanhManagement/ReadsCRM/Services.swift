//
//  Services.swift
//  DatXanhManagement
//
//  Created by ivc on 8/19/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class Services {
    public static let shared = Services()
    
    private init(){}
	
	//Add user
	func addCallingDetail(idCustomer: Int, type: Int, completion: @escaping (Bool) -> Void) {
		let strParams = "idCustomer=" + "\(idCustomer)" + "&type=" + "\(type)"
		getJsonUsingPost(strURL: urlAddCallingDetail, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func getCallingDetailList(idCustomer: Int, completion: @escaping ([CallingDetail]) -> ()) {
		let strParams = "idCustomer=" + "\(idCustomer)"
		getJsonUsingPost(strURL: urlGetCallingDetailList, strParams: strParams) { (json) in
			let callingDetailJson = json["callingDetailList"] as! [[String:Any]]
			var callingDetailList:[CallingDetail] = []
			for callingDetail in callingDetailJson {
				let newCallingDetail = CallingDetail()
				newCallingDetail.setId(id: callingDetail["id"] as? Int ?? 0)
				newCallingDetail.setDate(date: callingDetail["date"] as? String ?? "")
				newCallingDetail.setType(type: callingDetail["type"] as? Int ?? 0)
				callingDetailList.append(newCallingDetail)
			}
			callingDetailList.sort(by: {$0.date > $1.date})
			completion(callingDetailList)
		}
	}
	
	func updateNote(idCustomer: Int, note: String, completion: @escaping (Bool) -> ()){
		let strParams = "idCustomer=" + "\(idCustomer)" + "&note=" + "\(note)"
		getJsonUsingPost(strURL: urlUpdateNote, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func updateRatingStar(idCustomer: Int, star: Int, completion: @escaping (Bool) -> ()){
		let strParams = "idCustomer=" + "\(idCustomer)" + "&star=" + "\(star)"
		getJsonUsingPost(strURL: urlUpdateRatingStar, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func getBriefInfoOfCustomer(idCustomer: Int, completion: @escaping (BriefCustomer) -> ()){
		let strParams = "idCustomer=" + "\(idCustomer)"
		getJsonUsingPost(strURL: urlGetBriefInfoOfCustomer, strParams: strParams) { (json) in
			let customerJson = json["customer"] as! [String:Any]
			let briefCustomer = BriefCustomer()
			briefCustomer.setLastName(lastName: customerJson["lastName"] as? String ?? "")
			briefCustomer.setFirstName(firstName: customerJson["firstName"] as? String ?? "")
			briefCustomer.setPhoneNumber(phoneNumber: customerJson["phoneNumber"] as? String ?? "")
			completion(briefCustomer)
		}
	}
	
	func updateIOSToken(emailAddress: String, completion: @escaping (Bool) -> ()){
		let strParams = "emailAddress=" + emailAddress
		getJsonUsingPost(strURL: urlUpdateIOSToken, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func changePassword(emailAddress: String, password: String, completion: @escaping (Bool) -> ()) {
		let strParams = "emailAddress=" + emailAddress + "&password=" + password
		getJsonUsingPost(strURL: urlChangePassword, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func checkPassword(emailAddress: String, password: String, completion: @escaping (Bool) -> ()) {
		let strParams = "emailAddress=" + emailAddress + "&password=" + password
		getJsonUsingPost(strURL: urlCheckPassword, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func removeAllUserEmailSeperateStillNotReceived(emailTeam: String, projectName: String, completion: @escaping (Bool) -> Void){
		let strParams = "emailTeam=" + emailTeam + "&projectName=" + projectName
		getJsonUsingPost(strURL: urlRemoveAllUserEmailSeperateStillNotReceived, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func getUserEmailSeperateListStillNotReceive(emailTeam: String, projectName: String, completion: @escaping ([UserEmailSeperate]) -> Void){
		let strParams = "emailTeam=" + emailTeam + "&projectName=" + projectName
		getJsonUsingPost(strURL: urlGetUserEmailSeperateListStillNotReceive, strParams: strParams) { (json) in
			let list = json["userEmailSeperateList"] as! [[String:Any]]
			var userEmailSeperateList: [UserEmailSeperate] = []
			for userEmailSeperate in list {
				let newUserEmailSeperate = UserEmailSeperate()
				newUserEmailSeperate.setEmailPersonal(emailPersonal: userEmailSeperate["emailPersonal"] as? String ?? "")
				newUserEmailSeperate.setOrderNumber(orderNumber: userEmailSeperate["orderNumber"] as? Int ?? 0)
				userEmailSeperateList.append(newUserEmailSeperate)
			}
			userEmailSeperateList.sort(by: {$0.orderNumber < $1.orderNumber})
			completion(userEmailSeperateList)
		}
	}
	
	func getUserEmailSeperateListReceived(emailTeam: String, projectName: String, completion: @escaping ([UserEmailSeperate]) -> Void){
		let strParams = "emailTeam=" + emailTeam + "&projectName=" + projectName
		getJsonUsingPost(strURL: urlGetUserEmailSeperateListReceived, strParams: strParams) { (json) in
			let list = json["userEmailSeperateList"] as! [[String:Any]]
			var userEmailSeperateList: [UserEmailSeperate] = []
			for userEmailSeperate in list {
				let newUserEmailSeperate = UserEmailSeperate()
				newUserEmailSeperate.setEmailPersonal(emailPersonal: userEmailSeperate["emailPersonal"] as? String ?? "")
				newUserEmailSeperate.setOrderNumber(orderNumber: userEmailSeperate["orderNumber"] as? Int ?? 0)
				newUserEmailSeperate.setReceivedDate(receivedDate: userEmailSeperate["receivedDate"] as? String ?? "")
				newUserEmailSeperate.setCustomerID(customerID: userEmailSeperate["customerID"] as? Int ?? 0)
				userEmailSeperateList.append(newUserEmailSeperate)
			}
			userEmailSeperateList.sort(by: {$0.receivedDate < $1.receivedDate})
			completion(userEmailSeperateList)
		}
	}
	
	func addUserEmailSeperate(emailTeam: String, userEmailDetailList: [UserEmailDetail], projectName: String, multiplier: Int, completion: @escaping () -> Void){
		let strParams = "emailTeam=" + emailTeam
		//Get max number first
		getJsonUsingPost(strURL: urlGetUserEmailSeperateMaxOrder, strParams: strParams) { (json) in
//			var maxOrder = 0
			var maxOrder = json["maxOrder"] as? Int ?? 0
//			if (strMaxOrder != 0) {
//				maxOrder = Int(strMaxOrder)!
//			}

			let dispatchGroup = DispatchGroup()
			//Loop times to add seperate list
			for _ in 0..<multiplier {
				//Add data to Database process --------
				for userEmailDetail in userEmailDetailList {
					//Add user base on receive quantity
					for _ in 0..<userEmailDetail.receiveQuantity{
						dispatchGroup.enter()
						//Increse order number
						maxOrder += 1
						//Add data
						let strParams = "emailTeam=" + emailTeam + "&emailPersonal=" + userEmailDetail.emailPersonal + "&projectName=" + projectName + "&orderNumber=\(maxOrder)"
						getJsonUsingPost(strURL: urlAddUserEmailSeperate, strParams: strParams) { (json) in
							print("aaaa")
							dispatchGroup.leave()
						}
					}
				}
				//Add data to Database process --------
			}
			
			dispatchGroup.notify(queue: .main) {
				print("bbbb")
				completion()
			}
		}
	}
	
	
	func getUserEmailDetailList(emailTeam: String, projectName: String, completion: @escaping ([UserEmailDetail]) -> Void){
		var userEmailDetailList: [UserEmailDetail] = []
		let strParams: String = "emailTeam=" + emailTeam + "&projectName=" +  projectName
		getJsonUsingPost(strURL: urlGetUserEmailDetailList, strParams: strParams) { (json) in
			let userJson = json["userEmailDetailList"] as! [[String:Any]]
			for userEmailDetail in userJson {
				let newUED = UserEmailDetail()
				newUED.setID(id: userEmailDetail["id"] as? Int ?? 0)
				newUED.setEmailPersonal(emailPersonal: userEmailDetail["emailPersonal"] as? String ?? "")
				newUED.setOrderNumber(orderNumber: userEmailDetail["orderNumber"] as? Int ?? 0)
				newUED.setReceiveQuantity(receiveQuantity: userEmailDetail["receiveQuantity"] as? Int ?? 0)
				userEmailDetailList.append(newUED)
			}
			//Sort user email detail list by order number
			userEmailDetailList = userEmailDetailList.sorted(by: { $0.orderNumber < $1.orderNumber })
			
			completion(userEmailDetailList)
		}
	}
	
	//Add user email detail (recursion)
    func addUserEmailDetail(count: Int, emailTeam: String, emailPersonal: [String], projectName: String, completion: @escaping (Bool) -> Void){
        let strParams = "emailTeam=" + emailTeam + "&emailPersonal=" + emailPersonal[count] + "&projectName=" + projectName
        getJsonUsingPost(strURL: urlAddUserEmailDetail, strParams: strParams) { (json) in
            if (count < emailPersonal.count - 1) {
                if !(json["error"] as! Bool) {
                    self.addUserEmailDetail(count: count + 1, emailTeam: emailTeam, emailPersonal: emailPersonal, projectName: projectName, completion: { (flag) in
                        completion(json["error"] as! Bool)
                    })
                } else {
                    completion(json["error"] as! Bool)
                    return
                }
            }
            else {
                completion(json["error"] as! Bool)
                return
            }
        }
    }
	
	
	
	//Add user
	func addUser(emailAddress: String, type: Int, password: String, firstName: String, lastName: String, completion: @escaping (Bool) -> Void) {
		let strParams = "emailAddress=" + emailAddress + "&type=" + "\(type)" + "&password=" + password + "&firstName=" + firstName + "&lastName=" + lastName
		getJsonUsingPost(strURL: urlAddUser, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func getUserProjects(emailAddress: String, completion: @escaping([[String:Any]]) -> Void){
		let strParams: String = "email=" + emailAddress
		getJsonUsingPost(strURL: urlGetUserProjects, strParams: strParams) { (json) in
			let projectJson = json["userProjects"] as! [[String:Any]]
			completion(projectJson)
		}
	}
    
    func addNewUserMember(emailTeam: String, emailPersonal: String, completion: @escaping (Bool) -> Void) {
        let strParams = "emailTeam=" + emailTeam + "&emailPersonal=" + emailPersonal
        getJsonUsingPost(strURL: urlAddUserMember, strParams: strParams) { (json) in
            completion(json["error"] as! Bool)
        }
    }
    
    func getUserMemberList(emailTeam: String, completion: @escaping ([[String:Any]]) -> Void){
        let strParams = "emailTeam=" + emailTeam
        getJsonUsingPost(strURL: urlGetUserMemberList, strParams: strParams) { (json) in
            completion(json["userMemberList"] as! [[String:Any]])
        }
    }
	
	func checkUserExist(emailTeam: String, emailPersonal: String, completion: @escaping (Bool) -> Void){
		let strParams = "emailTeam=" + emailTeam + "&emailPersonal=" + emailPersonal
		getJsonUsingPost(strURL: urlCheckUserExist, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func checkProjectExist(name: String, completion: @escaping (Bool) -> Void){
		let strParams = "name=" + name
		getJsonUsingPost(strURL: urlCheckProjectExist, strParams: strParams) { (json) in
			completion(json["exist"] as! Bool)
		}
	}
	
	func getUserType(emailAddress: String, completion: @escaping (Int) -> Void){
		let strParams = "emailAddress=" + emailAddress
		getJsonUsingPost(strURL: urlGetUserType, strParams: strParams) { (json) in
			completion(json["type"] as? Int ?? 0)
		}
	}
	
	func removeUserMember(id: Int, completion: @escaping (Bool) -> Void){
		let strParams = "id=" + "\(id)"
		getJsonUsingPost(strURL: urlRemoveUserMember, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func removeUserProject(email: String, emailTeam: String, completion: @escaping (Bool) -> Void){
		let strParams = "email=" + email + "&emailTeam=" + emailTeam
		getJsonUsingPost(strURL: urlRemoveUserProject, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func getAllUser(completion: @escaping ([User]) -> ()){
		getJsonUsingGet(strURL: urlGetAllUser) { (json) in
			let usersJson = json["users"] as! [[String:Any]]
			var users: [User] = []
			for user in usersJson {
				let newUser = User()
				newUser.setEmailAddress(emailAddress: user["emailAddress"] as? String ?? "")
				newUser.setType(type: user["type"] as? Int ?? 0)
				newUser.setLastName(lastName: user["lastName"] as? String ?? "")
				newUser.setFirstName(firstName: user["firstName"] as? String ?? "")
				users.append(newUser)
			}
			users = users.sorted(by: {$0.type > $1.type})
			completion(users)
		}
	}
	
	func checkAccountExist(emailAddress: String, completion: @escaping (Bool) -> ()) {
		let strParams = "emailAddress=" + emailAddress
		getJsonUsingPost(strURL: urlCheckAccountExist, strParams: strParams) { (json) in
			completion(json["exist"] as! Bool)
		}
	}
	
	func getAllProject(completion: @escaping ([Project]) -> ()) {
		getJsonUsingGet(strURL: urlGetAllProject) { (json) in
			let projectJson = json["projects"] as! [[String:Any]]
			var projects: [Project] = []
			for project in projectJson {
				let newProject = Project()
				newProject.setName(projectName: project["name"] as? String ?? "")
				projects.append(newProject)
			}
			projects = projects.sorted(by: {$0.name < $1.name})
			completion(projects)
		}
	}
	
	func addUserProject(email: String, projectName: String, emailTeam: String, completion: @escaping(Bool) -> Void){
		let strParams:String = "email=" + email + "&projectName=" + projectName + "&emailTeam=" + emailTeam
		getJsonUsingPost(strURL: urlAddUserProject, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
	
	func addProject(name: String, completion: @escaping(Bool) -> Void){
		let strParams:String = "name=" + name
		getJsonUsingPost(strURL: urlAddProject, strParams: strParams) { (json) in
			completion(json["error"] as! Bool)
		}
	}
}
