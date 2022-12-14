//
//  CalendarViewModel.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import Foundation

class CalendarViewModel {
    let postService = PostService.shared
    
    var postArray: [Post] = [] // home에서 Load해온 Posts데이터를 calendar에서 받아올때, 여기에 저장
    var tableCellPostArray: [Post] = []
    
}
