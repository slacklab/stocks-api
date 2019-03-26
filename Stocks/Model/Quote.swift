//
//  Quote.swift
//  Stocks
//
//  Created by Ivan on 14.09.2018.
//  Copyright © 2018 Ivan Sorokoletov. All rights reserved.
//

import Foundation

class Quote : Decodable {
    var companyName = ""
    var symbol = ""
    var latestPrice = 0.0
    var change = 0.0
}
