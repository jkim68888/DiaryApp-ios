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

	// Bell
//	let baseUrl = "http://192.168.35.167:4000"

	// Ethan
//	let baseUrl = "http://10.4.10.109:4000"
	
	// pathUrl
	let postReadPath = "/api/post/read"
	let postWritePath = "/api/post/write"
	let postUpdatePath = "/api/post/update"
	let postDeletePath = "/api/post/remove"
	let postsListPath = "/api/posts/list"
	
	// MARK: - Read Post
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
	
	// MARK: - Read PostsList
	func getPostsListData(accessToken: String, completionHandler: @escaping (Bool, [Post]) -> Void) {
		let urlComponents = "\(baseUrl)\(postsListPath)"
		
		guard let url = URL(string: urlComponents) else {
			print("Error: cannot create URL - getPostsListData")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		
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
			guard let output = try? JSONDecoder().decode([Post].self, from: data) else {
				print("Error: JSON Data Parsing failed - getPostData")
				return
			}
			
			print("getPostData - \(response.statusCode)")
			print("getPostData - \(String(decoding: data, as: UTF8.self))")
			
			completionHandler(true, output)
		}.resume()
	}
	
	// MARK: - Create Post
	func addPostData(accessToken: String, image: UIImage, completionHandler: @escaping (Bool, Post) -> Void) {
		var imageData = Data()
		// generate boundary string using a unique per-app string
		let boundary = UUID().uuidString
		
		// Add the image data to the raw http request data
		imageData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
		imageData.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
		imageData.append(image.pngData()!)
		
//		let imageJsonData = try? JSONSerialization.jsonObject(with: imageData, options: .allowFragments)
		
//		let imageJson = imageData as? [String: Any]
		 
		print(imageData)
		
		let urlComponents = "\(baseUrl)\(postWritePath)"
		let param = ["image": imageData]
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
	
	// MARK: - Update Post
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
	
	// MARK: - Delete Post
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
