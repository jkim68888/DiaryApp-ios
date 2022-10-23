//
//  User.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

struct UserData: Codable {
	let jwtToken: String
	
	enum CodingKeys: String, CodingKey {
		case jwtToken
	}
}

struct User: Codable {
	var token: String
	var name: String
	
	enum CodingKeys: String, CodingKey {
		case token
		case name
	}
}
