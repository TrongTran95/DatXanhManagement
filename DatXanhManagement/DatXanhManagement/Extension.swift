//
//  Extension.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/15/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
	func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
		contentMode = mode
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
				else { return }
			DispatchQueue.main.async() {
				self.image = image
			}
			}.resume()
	}
	func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
		guard let url = URL(string: link) else { return }
		downloaded(from: url, contentMode: mode)
	}
}

func getJsonUsingPost(strURL: String, strParams: String, completion: @escaping(Dictionary<String, Any>) -> Void){
	//Create an url
	let url = URL(string: strURL)
	//Create a request to server
	var request = URLRequest(url: url!)
	//Set requests datas
	request.httpMethod = "POST"
	request.httpBody = strParams.data(using: String.Encoding.utf8)

	//Create a task to send the post request
	let session = URLSession.shared
	let task = session.dataTask(with: request) { (data, res, error) in
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
			let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any>
			completion(json)
			
		} catch {
			print(error)
		}
	}
	task.resume()
}

extension String {
	func utf8DecodedString()-> String {
		let data = self.data(using: .utf8)
		if let message = String(data: data!, encoding: .nonLossyASCII){
			return message
		}
		return ""
	}
	
	func utf8EncodedString()-> String {
		let messageData = self.data(using: .nonLossyASCII)
		let text = String(data: messageData!, encoding: .utf8)
		return text!
	}
}
