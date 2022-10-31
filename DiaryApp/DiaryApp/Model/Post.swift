//
//  Post.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/29.
//

import Foundation

protocol PostDelegate {
	func updatePost(id: String)
}

struct Post: Codable {
	var title: String
	var body: String
	var userId: String
	var createdAt: Date
	
	enum CodingKeys: String, CodingKey {
		case title = "title"
		case body = "body"
		case userId = "userid"
		case createdAt = "created_at"
	}
}
