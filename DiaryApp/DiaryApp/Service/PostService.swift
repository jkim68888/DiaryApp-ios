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
        AFManager
            .shared
            .session
			.request(AFRouter.getPostData(id: id))
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
    /// 현재 와이파이를 켜지 않았을경우, 네트워크에 문제가 있을경우 어떻게 처리할 것인지 정해지지않음. (2022-11-15)
	/// -> signin으로 뷰를 바꿔줌
    func getPostList(completionHandler: @escaping (Bool, [Post]) -> Void) {
        AFManager
            .shared
            .session
            .request(AFRouter.loadPostList)
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
				completionHandler(false,[])
                return
            }
        }
    }
	
	// MARK: - Create Post
	func addPost(title: String, body: String, datetime: Date, image: UIImage, completionHandler: @escaping (Bool, Int) -> Void){
		let route = AFRouter.addPost(title: title, body: body, datetime: datetime, image: image)
		
		AFManager
			.shared
			.session
			.upload(multipartFormData: route.multipartFormData, with: route)
			.validate(statusCode: 200..<300)
			.responseData { data in
				switch data.result{
				case .success(_):
					if let statusCode = data.response?.statusCode {
						completionHandler(true, statusCode)
					}
				case .failure(let error):
					print("\(error)입니다")
					if let statusCode = data.response?.statusCode {
						completionHandler(false, statusCode)
					}
				}
			}
    }

	// MARK: - Update Post
    func updatePostData(_ id: Int, title: String, body: String, datetime: Date, image: UIImage, completionHandler: @escaping () -> Void) {
		let route = AFRouter.updatePost(id: id, title: title, body: body, datetime: datetime, image: image)
		
		AFManager
			.shared
			.session
			.upload(multipartFormData: route.multipartFormData, with: route)
			.validate(statusCode: 200..<300)
			.responseData { data in
				completionHandler()
			}
    }

	// MARK: - Delete Post
	func deletePostData(_ id: Int, completionHandler: @escaping () -> Void) {
		AFManager
			.shared
			.session
			.request(AFRouter.deletePost(id: id))
			.validate(statusCode: 200..<300)
			.response { (response) in
				print(response)
				
				if let err = response.error{
					print(err)
					return
				}
				completionHandler()
			}
	}
}
