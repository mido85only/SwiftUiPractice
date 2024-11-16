//
//  User.swift
//  SwiftUiPractice
//
//  Created by mohammed on 16/10/2024.
//

import Foundation

// MARK: - UserArray
struct UserArray: Codable {
    let users: [User]
    let total, skip, limit: Int
}

// MARK: - User
struct User: Codable , Identifiable {
    let id: Int
    let firstName, lastName: String
    let age: Int
    let email, phone, username, password: String
    let image: String
    let height, weight: Double
}
