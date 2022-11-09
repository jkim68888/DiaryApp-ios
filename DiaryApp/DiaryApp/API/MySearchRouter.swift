//
//  MySearchRouter.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/11/09.
//

import Foundation
import Alamofire
enum MySearchRouter: URLRequestConvertible{
    case loadPostList
    case addPost

        
        var baseURL: URL {
            return URL(string: Config().baseUrl)!
        }
        
        var method: HTTPMethod {
            switch self {
            case .loadPostList:
                return .post
            case .addPost:
                return .post
            }
        
        }
        
        var path: String {
            switch self {
            case .loadPostList:
                return "/api/posts/list"
            case .addPost:
                return "/api/post/write"
            }
        }
    
        
        func asURLRequest() throws -> URLRequest {
            
            let url = baseURL.appendingPathComponent(path)
            print("MySearchRouter - asURLRequest() called url : \(url)")
            var request = URLRequest(url: url)
            request.method = method
  
            return request
        }
}

