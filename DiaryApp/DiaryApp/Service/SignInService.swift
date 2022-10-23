//
//  SignInService.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth

struct SignInService {
	// Singleton 생성
	static let shared = SignInService()
	
	func getToken(token: String?) {
		UserApi.shared.me { [self] user, error in
			if let error = error {
				print(error)
			} else {
				
				guard let token = token,
					  let name = user?.kakaoAccount?.profile?.nickname else{
					print("token/name is nil")
					return
				}
				
					// 서버에 이메일/토큰/이름 보내주기
					//							self.email = email
					//							self.accessToken = token
					//							self.name = name
				
				print("로그인 완료🌟 토큰: \(token), 이름: \(name)")
			}
		}
	}
	
	// 로그인 로직
	func getSignIn() {
		// isKakaoTalkLoginAvailable() : 카톡 설치 되어있으면 true
		
		print(UserApi.isKakaoTalkLoginAvailable())
		
		if (UserApi.isKakaoTalkLoginAvailable()) {
			//카톡 설치되어있으면 -> 카톡으로 로그인
			UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
				if let error = error {
					print(error)
				} else {
					print("카카오 톡으로 로그인 성공")
					
					_ = oauthToken
					
					// 로그인 관련 메소드 추가
					// 사용자 정보 불러옴
					getToken(token: oauthToken?.accessToken)
				}
			}
		} else {
			// 카톡 없으면 -> 계정으로 로그인
			UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
				if let error = error {
					print(error)
				} else {
					print("카카오 계정으로 로그인 성공")
					
					_ = oauthToken
					
					// 관련 메소드 추가
					// 사용자 정보 불러옴
					getToken(token: oauthToken?.accessToken)
				}
			}
		}
	}
	
	// 로그아웃 로직
	func getLogOut() {
		UserApi.shared.logout {(error) in
			if let error = error {
				print(error)
			}
			else {
				print("logout() success.")
			}
		}
	}
}
