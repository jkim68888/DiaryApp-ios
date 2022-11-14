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
extension UIImageView{
    func load(url: URL?){
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        print("이미지 설정 성공")
                        self?.image = image
                    }
                }
            }else{
                DispatchQueue.main.async{
                    print("이미지 설정 실패")
                    self?.image = UIImage(named: "NoImage.png")
                }
            }
        }
    }
}
