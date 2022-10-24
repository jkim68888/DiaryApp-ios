//
//  CalendarTableViewCell.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/24.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    
    var postData: TempPost?{
        didSet{
            guard var postData = postData else {
                return
            }
            calendarImageView.image = postData.postImage
            calendarTitleLabel.text = postData.postTitle
            calendarDescriptionLabel.text = postData.postDescription
        }
    }
    
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var calendarTitleLabel: UILabel!
    @IBOutlet weak var calendarDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.backgroundColor = UIColor.mainBGColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
