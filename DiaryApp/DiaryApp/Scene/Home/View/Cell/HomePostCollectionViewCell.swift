//
//  HomePostCollectionViewCell.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/17.
//

import UIKit

class HomePostCollectionViewCell: UICollectionViewCell {
	
	var post: Post? {
		didSet {
            guard let post = post else {
                return
            }
			
			if let image = post.image.path {
				cellImageView.load(url: URL(string: image))
			} else {
				cellImageView.image = UIImage(named: "NoImage.png")
			}
            
			cellTitleLabel.text = post.createdAt.toString()
			cellView.clipsToBounds = true
			cellView.layer.cornerRadius = 10
			cellView.layer.borderWidth = 1
			cellView.layer.borderColor = UIColor(hexString: "#999999").cgColor
            
		}
	}
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
}

