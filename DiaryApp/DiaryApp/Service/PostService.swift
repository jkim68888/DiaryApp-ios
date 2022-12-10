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
    /// 현재 와이파이를 켜지 않았을경우, 네트워크에 문제가 있을경우 어떻게 처리할 것인지 정해지지않음. (2022-11-15)
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
				completionHandler(false,[])
                return
            }
            
        }
    }
	
	// MARK: - Create Post
	func addPostData_Alamofire(accessToken: String, title: String, body: String, datetime: Date, image: UIImage ,completionHandler: @escaping (Bool,Int) -> Void){
        
		guard let url = URL(string: "\(Config().baseUrl)/api/post/write") else{
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
			"datetime" : datetime,
        ]
        AF.upload(multipartFormData: { (multipart) in
            if let imageData = image.pngData(){
                multipart.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            for (key, value) in body {
                multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url,
            method: .post,
                  headers: headers).responseJSON { (response) in
            print(response)
            switch response.result{
            case .success(let result):
                
                if let err = response.error{
                    print(err)
                    return
                }
                print("성공")
                let json = response.data
                if (json != nil){
                    print(json)
                }
                
                completionHandler(true,response.response!.statusCode)
            case .failure(let error):
                print("\(error)입니다")
                completionHandler(false,response.response!.statusCode)
                return
            }
        }
    }

	// MARK: - Update Post
    func updatePostData(_ id: Int, accessToken: String, title: String, body: String, datetime: Date, image: UIImage ,completionHandler: @escaping () -> Void) {
        
        guard let url = URL(string: "\(Config().baseUrl)/api/post/update?id=\(id)") else{
            print("Error: cannot create URL")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-type" : "multipart/form-data",
            "Authorization" : "Bearer \(accessToken)"
        ]
        let body : Parameters = [
            "title" : title,
            "body" : body
        ]
        AF.upload(multipartFormData: { (multipart) in
            if let imageData = image.pngData(){
                multipart.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            for (key, value) in body {
                multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url,
            method: .patch,
                  headers: headers).response { (response) in
            print(response)
            
            if let err = response.error{
                print(err)
                return
            }
            completionHandler()
        }
    }

	// MARK: - Delete Post
    func deletePostData(_ id: Int, accessToken: String ,completionHandler: @escaping () -> Void) {
        
        MyAlamofireManager
            .shared
            .session
            .request(MyEditRouter.deletePost(term: id))
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
