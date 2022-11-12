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

	// MARK: - Read Post
    func getPostData(id : Int, completionHandler: @escaping (Bool, Post) -> Void){
        MyAlamofireManager
            .shared
            .session
            .request(MyEditRouter.getPostData(term: id))
            .validate(statusCode: 200..<300)
            .responseData{ data in
                switch data.result{
                case .success(let response):
                    print(response)
                    let json = JSON(response)
                    print(json)
                    // 이제 서버에서 정상적으로 응답을 받아왔으니, 해당 응답내용을 우리들이 볼 수 있도록 재정의한다.
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)

                    guard let output = try? decoder.decode(Post.self, from: response) else {
                        print("Error: JSON Data Parsing failed - getPostsListData")
                        return
                    }
                    print("PostList호출에 성공했습니다.")
                    completionHandler(true,output)
                    
                case .failure(let error):
                    print("\(error)입니다.")
                    return
                }
            }
    }
	
    // MARK: - Read PostsList
    func PostListData_Alamofire(completionHandler: @escaping (Bool, [Post]) -> Void) {

        MyAlamofireManager
            .shared
            .session
            .request(MySearchRouter.loadPostList)
            .validate(statusCode: 200..<300)
            .responseData{ data in
            
            switch data.result{
            case .success(let response):
                print(response)
                let json = JSON(response)
                print(json)
                // 이제 서버에서 정상적으로 응답을 받아왔으니, 해당 응답내용을 우리들이 볼 수 있도록 재정의한다.
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                guard let output = try? decoder.decode([Post].self, from: response) else {
                    print("Error: JSON Data Parsing failed - getPostsListData")
                    return
                }
                print("PostList호출에 성공했습니다.")
                completionHandler(true,output)
                
            case .failure(let error):
                print("\(error)입니다.")
                return
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

		let urlComponents = ""
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
	
	// MARK: - Create Post
	func addPostData_Alamofire(accessToken: String, title: String, body: String, image: UIImage ,completionHandler: @escaping (Bool, Post) -> Void){
//        guard let url = URL(string: "http://10.4.10.109:4000/api/post/write") else{
//        guard let url = URL(string: "http://192.168.35.167:4000/api/post/write") else{
        guard let url = URL(string: "http://localhost:4000/api/post/write") else{
            print("Error: cannot create URL")
            return
        }
        let headers: HTTPHeaders = [
            "Content-type" : "multipart/form-data",
            "Authorization" : "Bearer \(accessToken)"
        ]
        let body : Parameters = [
            "title" : title,
            "body" : body,
        ]
        AF.upload(multipartFormData: { (multipart) in
            if let imageData = image.jpegData(compressionQuality: 1){
                multipart.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            for (key, value) in body {
				multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url,
            method: .post,
                  headers: headers).responseJSON { (response) in
            print(response)
            
            if let err = response.error{
                print(err)
                return
            }
            print("성공")
            let json = response.data
            if (json != nil){
                print(json)
            }
        }
    }

	// MARK: - Update Post
	func updatePostData(accessToken: String, image: UIImage, completionHandler: @escaping (Bool, Any) -> Void) {
		let urlComponents = ""
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
		let urlComponents = ""

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
