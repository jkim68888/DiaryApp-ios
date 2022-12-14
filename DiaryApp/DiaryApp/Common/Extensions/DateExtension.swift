//
//  DateExtension.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/18.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        //dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        return dateFormatter.string(from: self)
    }
    func toString_Calendar() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        return dateFormatter.string(from: self)
    }
    func toString_Long() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        return dateFormatter.string(from: self)
    }
    func toString_Calendar_NowDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self)
    }
    func toData() -> Data {
        let timestamp = self.timeIntervalSinceReferenceDate
        return withUnsafeBytes(of: timestamp) { Data($0) }
    }
}
