//
//  PilsModel.swift
//  drugs list
//
//  Created by Sergey Ivchenko on 05.02.2022.
//

import Foundation

struct Pills: Codable {
    let count: Int?
    let next: String?
    let pillsList: [ItemPill]
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case pillsList = "results"
    }
}

struct ItemPill: Codable {
    let id: Int
    let composition: Composition
    let packaging: Packaging
    let tradeLabel: TradeLabel
    let manufacturer: Manufacturer?
    
    enum CodingKeys: String, CodingKey {
        case id, composition, packaging
        case tradeLabel = "trade_label"
        case manufacturer
    }
}

struct Composition: Codable {
    let compositionDescription: String
    let inn: TradeLabel
    let pharmForm: PharmForm

    enum CodingKeys: String, CodingKey {
        case compositionDescription = "description"
        case inn
        case pharmForm = "pharm_form"
    }
}

struct TradeLabel: Codable {
    let name: String
}

class PharmForm: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct Manufacturer: Codable {
    let name: String
}

struct Packaging: Codable {
    let packagingDescription: String

    enum CodingKeys: String, CodingKey {
        case packagingDescription = "description"
    }
}
