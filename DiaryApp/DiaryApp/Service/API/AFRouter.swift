//
//  MySearchRouter.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/11/09.
//

import Alamofire

enum AFRouter: URLRequestConvertible{
	case loadPostList
	case getPostData(id: Int)
	case addPost
	case updatePost
	case deletePost(id: Int)
	
	var baseURL: URL {
		return URL(string: Config().baseUrl)!
	}
	
	var method: HTTPMethod {
		switch self {
		case .loadPostList:
			return .post
		case .getPostData:
			return .get
		case .addPost:
			return .post
		case  .updatePost:
			return .patch
		case . deletePost:
			return .delete
		}
	}
	
	var path: String {
		switch self {
		case .loadPostList:
			return "/api/posts/list"
		case .getPostData:
			return "/api/post/read"
		case .addPost:
			return "/api/post/write"
		case .deletePost:
			return "/api/post/remove"
		case .updatePost:
			return "/api/post/update"
		}
	}
	
	var parameters: [String:Int]?{
		switch self{
		case let .getPostData(id), let .deletePost(id):
			return ["id": id]
		case .loadPostList, .addPost, .updatePost:
			return nil
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

