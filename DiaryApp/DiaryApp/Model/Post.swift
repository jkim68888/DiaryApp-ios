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
    var id: Int
	var title: String
	var body: String
    var datetime: Date
	var userId: String
	var createdAt: Date
    var image: Image?
	
	enum CodingKeys: String, CodingKey {
        case id = "id"
		case title = "title"
		case body = "body"
        case datetime = "datetime"
		case userId = "userid"
		case createdAt = "created_at"
        case image = "image"
	}
}
struct Image: Codable{
    let path: String
}
