//
//  AppDelegate.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/14/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit
import CallKit
import OneSignal

var ios_device_token: String = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		//Setup push notification
		setupOneSignal(launchOptions: launchOptions)
		//Setup first view (LoginVC/UserVC/TeamVC) ~> Future: AdminVC
		setupRootView()
		
		return true
	}
	
	func setupRootView(){
		let nc = UINavigationController()
//		window?.frame = UIScreen.main.bounds
		let userEmail = defaults.object(forKey: KEY_USER_EMAIL) as? String
		window?.frame = UIScreen.main.bounds
		if (userEmail == nil) {
			let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
			nc.viewControllers = [loginVC]
			window?.rootViewController = nc
			window?.makeKeyAndVisible()
		} else {
			let userPassword = defaults.object(forKey: KEY_USER_PASSWORD) as! String
			let ios_token = defaults.object(forKey: KEY_USER_DEVICE_TOKEN) as! String
			let user = User()
			
			//Loading screen
			setupTempView()

			user.login(userName: userEmail!, password: userPassword, ios_token: ios_token) { (result) in
				if (result) {
					//Personal
					if (user.type == 1) {
						let userVC = mainStoryboard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
						userVC.user = user
						nc.viewControllers = [userVC]
						print("ssssssssssssss1")
					}
					//Team
					else {
						let teamTBC = mainStoryboard.instantiateViewController(withIdentifier: "TeamTBC") as! TeamTBC
//						let teamVC = TeamTBC()
						teamTBC.user = user
						nc.viewControllers = [teamTBC]
						
						//UITabBar.appearance().barTintColor = .black
						UITabBar.appearance().tintColor = .red
					}
					DispatchQueue.main.async {
						print("ssssssssssssss2")
						self.window?.rootViewController = nc
						self.window?.makeKeyAndVisible()
						print("ssssssssssssss3")
					}
				} else {
					print("Check access to internet")
				}
				
			}
		}
	}
	
	func setupTempView(){
		let tempView = UIViewController()
		tempView.view.frame = UIScreen.main.bounds
		tempView.view.backgroundColor = UIColor.white
		let ai = UIActivityIndicatorView(style: .whiteLarge)
		ai.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
		ai.color = UIColor.red
		ai.startAnimating()
		ai.translatesAutoresizingMaskIntoConstraints = false
		tempView.view.addSubview(ai)
		let constraints = AutoLayout.shared.getCenterConstraint(currentView: ai, destinationView: tempView.view)
		tempView.view.addConstraints(constraints)
		window?.rootViewController = tempView
		window?.makeKeyAndVisible()
	}
	
	func setupOneSignal(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
		let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
			
			print("Received Notification: \(notification!.payload.notificationID!)")
		}
		
		let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
			print("call back")
			// This block gets called when the user reacts to a notification received
			let payload: OSNotificationPayload = result!.notification.payload
//
//			var fullMessage = payload.body
//
//			print("Message = \(fullMessage!)")
//			print(payload.additionalData!)
			if payload.additionalData != nil {
//				if payload.title != nil {
//					let messageTitle = payload.title
//					print("Message Title = \(messageTitle!)")
//				}
				
				//projectName + emailPersonal + customerId
				
				let data = payload.additionalData
				
				if let projectName = data?["projectName"], let emailPersonal = data?["emailPersonal"], let customerId = data?["customerId"] {
					defaults.set(true, forKey: KEY_ISPUSH)
					let userEmail = defaults.object(forKey: KEY_USER_EMAIL) as! String
					let userPassword = defaults.object(forKey: KEY_USER_PASSWORD) as! String
					let ios_token = defaults.object(forKey: KEY_USER_DEVICE_TOKEN) as! String
					let user = User()
					user.login(userName: userEmail, password: userPassword, ios_token: ios_token, completion: { (result) in
						if (result) {
							DispatchQueue.main.async {
								
								if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
									let nc = appDelegate.window?.rootViewController as! UINavigationController
									let vc = nc.viewControllers[0] as! UserVC
									vc.projectName = projectName as! String
									vc.emailPersonal = emailPersonal as! String
									vc.customerId = Int((customerId as! NSString).doubleValue)
//									vc.pushToNext()
//									appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
									(appDelegate.window?.rootViewController as? UINavigationController)?.popToViewController(vc, animated: false)
//									(appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: false)
								}
							}
						} else {
							
						}
					})
				}
			}
		}
		
		
		let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
		
		// Replace 'YOUR_APP_ID' with your OneSignal App ID.
		OneSignal.initWithLaunchOptions(launchOptions,
										appId: "35bede42-3f48-4ddf-b157-ab1161815d2b",
										handleNotificationReceived: notificationReceivedBlock,
										handleNotificationAction: notificationOpenedBlock,
										settings: onesignalInitSettings)
		
		OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
		
		// Recommend moving the below line to prompt for push after informing the user about
		//   how your app will use them.
		OneSignal.promptForPushNotifications(userResponse: { accepted in
			print("User accepted notifications: \(accepted)")
		})
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		print("abbasd")
	}
	
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenParts = deviceToken.map { data -> String in
			return String(format: "%02.2hhx", data)
		}
		ios_device_token = tokenParts.joined()
		
		print(ios_device_token)
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		print("fore ground")
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

