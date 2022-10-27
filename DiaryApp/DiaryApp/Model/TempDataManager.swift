//
//  TempDataManager.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/17.
//

import UIKit
class TempDataManager{
    static let shared = TempDataManager()
    var postArray:[TempPost]? = []
    
    func getPostDate() -> [TempPost]{
        return postArray!
    }
    
    func roadPostData(){
        postArray = [
            TempPost(userID: "momo", postTitle: "행복한 하루", postDescription:  "가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사.", postImage: UIImage(named: "dog.png"), createDate: Date()),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postDescription: "가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사.", postImage: UIImage(named: "cat.jpeg"), createDate: "2022.10.7".toDate()!),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postDescription: "가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사.", postImage: UIImage(named: "NoteBook.png"), createDate: "2022.10.11".toDate()!),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postDescription: "가을이였다....", postImage: UIImage(named: ""), createDate: "2022.10.16".toDate()!),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postDescription: "가을이였다....", postImage: UIImage(named: "Food.png"), createDate: "2022.10.2".toDate()!),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postDescription: "가을이였다....", postImage: UIImage(named: "Bear.png"), createDate: "2022.10.9".toDate()!),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postDescription: "가을이였다....", postImage: UIImage(named: "cat.jpeg"), createDate: "2022.10.13".toDate()!),
            TempPost(userID: "momo", postTitle: "즐거운 하루", postDescription: "가을이였다....", postImage: UIImage(named: "cat.jpeg"), createDate: "2022.10.21".toDate()!)
        ]
    }
    func addPostData(_ post: TempPost?){
        postArray?.append(post!)
    }
    func update(uniqueNum:Int,_ post:TempPost){
        postArray = postArray?.map{ return $0.postNumber == uniqueNum ? post : $0}

    }
    func delete(uniqueNum:Int){
        postArray = postArray?.filter{$0.postNumber != uniqueNum}
    }
}
