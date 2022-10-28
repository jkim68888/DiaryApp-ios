//
//  PostService.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation

struct PostService {
	// Singleton 생성
	static let shared = PostService()
	
	// baseUrl
	let baseUrl = "http://localhost:4000"
	
	// pathUrl
	let postPath = "/api/???"
	
	// MARK: - post api 요청
	func requestPost(accessToken: String, completionHandler: @escaping (Bool, User) -> Void) {
		let urlComponents = "\(baseUrl)\(postPath)"
		
		guard let url = URL(string: urlComponents) else {
			print("Error: cannot create URL")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer\(accessToken)", forHTTPHeaderField: "authorization")
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print("Error: error calling - requestPost")
				print(error!)
				return
			}
			guard let data = data else {
				print("Error: Did not receive data - requestPost")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed - requestPost")
				return
			}
			guard let output = try? JSONDecoder().decode(User.self, from: data) else {
				print("Error: JSON Data Parsing failed - requestPost")
				return
			}
			
			print("requestPost - \(response)")
			print("requestPost - \(String(decoding: data, as: UTF8.self))")
			
			completionHandler(true, output)
		}.resume()
	}
}
