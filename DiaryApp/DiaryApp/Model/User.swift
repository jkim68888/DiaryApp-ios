//
//  User.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

struct Account: Codable {
	var token: String
	
	enum CodingKeys: String, CodingKey {
		case token = "token"
	}
}

struct SnsUser: Codable {
	var token: String
	var name: String
	
	enum CodingKeys: String, CodingKey {
		case token
		case name
	}
}
