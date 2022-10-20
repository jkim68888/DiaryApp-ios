//
//  UINavigationBarExtension.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/18.
//

import Foundation
import UIKit

extension UINavigationBar {
	func customNavigationBar() {
		// 네비바 라벨 컬러 설정
        self.tintColor = UIColor.mainFontColor //기존 #7E76DE색과 동일
		// 네비바 라벨 폰트 설정
		self.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "EF_Diary", size: 18)!]
	}
}
