//
//  MyLogger.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/11/09.
//

import Foundation
import Alamofire

final class MyLogger : EventMonitor{
    let queue = DispatchQueue(label: "MyLogger")
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume()")
        debugPrint(request)
    }
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - request.didParseResponse()")
        debugPrint(response)
    }
}
