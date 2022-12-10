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
	case addPost(title: String, body: String, datetime: Date, image: UIImage)
	case updatePost(id: Int, title: String, body: String, datetime: Date, image: UIImage)
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
		case .updatePost:
			return "/api/post/update"
		case .deletePost:
			return "/api/post/remove"
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
		print("AF called url : \(url)")
		
		var request = URLRequest(url: url)
		request.method = method
		
		// addPost와 updatePost만 헤더에 content-type을 multipart/form-data로 넣어줌
		switch self {
		case .addPost, .updatePost:
			request.setValue("multipart/form-data", forHTTPHeaderField: "Content-type")
		default:
			break
		}
		
		// multipart 형태가 아닌것만 request가 여기로 들어옴
		switch self {
		case .loadPostList, .getPostData, .deletePost:
			request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
		default:
			break
		}
		
		return request
	}
	
	// MARK: - MultipartFormData
	var multipartFormData: MultipartFormData {
		let multipartFormData = MultipartFormData()
		
		switch self {
		case .addPost(let title, let body, let datetime, let image):
			let titleData = title.data(using: .utf8) ?? Data()
			let bodyData = body.data(using: .utf8) ?? Data()
			let datetimeData = datetime.toString().data(using: .utf8) ?? Data()
			let imageData = image.pngData() ?? Data()
			
			multipartFormData.append(titleData, withName: "title")
			multipartFormData.append(bodyData, withName: "body")
			multipartFormData.append(datetimeData, withName: "datetime")
			multipartFormData.append(imageData, withName: "image", fileName: "Image.png", mimeType: "image/png")
			
			return multipartFormData
		case .updatePost(let id, let title, let body, let datetime, let image):
			let idData = "\(id)".data(using: .utf8) ?? Data()
			let titleData = title.data(using: .utf8) ?? Data()
			let bodyData = body.data(using: .utf8) ?? Data()
			let datetimeData = datetime.toString().data(using: .utf8) ?? Data()
			let imageData = image.pngData() ?? Data()
			
			multipartFormData.append(idData, withName: "id")
			multipartFormData.append(titleData, withName: "title")
			multipartFormData.append(bodyData, withName: "body")
			multipartFormData.append(datetimeData, withName: "datetime")
			multipartFormData.append(imageData, withName: "image", fileName: "Image.png", mimeType: "image/png")
			
			return multipartFormData
		default: ()
		}
		
		return multipartFormData
	}
}

