//
//  BaseInterceptor.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/11/09.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor{
    // 서버에서 response를 줄때, 실행된다.
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor - adapt() called")
        
        var request = urlRequest
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(UserDefaults.standard.value(forKey: "authVerificationID")!)", forHTTPHeaderField: "Authorization")
        
        // 공통 파라매터 추가
//        var dictionary = [String:String]()
//        dictionary.updateValue(<#T##value: String##String#>, forKey: <#T##String#>)
//
//        do{
//            request = try URLEncodedFormParameterEncoder().encode(dictionary, into: request)
//        }catch{
//            print(error)
//        }
               
        
        completion(.success(request))
    }
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        let data = ["statusCode": statusCode]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.AUTH_FAIL), object: nil,userInfo: data) 
        
        completion(.doNotRetry)
    }
}
