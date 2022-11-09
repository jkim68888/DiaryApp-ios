//
//  MySearchRouter.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/11/09.
//

import Foundation
import Alamofire
enum MyEditRouter: URLRequestConvertible{
    
    case getPostData(term:Int)
    case updatePost(term:Int)
    case deletePost(term:Int)
        
        var baseURL: URL {
            return URL(string: Config().baseUrl)!
        }
        
        var method: HTTPMethod {
            switch self {
            case .getPostData:
                return .get
            case  .deletePost, .updatePost:
                return .post
            }
        }
        
        var path: String {
            switch self {
            case .getPostData:
                return "/api/post/read"
            case .deletePost:
                return "/api/post/remove"
            case .updatePost:
                return "/api/post/update"
            }
        }
    
    var parameters : [String:Int]?{
        switch self{
        case let .getPostData(term), let .updatePost(term), let .deletePost(term):
            return ["id":term]
        }
    }
        
        func asURLRequest() throws -> URLRequest {
            
            let url = baseURL.appendingPathComponent(path)
            print("MySearchRouter - asURLRequest() called url : \(url)")
            var request = URLRequest(url: url)
            request.method = method
            
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
  
            return request
        }
}

