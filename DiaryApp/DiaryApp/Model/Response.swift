//
//  Response.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

struct Response: Codable {
	let success: Bool
	let result: String
	let message: String
}
