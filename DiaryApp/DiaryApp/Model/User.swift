//
//  User.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

// requestSnsSignIn()에서 주는 jwtToken
struct Account: Codable {
	var token: String
	
	enum CodingKeys: String, CodingKey {
		case token = "token"
	}
}

// requestHome()에서 주는 유저네임
struct User: Codable {
	var name: String
	
	enum CodingKeys: String, CodingKey {
		case name = "nickname"
	}
}
