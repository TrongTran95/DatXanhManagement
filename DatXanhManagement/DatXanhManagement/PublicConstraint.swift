//
//  PublicConstraint.swift
//  DatXanhManagement
//
//  Created by Trong Tran on 7/24/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

let KEY_STILL_NOT = "StillNot"
let KEY_ALREADY = "Already"

let KEY_USER_EMAIL = "userEmail"
let KEY_USER_PASSWORD = "userPassword"
let KEY_USER_DEVICE_TOKEN = "userDeviceToken"

let KEY_ISPUSH = "isPush"

let defaults = UserDefaults.standard
let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let NOTE_PLACE_HOLDER = "Nhập ghi chú..."
let ALERT_DATA_CHANGED = "Data changed"
let ALERT_ASK_FOR_SAVE = "Do you want to save new data ?"

let barButtonColor = UIColor(red: 255.0/255.0, green: 173.0/255.0, blue: 59.0/255.0, alpha: 1)
