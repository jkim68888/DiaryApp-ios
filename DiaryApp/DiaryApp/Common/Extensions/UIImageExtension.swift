//
//  UIImageExtension.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/29.
//

import Foundation
import UIKit

extension UIImage {
	func toPngString() -> String? {
		let data = self.pngData()
		return data?.base64EncodedString(options: .endLineWithLineFeed)
	}
	
	func toJpegString(compressionQuality cq: CGFloat) -> String? {
		let data = self.jpegData(compressionQuality: cq)
		return data?.base64EncodedString(options: .endLineWithLineFeed)
	}
}
