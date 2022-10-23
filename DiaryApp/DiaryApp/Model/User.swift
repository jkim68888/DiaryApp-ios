//
//  User.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

struct UserData: Codable {
	let resultCount: Int
	let results: [User]
}

struct User: Codable {
	let token: String
	let name: String
	
	enum CodingKeys: String, CodingKey {
		case token
		case name
	}
}
