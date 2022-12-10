//
//  HomeViewModel.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation

class HomeViewModel {
	let postService = PostService.shared
	
	var postsList: [Post]?

	func getPostsList() {
		postService.getPostList(){ (success, data) in
			if success {
				self.postsList = data
				NotificationCenter.default.post(name: NSNotification.Name("getPostsListSuccess"), object: nil)
			}
			// 로그인 토큰이 만료되었을때, post api를 요청하면 bearer 토큰을 백엔드에 보낼 수 없어서 응답이 failure(false)로 들어옴
			// 이 경우, 로그아웃 시켜줌 (토큰 지우고 로그인뷰로 화면 전환)
			else {
				UserDefaults.standard.setValue("", forKey: "authVerificationID")
				changeRootVC()
			}
		}
	}
}
