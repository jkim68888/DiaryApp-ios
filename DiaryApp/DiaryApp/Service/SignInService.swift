//
//  SignInService.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation

struct SignInService {
	// Singleton 생성
	static let shared = SignInService()
	
	// 로그인 로직
	func getSignIn() {
		// userDefaults 에 로그인 식별하기 위한 키값 저장
		// 앱을 껐다켜도 로그인 유지
		UserDefaults.standard.setValue(true, forKey: "authVerificationID")
		UserDefaults.standard.synchronize()
	}
	
	// 로그아웃 로직
	func getLogOut() {
		UserDefaults.standard.setValue(false, forKey: "authVerificationID")
		UserDefaults.standard.synchronize()
	}
}
