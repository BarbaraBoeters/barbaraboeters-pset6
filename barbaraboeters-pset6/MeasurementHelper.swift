//
//  MeasurementHelper.swift
//  barbaraboeters-pset6
//
//  Created by Barbara Boeters on 13-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import Foundation
import Firebase

class MeasurementHelper: NSObject {

  static func sendLoginEvent() {
    FIRAnalytics.logEvent(withName: kFIREventLogin, parameters: nil)
  }

  static func sendLogoutEvent() {
    FIRAnalytics.logEvent(withName: "logout", parameters: nil)
  }

  static func sendMessageEvent() {
    FIRAnalytics.logEvent(withName: "message", parameters: nil)
  }
}
