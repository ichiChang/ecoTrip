//
//  User.swift
//  ecoTrip
//
//  Created by Ichi Chang on 2024/6/28.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
}
