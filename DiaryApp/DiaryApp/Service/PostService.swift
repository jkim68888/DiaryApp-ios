//
//  PostService.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

struct PostService {
	// Singleton 생성
	static let shared = PostService()
	
	// baseUrl
	let baseUrl = Config().baseUrl
	
	// pathUrl
	let postReadPath = "/api/post/read"
	let postWritePath = "/api/post/write"
	let postUpdatePath = "/api/post/update"
	let postDeletePath = "/api/post/remove"
	let postsListPath = "/api/posts/list"
	
	// MARK: - Read Post
	func getPostData(id: String, completionHandler: @escaping (Bool, Post) -> Void) {
		let urlComponents = "\(baseUrl)\(postReadPath)?id=\(id)"
        // 다른 네트워킹과는 다르게 parameter를 필요로한다. 이는 JSON형식인 Key, Value형태이다.
		let param = ["id": id]
        // 서버로 보낼 데이터를 정의해준다. 위의 param변수를 JSON으로 표현해준다.
		let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
        /// 여기서 임시적으로 보낼 Data를 확인한다.
		print("💄💄💄\(String(decoding: sendData, as: UTF8.self))")
        
        // url을 만들어준다.
		guard let url = URL(string: urlComponents) else {
			print("Error: cannot create URL - getPostData")
			return
		}
		
        // URLrequest를 만들어주었다.
		var request = URLRequest(url: url)
        // 통신 명령은 GET, Content-Type은 Json형식
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		//request.httpBody = sendData
		
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
    func getTest(_ id : Int){
        guard let url = URL(string: "\(baseUrl)\(postReadPath)?id=\(id)") else{
            print("Error: cannot create URL")
            return
        }
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json","Accept":"application/json"])
        .validate(statusCode: 200..<300)
        .responseJSON { (json) in
            print("💄")
            print(json)
            print("💄")
        }
    }
	
	// MARK: - Read PostsList
	func getPostsListData(accessToken: String, completionHandler: @escaping (Bool, [Post]) -> Void) {
		let urlComponents = "\(baseUrl)\(postsListPath)"
		// URL을 만들었다.
		guard let url = URL(string: urlComponents) else {
			print("Error: cannot create URL - getPostsListData")
			return
		}
		// URLRequest를 만들어 주었다.
		var request = URLRequest(url: url)
        // 통신 명령은 Post, Content-Type은 json, 토큰은 Bearer형식으로
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		
        // URLSession을 싱글톤으로 만들어서 Data작업을 실행한다.
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			// error값이 nil이 아니면 호출
            guard error == nil else {
				print("Error: error calling - getPostsListData")
				print(error!)
				return
			}
            //Data가 nil이면 호출
			guard let data = data else {
				print("Error: Did not receive data - getPostsListData")
				return
			}
			
            /// Test용으로, 받아온 Data를 이곳에서 한 번 확인한다.
			print("getPostsListData.data - \(String(decoding: data, as: UTF8.self))")
			
            // 서버에서 돌아온 응답값이 200~300사이의 값이 아니라면 호출
			guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print(response)
				print("Error: HTTP request failed - getPostsListData")
				return
			}
			
            /// 서버에서 돌아온 statusCode값을 이곳에서 확인한다.
			print("getPostsListData.response - \(response.statusCode)")
			
            
            // 이제 서버에서 정상적으로 응답을 받아왔으니, 해당 응답내용을 우리들이 볼 수 있도록 재정의한다.
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .formatted(dateFormatter)
			
            // 우리들이 볼 수 있도록 Decode된 Data를 output이라는 변수명에 담는다. 실패시 아래부분을 호출한다.
			guard let output = try? decoder.decode([Post].self, from: data) else {
				print("Error: JSON Data Parsing failed - getPostsListData")
				return
			}
            /// 최종적으로 네트워킹을 끝내기 전, 최종 변환된 Data를 확인한다.
			print("getPostsListData.output - \(output)")
			
			completionHandler(true, output)
		}.resume()
	}
    func getPostListData_Alamofire(accessToken:String) {
        guard let url = URL(string: "\(baseUrl)\(postsListPath)") else{
            print("Error: cannot create URL")
            return
        }
        AF.request(url,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json","Accept":"application/json","Authorization":"Bearer \(accessToken)"])
        .validate(statusCode: 200..<300)
        .responseJSON{ json in
            print("🎨🎨🎨🎨\(json)짜잔🎨🎨🎨🎨")
            switch json.result{
            case .success(let response):
                print(response)
            case .failure(let error):
                print("\(error)입니다.")
            }           
            
        }
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
