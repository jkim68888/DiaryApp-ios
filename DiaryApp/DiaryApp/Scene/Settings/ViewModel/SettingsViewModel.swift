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

class SettingsViewModel {
	// 로그아웃 로직
	func getLogOut() {
		UserApi.shared.logout {(error) in
			if let error = error {
				print(error)
			}
			else {
				print("logout() success.")
				goSingInVC()
			}
		}
	}
}
