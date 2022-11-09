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
        if url == nil{
            DispatchQueue.main.async {
                self.image = UIImage(named: "NoImage.png")
            }
        }
        else{
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!){
                    if let image = UIImage(data: data){
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
            }
            
        }
    }
}
