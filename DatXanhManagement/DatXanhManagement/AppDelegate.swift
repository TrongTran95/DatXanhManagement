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
//		window?.frame = UIScreen.main.bounds
		let userEmail = defaults.object(forKey: KEY_USER_EMAIL) as? String ?? ""
		window?.frame = UIScreen.main.bounds
		if (userEmail == "") {
			let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//			nc.viewControllers = [loginVC]
			window?.rootViewController = loginVC
			window?.makeKeyAndVisible()
		} else {
			let userPassword = defaults.object(forKey: KEY_USER_PASSWORD) as! String
			let ios_token = defaults.object(forKey: KEY_USER_DEVICE_TOKEN) as! String
			let user = User()
			
			//Loading screen
			if (userEmail != "admin") {
				setupTempView()
			}
			
			user.login(userName: userEmail, password: userPassword, ios_token: ios_token) { (result) in
				if (result) {
					if user.type == 2 {
						let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
						DispatchQueue.main.async {
							self.window?.rootViewController = loginVC
							self.window?.makeKeyAndVisible()
						}
					} else {
						let nc = UINavigationController()
						//Personal
						if (user.type == 1) {
							let userVC = mainStoryboard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
							
							DispatchQueue.main.async {
								if (user.lastName == "" && user.firstName == ""){
									userVC.navigationItem.title = user.emailAddress
								} else {
									if (user.firstName == "" || user.lastName == ""){
										if (user.firstName == ""){
											userVC.navigationItem.setTitle(title: user.lastName, subtitle: user.emailAddress)
										}
										if (user.lastName == ""){
											userVC.navigationItem.setTitle(title: user.firstName, subtitle: user.emailAddress)
										}
									} else {
										userVC.navigationItem.setTitle(title: "\(user.firstName) \(user.lastName)", subtitle: user.emailAddress)
									}
								}
							}
							userVC.user = user
							nc.viewControllers = [userVC]
							print("ssssssssssssss1")
						}
							//Team
						else {
							let teamTBC = mainStoryboard.instantiateViewController(withIdentifier: "TeamTBC") as! TeamTBC
							teamTBC.user = user
							//Fix bug not showing tab bar item title
							teamTBC.tabBar.items![0].title = ""
							teamTBC.tabBar.items![1].title = ""
							teamTBC.tabBar.items![2].title = ""
							teamTBC.tabBar.items![3].title = ""
							nc.viewControllers = [teamTBC]
							
							//UITabBar.appearance().barTintColor = .black
							UITabBar.appearance().tintColor = barButtonColor
						}
						
						DispatchQueue.main.async {
							self.window?.rootViewController = nc
							self.window?.makeKeyAndVisible()
						}
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
				
				if let emailTeam = data?["emailTeam"], let emailPersonal = data?["emailPersonal"], let customerId = data?["customerId"] {
					defaults.set(true, forKey: KEY_ISPUSH)
					let userEmail = defaults.object(forKey: KEY_USER_EMAIL) as! String
					let userPassword = defaults.object(forKey: KEY_USER_PASSWORD) as! String
					let ios_token = defaults.object(forKey: KEY_USER_DEVICE_TOKEN) as! String
					let user = User()
					user.login(userName: userEmail, password: userPassword, ios_token: ios_token, completion: { (result) in
						if (result) {
							DispatchQueue.main.async {
								
								if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//									self.window?.rootViewController = UserVC()
									let nc = appDelegate.window?.rootViewController as! UINavigationController
									
									let vc = nc.viewControllers[0] as! UserVC
									vc.emailTeam = emailTeam as! String
									vc.emailPersonal = emailPersonal as! String
									vc.customerId = Int((customerId as! NSString).doubleValue)
//									vc.pushToNext()
									appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
									(appDelegate.window?.rootViewController as? UINavigationController)?.popToViewController(vc, animated: false)
//									(appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: false)
								}
							}
						} else {
							print("appdelete janai")
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

