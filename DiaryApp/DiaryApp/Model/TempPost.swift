//
//  TempPost.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/17.
//

import UIKit
protocol TempPostDelegate:AnyObject{
    func update()
}
struct TempPost{
    static var postNumCount:Int = 0
    var userID:String
    var postNumber:Int
    var postTitle:String
    var postScript:String
    var postImage:UIImage?
    var createDate:Date
    var editDate:Date?
    
    init(userID:String,postTitle:String,postScrpit:String,postImage:UIImage?,createDate:Date){
        postNumber = TempPost.postNumCount
        self.userID = userID
        self.postTitle = postTitle
        self.postScript = postScrpit
        self.postImage = postImage
        self.createDate = createDate
        TempPost.postNumCount += 1
    }
}
