//
//  UIButtonExtension.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/15.
//

import Foundation
import UIKit

extension UIButton {
	
	func setLeftImageCenterTitle(imageName: String, padding: CGFloat) {
		// 이미지 세팅
		let image: UIImage? = UIImage(named: imageName)
		guard let img = image else { return }
		self.setImage(img, for: .normal)
		
		// insets 계산
		let imageWidth = img.size.width
		let textWidth = self.titleLabel?.intrinsicContentSize.width
		let buttonWidth = self.bounds.width
		let imageInset = buttonWidth - textWidth! - imageWidth - padding
		let titleInset = padding + imageWidth
	
		// 이미지 insets
		self.imageEdgeInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: imageInset)
		// 타이틀 insets
		self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: titleInset)
	}
}
