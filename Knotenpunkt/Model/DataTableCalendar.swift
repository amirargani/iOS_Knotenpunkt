//
//  DataTableCalendar.swift
//  Knotenpunkt
//
//  Created by ARGA on 25.12.22.
//

import Foundation

// app.quicktype.io -> Convert json to swift <-
// MARK: - Response
struct ResponseCalendar: Codable {
    let itemsCalendar: [ItemsCalendar]
}

// MARK: - Item
struct ItemsCalendar: Codable {
    let Startdatum: String
    let Enddatum: String
    let Startzeit: String
    let Endzeit: String
    let Titel: String
    let Beschreibung: String
    let Ort: String
}
