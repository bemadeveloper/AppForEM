//
//  TodoJSON.swift
//  AppForEM
//
//  Created by Bema on 5/2/25.
//

import Foundation

struct TodoJSON: Codable {
    let id: Int64
    let todo: String
    let completed: Bool
    let userId: Int64
}
