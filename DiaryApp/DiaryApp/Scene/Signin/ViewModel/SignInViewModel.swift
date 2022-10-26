//
//  SignInViewModel.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation
import UIKit
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth
import GoogleSignIn

class SignInViewModel {
	// 싱글톤 가져옴
	let signInService = SignInService.shared

	var account: Account?
	
	let googleSignInConfig = GIDConfiguration.init(clientID: Config().googleId)
	
	// 백엔드 서버 통신
	func fetchData(url: String, name: String, token: String) {
		signInService.requestSnsSignIn(url: url, name: name, accessToken: token) { [self] (success, data) in
			self.account = data
			print("(카카오리퀘스트 성공) jwtToken - \(data.token)")
			
			UserDefaults.standard.setValue(data.token , forKey: "authVerificationID")
			UserDefaults.standard.synchronize()
			
			// view를 바꿔주는건 main 디스패치큐에서 실행
			DispatchQueue.main.async {
				changeRootVC()
			}
			
			// 홈뷰컨으로 home api 요청 시점을 알려주기 위한 notification
			// root view가 홈으로 바뀐뒤, 알려줘야 하므로, 시간차를 둠
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				NotificationCenter.default.post(name: NSNotification.Name("loginSuccess"), object: nil, userInfo: nil)
			}
		}
	}
	
	// 카카오 로그인
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
				
				print("token: \(token)")
				
				// 서버에 보낼 함수
				fetchData(url: "\(signInService.baseUrl)\(signInService.kakaoPath)", name: name, token: token)
			}
		}
	}
	
	// 구글 로그인
	func getGoogleSignIn() {
		GIDSignIn.sharedInstance.signIn(with: self.googleSignInConfig, presenting: (UIApplication.shared.windows.first?.rootViewController)!) { user, error in
			guard error == nil else { return }
			guard let user = user else { return }
			
			// 유저정보 가져오는 부분 구글에서 설정하기
			guard let name = user.profile?.name else { return }
			
			user.authentication.do { [self] authentication, error in
				guard error == nil else { return }
				guard let authentication = authentication else { return }
				
				guard let idToken = authentication.idToken else { return }
				
				print("idToken: \(idToken)")
			
				// 서버에 보낼 함수
				fetchData(url: "\(signInService.baseUrl)\(signInService.googlePath)", name: name, token: idToken)
			}
		}
	}
}
