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
import GoogleSignIn

class SignInViewModel {
	// 싱글톤 가져옴
	let signInService = SignInService.shared

	var account: Account?
	var snsUser: SnsUser?
	
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
					goHomeVC()
				}
			}
		}
	}
	
	// 카카오토큰 가져오기
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
				
				self.snsUser = SnsUser.init(token: token, name: name)
				
				signInService.requestKakao(name: name, accessToken: token) { (success, data) in
					self.account = data
					print("(카카오리퀘스트 성공) jwtToken - \(data.token)")
					
					NotificationCenter.default.post(name: NSNotification.Name("getKakaoSignIn"), object: self.snsUser, userInfo: nil)
					
//					signInService.requestSignInToken(accessToken: data.token) { (success, data) in
//						
//						print("성공🌟\(data)")
//					}
				}
			}
		}
	}
    
}
