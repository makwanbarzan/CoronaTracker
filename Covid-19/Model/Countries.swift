//
//  Countries.swift
//  Covid-19
//
//  Created by Makwan BK on 3/15/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import Foundation

struct Country: Codable {
    
    let id: String
    let displayName: String
    let totalConfirmed: Int?
    let totalDeaths: Int?
    let totalRecovered: Int?
    let lastUpdated: String?
    
    var detail : CountryInfo {
        let name = displayName.replacingMultipleOccurrences(using: (of: "China (mainland)", with: "China"))
        let cases = totalConfirmed ?? 0
        let deaths = totalDeaths ?? 0
        let recovers = totalRecovered ?? 0
        let update = lastUpdated
        
        return CountryInfo(name: name, cases: cases, deaths: deaths, recovers: recovers, update: update)
    }
    
//    static func <(lhs: Country, rhs: Country) -> Bool {
//        return lhs.country < rhs.country
//    }
}

struct CountryInfo: Codable {
    let name : String
    let cases: Int
    let deaths: Int
    let recovers: Int
    let update: String?
}

struct World: Codable {
    let id: String
    let displayName: String
    let areas : [Country]
    let totalConfirmed: Int
    let totalDeaths: Int
    let totalRecovered: Int
    let lastUpdated: String?
}
