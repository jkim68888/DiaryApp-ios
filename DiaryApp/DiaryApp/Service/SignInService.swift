//
//  SignInService.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation

struct SignInService {
	// Singleton 생성
	static let shared = SignInService()
	
	// baseUrl
	let baseUrl = "http://localhost:4000"
	
	// Bell
//	let baseUrl = "http://192.168.35.167:4000"

	// Ethan
//	let baseUrl = "http://???:4000"
	
	// pathUrl
	let kakaoPath = "/api/auth/callback/kakao"
	let googlePath = "/api/auth/callback/google"
	let applePath = "/api/auth/callback/apple"
	let naverPath = "/api/auth/callback/naver"
	
	// MARK: - 카카오,구글,애플,네이버 요청
	func requestSignIn(url: String, name: String, accessToken: String, completionHandler: @escaping (Bool, Account) -> Void) {
		let param = ["name": name]
		let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
		
		guard let url = URL(string: url) else {
			print("Error: cannot create URL")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue(accessToken, forHTTPHeaderField: "access-token")
		request.httpBody = sendData
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print("Error: error calling - requestSignIn")
				print(error!)
				return
			}
			guard let data = data else {
				print("Error: Did not receive data - requestSignIn")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed - requestSignIn")
				return
			}
			guard let output = try? JSONDecoder().decode(Account.self, from: data) else {
				print("Error: JSON Data Parsing failed - requestSignIn")
				return
			}
			
			print("requestSignIn - \(response)")
			print("requestSignIn - \(String(decoding: data, as: UTF8.self))")
			
			completionHandler(true, output)
		}.resume()
	}
}
