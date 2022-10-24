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
	private let baseUrl = "http://localhost:4000"
	
	// pathUrl
	private let kakaoPath = "/api/auth/callback/kakao"
	private let googlePath = "/api/auth/callback/google"
	private let applePath = "/api/auth/callback/apple"
	private let naverPath = "/api/auth/callback/naver"
	private let loginPath = "/api/home"
	
	// MARK: - 카카오 로그인
	func requestKakao(name: String, accessToken: String, completionHandler: @escaping (Bool, Account) -> Void) {
		let param = ["name": name]
		let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
		let urlComponents = "\(baseUrl)\(kakaoPath)"
		
		guard let url = URL(string: urlComponents) else {
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
				print("Error: error calling - requestKakao")
				print(error!)
				return
			}
			guard let data = data else {
				print("Error: Did not receive data - requestKakao")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed - requestKakao")
				return
			}
			guard let output = try? JSONDecoder().decode(Account.self, from: data) else {
				print("Error: JSON Data Parsing failed - requestKakao")
				return
			}
			
			print("requestKakao - \(response)")
			print("requestKakao - \(String(decoding: data, as: UTF8.self))")

			completionHandler(true, output)
		}.resume()
	}
	
	// MARK: - jwt 토큰 요청
	func requestSignInToken(accessToken: String, completionHandler: @escaping (Bool, Any) -> Void) {
		let urlComponents = "\(baseUrl)\(loginPath)"
		
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
				print("Error: error calling - requestSignInToken")
				print(error!)
				return
			}
			guard let data = data else {
				print("Error: Did not receive data - requestSignInToken")
				return
			}
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
				print("Error: HTTP request failed \(response) - requestSignInToken")
				return
			}
			
			print("requestSignInToken - \(response)")
			print("requestSignInToken - \(String(decoding: data, as: UTF8.self))")
			
			completionHandler(true, data)
		}.resume()
	}
}
