//
//  PostViewModel.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation

class PostViewModel {
	// 싱글톤 가져옴
	let postService = PostService.shared
	
	var post: Post?
}
