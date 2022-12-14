//
//  Post.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/29.
//

import Foundation

struct Post: Codable {
    var id: Int
	var title: String
	var body: String
    var datetime: Date
	var userId: String
	var createdAt: Date
    var image: Image
	
	enum CodingKeys: String, CodingKey {
        case id
		case title
		case body
        case datetime
		case userId = "userid"
		case createdAt = "created_at"
        case image
	}
}
struct Image: Codable{
    var path: String?
	
	enum CodingKeys: String, CodingKey {
		case path
	}
}
