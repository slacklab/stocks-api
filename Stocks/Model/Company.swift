//
//  Company.swift
//  Stocks
//
//  Created by Ivan on 13.09.2018.
//  Copyright © 2018 Ivan Sorokoletov. All rights reserved.
//

import Foundation

class Company : Decodable {
    var symbol = ""
    var companyName = ""
    var close = 0.0
    var open = 0.0
    var latestPrice = 0.0
    var change = 0.0
    var changePercent = 0.0
}
