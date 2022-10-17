//
//  TempDataManager.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/17.
//

import UIKit
class TempDataManager{
    var postArray:[TempPost]? = []
    
    func getPostDate() -> [TempPost]{
        return postArray!
    }
    
    func roadPostData(){
        postArray = [
            TempPost(userID: "momo", postTitle: "행복한 하루", postScrpit: "여름이였다....", postImage: UIImage(named: "dog.jpeg"), createDate: Date()),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postScrpit: "가을이였다....", postImage: UIImage(named: "cat.jpeg"), createDate: Date()),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postScrpit: "가을이였다....", postImage: UIImage(named: "cat.jpeg"), createDate: Date()),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postScrpit: "가을이였다....", postImage: UIImage(named: "cat.jpeg"), createDate: Date()),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postScrpit: "가을이였다....", postImage: UIImage(named: "cat.jpeg"), createDate: Date()),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postScrpit: "가을이였다....", postImage: UIImage(named: "cat.jpeg"), createDate: Date()),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postScrpit: "가을이였다....", postImage: UIImage(named: "cat.jpeg"), createDate: Date()),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postScrpit: "가을이였다....", postImage: UIImage(named: "cat.jpeg"), createDate: Date())
        ]
    }
    func addPostData(_ post: TempPost){
        postArray?.append(post)
    }
    func update(index:Int,_ post:TempPost){
        postArray?[index] = post
    }
}
