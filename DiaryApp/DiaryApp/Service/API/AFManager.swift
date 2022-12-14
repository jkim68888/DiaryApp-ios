//
//  MyAlamofireManager.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/11/09.
//

import Foundation
import Alamofire

final class AFManager{
    // 싱글 턴 적용
    static let shared = AFManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:
                        [
                            BaseInterceptor()
                        ])
    
    // 로거 설정
    let monitors = [Logger(), LoggerStatusCode()] as [EventMonitor]
    
    // 세션 설정
    let session: Session
    
    private init(){
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}
