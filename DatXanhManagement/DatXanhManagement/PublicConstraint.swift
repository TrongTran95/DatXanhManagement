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
