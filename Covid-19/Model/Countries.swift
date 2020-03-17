//
//  Countries.swift
//  Covid-19
//
//  Created by Makwan BK on 3/15/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import Foundation

struct Country: Codable, Comparable {

    var country: String
    let cases: String
    let deaths: String
    let recovered: String
    let lastupdated: String?
    let comments: String?
    
    static func <(lhs: Country, rhs: Country) -> Bool {
        return lhs.country < rhs.country
    }
    
    var details: CountryInfo {
        let name = country.replacingMultipleOccurrences(using: (of: "Mainland ", with: ""), (of: "**", with: ""), (of: "*", with: ""), (of: "Occupied Palestinian territory", with: "Palestine"))
        let caseCount = Int(cases) ?? 0
        let deathCount = Int(deaths) ?? 0
        let recoveredCount = Int(recovered.replacingOccurrences(of: ",", with: "")) ?? 0
        
        
        return CountryInfo(country: name, cases: caseCount, deaths: deathCount, recovered: recoveredCount, lastupdated: lastupdated ?? "", comments: comments ?? "")
    }
    
}

struct CountryInfo {
    
    var country: String
    let cases: Int
    let deaths: Int
    let recovered: Int
    let lastupdated: String?
    let comments: String?    
    
}

struct Sheet: Codable {
    let title: String
    let last_updated : String
    let entries: [Country]
}
