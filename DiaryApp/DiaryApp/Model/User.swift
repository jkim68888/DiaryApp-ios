//
//  User.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

// jwtToken
struct Account: Codable {
	var token: String
	
	enum CodingKeys: String, CodingKey {
		case token
	}
}

// 유저네임
struct User: Codable {
	var name: String
	
	enum CodingKeys: String, CodingKey {
		case name = "nickname"
	}
}
