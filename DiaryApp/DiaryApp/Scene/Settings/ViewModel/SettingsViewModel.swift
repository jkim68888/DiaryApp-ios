//
//  SettingsViewModel.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth
import GoogleSignIn
import NaverThirdPartyLogin

class SettingsViewModel {
	let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
	// 로그아웃 로직
	func getLogOut() {
		if let snsUserType = UserDefaults.standard.value(forKey: "snsUserType") as? String {
			
			switch snsUserType {
//			case "apple":
				
			case "kakao":
				UserApi.shared.logout {(error) in
					if let error = error {
						print(error)
					}
					else {
						print("logout() success.")
					}
				}
			case "google":
				GIDSignIn.sharedInstance.signOut()
			case "naver":
				loginInstance?.requestDeleteToken()
			default:
				break
			}
		}
		
		UserDefaults.standard.setValue(nil, forKey: "authVerificationID")
		UserDefaults.standard.setValue(nil, forKey: "userName")
		UserDefaults.standard.setValue(nil, forKey: "snsUserType")
		UserDefaults.standard.synchronize()
		
		changeRootVC()
	}
}
