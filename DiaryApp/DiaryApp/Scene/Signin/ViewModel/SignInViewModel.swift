//
//  SignInViewModel.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth

class SignInViewModel {
	// 싱글톤 가져옴
	let signInService = SignInService.shared
	
	var userData: User?
	
	func getKakaoToken(token: String?) {
		UserApi.shared.me { [self] user, error in
			if let error = error {
				print(error)
			} else {
				
				guard let token = token,
					  let name = user?.kakaoAccount?.profile?.nickname else{
					print("token/name is nil")
					return
				}
				
				// 데이터 모델에 담기
//				guard var data = userData else { return }
//				data.token = token
//				data.name = name
				
				print("🥳\(token)")
				
				signInService.accessToken = token
				
				signInService.requestPost(url: "http://localhost:4000/api/auth/callback/kakao", method: "POST", param: ["name": name]) { (success, data) in
					print("뷰모델 Post데이터: \(data)")
				}
			}
		}
	}
	
	// 로그인 로직
	func getKakaoSignIn() {
		print(UserApi.isKakaoTalkLoginAvailable())
		
		// isKakaoTalkLoginAvailable() : 카톡 설치 되어있으면 true
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
					self.getKakaoToken(token: oauthToken?.accessToken)
					
					goHomeVC()
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
					self.getKakaoToken(token: oauthToken?.accessToken)
					self.getUserInfo()
					
					goHomeVC()
				}
			}
		}
	}
	
	// 백엔드에서 유저 가져오기
	func getUserInfo() {
		signInService.requestGet(url: "http://localhost:4000/api/home") { (success, data) in
			print("뷰모델 Get데이터: \(data)")
		}
	}
}
