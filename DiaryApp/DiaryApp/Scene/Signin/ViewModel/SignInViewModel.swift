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
import NaverThirdPartyLogin
import Alamofire

class SignInViewModel {
	// 싱글톤 가져옴
	let signInService = SignInService.shared

	var account: Account?
	var user: User?
	
    let googleSignInConfig = GIDConfiguration.init(clientID: Config().googleId)
	
	// 백엔드 서버 통신
	func fetchData(url: String, name: String, token: String, completion: @escaping () -> Void) {
		LoadingIndicator.showLoading()
		signInService.requestSignIn(url: url, name: name, accessToken: token) { [self] (success, data) in
			self.account = data
			print("(리퀘스트 성공) jwtToken - \(data.token)")
			
			UserDefaults.standard.setValue(true, forKey: "loginStatus")
			
			completion()
		}
	}
	
	// 카카오 로그인
	func getKakaoSignIn() {
		print(UserApi.isKakaoTalkLoginAvailable())
		
		UserDefaults.standard.setValue("kakao" , forKey: "snsUserType")
		
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
				fetchData(url: "\(signInService.baseUrl)\(signInService.kakaoPath)", name: name, token: token) {
					DispatchQueue.main.async {
						NotificationCenter.default.post(name: NSNotification.Name("loginSuccess"), object: nil, userInfo: nil)
						LoadingIndicator.hideLoading()
					}
				}
			}
		}
	}
	
	// 구글 로그인
	func getGoogleSignIn() {
		UserDefaults.standard.setValue("google" , forKey: "snsUserType")
		
		GIDSignIn.sharedInstance.signIn(with: self.googleSignInConfig, presenting: (UIApplication.shared.windows.first?.rootViewController)!) { user, error in
			guard error == nil else { return }
			guard let user = user else { return }
			
			guard let name = user.profile?.name else { return }
			
			print("구글 유저네임 \(name)")
			
			user.authentication.do { [self] authentication, error in
				guard error == nil else { return }
				guard let authentication = authentication else { return }
				
				guard let idToken = authentication.idToken else { return }
				
				print("idToken: \(idToken)")
			
				// 서버에 보낼 함수
				fetchData(url: "\(signInService.baseUrl)\(signInService.googlePath)", name: name, token: idToken) {
					DispatchQueue.main.async {
						NotificationCenter.default.post(name: NSNotification.Name("loginSuccess"), object: nil, userInfo: nil)
						LoadingIndicator.hideLoading()
					}
				}
			}
		}
	}
	
	// 네이버 로그인
	func getNaverSignIn() {
		UserDefaults.standard.setValue("naver" , forKey: "snsUserType")
		
		let instance = NaverThirdPartyLoginConnection.getSharedInstance()
	
		instance?.requestThirdPartyLogin()
		
		guard let tokenType = instance?.tokenType else { return }
		guard let accessToken = instance?.accessToken else { return }
		let url = "https://openapi.naver.com/v1/nid/me"
		
		AF.request(url,
				   method: .get,
				   encoding: JSONEncoding.default,
				   headers: ["Authorization": "\(tokenType) \(accessToken)"]
		).responseJSON { response in
			guard let result = response.value as? [String: Any] else { return }
			guard let object = result["response"] as? [String: Any] else { return }
			
			guard let name = object["name"] as? String else { return }
	
			print("네이버 유저네임 \(name)")
				
			// 서버에 보낼 함수
			self.fetchData(url: "\(self.signInService.baseUrl)\(self.signInService.naverPath)", name: name, token: accessToken) {
				DispatchQueue.main.async {
					NotificationCenter.default.post(name: NSNotification.Name("loginSuccess"), object: nil, userInfo: nil)
					LoadingIndicator.hideLoading()
				}
			}
		}
	}
	
}
