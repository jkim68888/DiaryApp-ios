//
//  MyLoggerStatusCode.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/11/09.
//

import Foundation
import Alamofire

final class MyLoggerStatusCode : EventMonitor{
    let queue = DispatchQueue(label: "MyLoggerStatusCode")
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        guard let statusCode = request.response?.statusCode else { return }
        print("MyLoggerStatusCode - statusCode : \(statusCode)")
        debugPrint(response)
    }
}
