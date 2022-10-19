//
//  HomePostCollectionViewCell.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/17.
//

import UIKit

class HomePostCollectionViewCell: UICollectionViewCell {
    
    var postData:TempPost?{
        didSet{
            guard var postData = postData else {
                return
            }
            cellImageView.image = postData.postImage ?? UIImage(named: "NoImage.png")
            cellTitleLabel.text = postData.createDate.toString()
            cellView.clipsToBounds = true
            cellView.layer.cornerRadius = 15
            cellView.layer.borderWidth = 1
            cellView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
}
