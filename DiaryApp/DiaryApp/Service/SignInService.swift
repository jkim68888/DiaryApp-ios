//
//  SignInService.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation

final class SignInService {
	// Singleton 생성
	static let shared = SignInService()
	
	var accessToken: String = ""
	
	// Get
	func requestGet(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
		guard let url = URL(string: url) else {
			print("Error: cannot create URL")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			guard error == nil else {
				print("Error: error calling GET")
				print(error!)
				return
			}
			guard let data = data else {
				print("Error: Did not receive data")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			guard let output = try? JSONDecoder().decode(UserData.self, from: data) else {
				print("Error: JSON Data Parsing failed")
				return
			}
			
			print("Get 데이터: \(data)")
			print("Get 응답: \(response)")
			print("Get 응답: \(output)")
			
			completionHandler(true, output.jwtToken)
		}.resume()
	}
	
	// Post
	func requestPost(url: String, method: String, param: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
		let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
		
		guard let url = URL(string: url) else {
			print("Error: cannot create URL")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = method
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer\(accessToken)", forHTTPHeaderField: "authorization")
		request.httpBody = sendData
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print("Error: error calling GET")
				print(error!)
				return
			}
			guard let data = data else {
				print("Error: Did not receive data")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed")
				return
			}
			
			print("Post 데이터: \(data.description)")
			print("Post 응답: \(response)")
			
			completionHandler(true, data)
		}.resume()
	}
}
