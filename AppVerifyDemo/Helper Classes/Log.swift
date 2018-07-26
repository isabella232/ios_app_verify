//
//  Log.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/3/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import Foundation
import os.log

struct Log {
    static var general = OSLog(subsystem: "com.telesign.AppVerifyDemo", category: "general")
    static var error = OSLog(subsystem: "com.telesign.AppVerifyDemo", category: "error")
}
