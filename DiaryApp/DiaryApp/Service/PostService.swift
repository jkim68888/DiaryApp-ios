//
//  PostService.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation
import UIKit

struct PostService {
	// Singleton 생성
	static let shared = PostService()
	
	// baseUrl
	let baseUrl = "http://localhost:4000"
	
	// pathUrl
	let postReadPath = "/api/post/read"
	let postWritePath = "/api/post/write"
	let postUpdatePath = "/api/post/update"
	let postDeletePath = "/api/post/remove"
	
	// MARK: - Read
	func getPostData(id: String, completionHandler: @escaping (Bool, Post) -> Void) {
		let urlComponents = "\(baseUrl)\(postReadPath)?id=\(id)"
		let param = ["id": id]
		let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
		
		guard let url = URL(string: urlComponents) else {
			print("Error: cannot create URL - getPostData")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = sendData
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print("Error: error calling - getPostData")
				print(error!)
				return
			}
			guard let data = data else {
				print("Error: Did not receive data - getPostData")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed - getPostData")
				return
			}
			guard let output = try? JSONDecoder().decode(Post.self, from: data) else {
				print("Error: JSON Data Parsing failed - getPostData")
				return
			}
			
			print("getPostData - \(response.statusCode)")
			print("getPostData - \(String(decoding: data, as: UTF8.self))")
			
			completionHandler(true, output)
		}.resume()
	}
	
	// MARK: - Create
	func addPostData(accessToken: String, image: UIImage, completionHandler: @escaping (Bool, Post) -> Void) {
		let urlComponents = "\(baseUrl)\(postWritePath)"
		let param = ["image": image]
		let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
		
		guard let url = URL(string: urlComponents) else {
			print("Error: cannot create URL - addPostData")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		request.httpBody = sendData
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print("Error: error calling - addPostData")
				print(error!)
				return
			}
			guard let data = data else {
				print("Error: Did not receive data - addPostData")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed - addPostData")
				return
			}
			guard let output = try? JSONDecoder().decode(Post.self, from: data) else {
				print("Error: JSON Data Parsing failed - addPostData")
				return
			}
			
			print("addPostData - \(response.statusCode)")
			print("addPostData - \(String(decoding: data, as: UTF8.self))")
			
			completionHandler(true, output)
		}.resume()
	}
	
	// MARK: - Update
	func updatePostData(accessToken: String, image: UIImage, completionHandler: @escaping (Bool, Any) -> Void) {
		let urlComponents = "\(baseUrl)\(postUpdatePath)"
		let param = ["image": image]
		let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
		
		guard let url = URL(string: urlComponents) else {
			print("Error: cannot create URL - updatePostData")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		request.httpBody = sendData
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print("Error: error calling - updatePostData")
				print(error!)
				return
			}
			guard let data = data else {
				print("Error: Did not receive data - updatePostData")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed - updatePostData")
				return
			}
			let output = String(decoding: data, as: UTF8.self)
			
			print("updatePostData - \(response.statusCode)")
			print("updatePostData - \(output)")
			
			completionHandler(true, output)
		}.resume()
	}
	
	// MARK: - Delete
	func deletePostData(id: String, accessToken: String, completionHandler: @escaping (Bool, Any) -> Void) {
		let urlComponents = "\(baseUrl)\(postDeletePath)?id=\(id)"
		
		guard let url = URL(string: urlComponents) else {
			print("Error: cannot create URL - deletePostData")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print("Error: error calling - deletePostData")
				print(error!)
				return
			}
			guard let data = data else {
				print("Error: Did not receive data - deletePostData")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed - deletePostData")
				return
			}
			let output = String(decoding: data, as: UTF8.self)
			
			print("deletePostData - \(response.statusCode)")
			print("deletePostData - \(output)")
			
			completionHandler(true, output)
		}.resume()
	}
}
