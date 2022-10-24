//
//  User.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

struct UserData: Codable {
	let snsid: String
	let nickname: String
	
	enum CodingKeys: String, CodingKey {
		case snsid = "snsid"
		case nickname = "nickname"
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
