//
//  HomeViewModel.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation

class HomeViewModel {
	let postService = PostService.shared
	
	var user: User?
	
	func fetchHomeData() {
		guard let token = UserDefaults.standard.value(forKey: "authVerificationID") as? String else { return }
		
		self.postService.requestHome(accessToken: token) { (success, data) in
			print("성공🌟\(data.name)")
			self.user = User.init(name: data.name)
			
			UserDefaults.standard.setValue(data.name , forKey: "userName")
			UserDefaults.standard.synchronize()
			
			// 홈뷰컨으로 데이터 전달하기 위한 notification
			NotificationCenter.default.post(name: NSNotification.Name("fetchHomeSuccess"), object: nil, userInfo: nil)
		}
	}
}
