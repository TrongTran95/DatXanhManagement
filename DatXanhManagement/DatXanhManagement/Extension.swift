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

extension UINavigationItem {
	func setTitle(title:String, subtitle:String) {
		
		let one = UILabel()
		one.text = title
		one.font = UIFont.systemFont(ofSize: 17)
		one.sizeToFit()
		
		let two = UILabel()
		two.text = subtitle
		two.font = UIFont.systemFont(ofSize: 12)
		two.textAlignment = .center
		two.sizeToFit()
		
		
		
		let stackView = UIStackView(arrangedSubviews: [one, two])
		stackView.distribution = .equalCentering
		stackView.axis = .vertical
		stackView.alignment = .center
		
		let width = max(one.frame.size.width, two.frame.size.width)
		stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
		
		one.sizeToFit()
		two.sizeToFit()
		
		
		
		self.titleView = stackView
	}
}


func createCancelAlert(title: String, message: String, cancelTitle: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    return alert
}

func create1ActionAlert(title: String, message: String, actionTitle: String, cancelTitle: String, cancelCompletion:(() -> Void)?, actionCompletion:@escaping() -> Void) -> UIAlertController {
	let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
	let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
		cancelCompletion!()
	}
	let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
		actionCompletion()
	}
	alert.addAction(action)
	alert.addAction(cancelAction)
	return alert
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


func createLoadingView() -> UIView{
	let loadingView = UIView()
	loadingView.frame = UIScreen.main.bounds
	let ai = UIActivityIndicatorView(style: .whiteLarge)
	ai.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
	ai.color = UIColor.red
	ai.startAnimating()
	ai.translatesAutoresizingMaskIntoConstraints = false
	loadingView.addSubview(ai)
	let constraints = AutoLayout.shared.getCenterConstraint(currentView: ai, destinationView: loadingView)
	loadingView.addConstraints(constraints)
	return loadingView
}

func getJsonUsingGet(strURL: String, completion: @escaping(Dictionary<String, Any>) -> Void){
	//Create an url
	let url = URL(string: strURL)
	//Create a request to server
	var request = URLRequest(url: url!)
	//Set requests datas
	request.httpMethod = "GET"
	
	//Create a task to send the post request
	let session = URLSession.shared
	let task = session.dataTask(with: request) { (data, res, error) in
		//If error, print error message and stop app
		if (error != nil){
			print ("error is: \(String(describing: error))")
			return;
		}
		
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
	
	
	func maxLengthFromRightToLeft(length: Int) -> String {
		var str = self
		let nsString = str as NSString
		let subLength = nsString.length - length
		if subLength >= 0 {
			str = nsString.substring(with:
				NSRange(
					location: subLength,
					length: subLength > 0 ? length : nsString.length)
			)
		}
		return  str
	}
	
	
	
	func extractAll(type: NSTextCheckingResult.CheckingType) -> [NSTextCheckingResult] {
		var result = [NSTextCheckingResult]()
		do {
			let detector = try NSDataDetector(types: type.rawValue)
			result = detector.matches(in: self, range: NSRange(startIndex..., in: self))
		} catch { print("ERROR: \(error)") }
		return result
	}
	
	func to(type: NSTextCheckingResult.CheckingType) -> String? {
		let phones = extractAll(type: type).compactMap { $0.phoneNumber }
		switch phones.count {
		case 0: return nil
		case 1: return phones.first
		default: print("ERROR: Detected several phone numbers"); return nil
		}
	}
	
	func onlyDigits() -> String {
		let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
		return String(String.UnicodeScalarView(filtredUnicodeScalars))
	}
	
	func makeAColl() {
		guard   let number = to(type: .phoneNumber),
			let url = URL(string: "tel://\(number.onlyDigits())"),
			UIApplication.shared.canOpenURL(url) else { return }
		if #available(iOS 10, *) {
			UIApplication.shared.open(url)
		} else {
			UIApplication.shared.openURL(url)
		}
	}
	
	
}
