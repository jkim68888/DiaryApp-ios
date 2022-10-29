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

struct PostsList: Codable {
	let list: [Post]
	
	// [Post]는 코딩키가 없음
	init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let postArray = try container.decode([Post].self)
		list = postArray
	}
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
