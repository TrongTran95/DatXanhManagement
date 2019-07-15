//
//  LoginViewController.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/14/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	let urlLogin: String = "http://trongstest.tk/DatXanhManagement/api/CheckLogin.php"
	
	@IBOutlet weak var txtUsername: UITextField!
	
	@IBOutlet weak var txtPassword: UITextField!
	
	@IBAction func clickedLoginToUsersPage(_ sender: Any) {
		let userName: String = txtUsername.text!
		let password: String = txtPassword.text!
		//Check if the username or password is nil
		if (userName != "" && password != "") {
			//Start the login process
			login(userName: userName, password: password)
		}else {
			//username or password is nil
		}
	}
	
	func login(userName: String, password: String){
		//Create an url
		let url = URL(string: urlLogin)
		//Create a request to server
		var request = URLRequest(url: url!)
		//Create a post parameters to send to server
		let postParams:String = "emailAddressPersonal=" + userName + "&password=" + password
		//Set requests datas
		request.httpMethod = "POST"
		request.httpBody = postParams.data(using: String.Encoding.utf8)
		//Create a task to send the post request
		let session = URLSession.shared
		session.dataTask(with: request) { (data, res, error) in
			//If error, print error message and stop app
			if (error != nil){
				print ("error is: \(String(describing: error))")
				return;
			}
			
			/*
			//Print the data get from server (also get an detail error)
			if let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
			print(dataString)
			}
			*/
			
			//parsing the response
			do {
				//Get the json from server
				let userJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String,Any>
				if let parsedJson = userJson {
					var errorExist:Bool!
					//Get the error json
					errorExist = parsedJson["error"] as! Bool?
					//Check if any error
					if errorExist == true{
						print(parsedJson["message"] as! String)
					} else {
						//Login information is correct
						print(parsedJson["user"])
					}
				}
			} catch {
				print(error)
			}
		}.resume() //execute task
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}


}

