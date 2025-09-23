//
//  DataTable.swift
//  Knotenpunkt
//
//  Created by ARGA on 21.12.22.
//

import Foundation

// app.quicktype.io -> Convert json to swift <-
// MARK: - Response
struct Response: Codable {
    let items: [Items]
}

// MARK: - Item
struct Items: Codable {
    let Datum: String
    let Fr_Sabbat: String
    let Moderation: String
    let KidsGo: String
    //let Musik: String
    let Gespreachsltng: String
    let Predigt: String
    let Kindermoment: String
    let Zeit: String
    let Ort: String
    let Putzdienst: String
}
