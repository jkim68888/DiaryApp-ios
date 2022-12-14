//
//  StringExtension.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/18.
//

import Foundation
import UIKit

extension String {
    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    func testToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년MM월dd일 HH시mm분ss초"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    func toDate_Calendar() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
	
	func toImage() -> UIImage? {
		if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
			return UIImage(data: data)
		}
		return nil
	}
}
