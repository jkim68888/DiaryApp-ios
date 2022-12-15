//
//  PostViewModel.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import UIKit

class PostViewModel {
	// 싱글톤 가져옴
	let postService = PostService.shared
	
	var post: Post?
	
	func addPost(title: String, body: String, datetime: Date, image: UIImage) {
		postService.addPost(title: title, body: body, datetime: datetime, image: image) { (success, code) in
			print("addPost 결과 : \(code)")
            print("💄DEBUG:PostViewModel_\(datetime)")
			NotificationCenter.default.post(name: NSNotification.Name("addPostSuccess"), object: nil)
		}
	}
	
	func updatePost(title: String, body: String, datetime: Date, image: UIImage) {
		if let post = post {
			postService.updatePostData(post.id, title: title, body: body, datetime: datetime, image: image) {
				NotificationCenter.default.post(name: NSNotification.Name("updatePostSuccess"), object: nil)
			}
		}
	}
	
	func deletePost() {
		if let post = post {
			postService.deletePostData(post.id) {
				NotificationCenter.default.post(name: NSNotification.Name("deletePostSuccess"), object: nil)
			}
		}
	}
}
