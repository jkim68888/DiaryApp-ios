//
//  CalendarTableViewCell.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/24.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    
    var postData: Post?{
        didSet{
            guard var postData = postData else {
                return
            }
            if let image = postData.image.path {
                calendarImageView.load(url: URL(string: "http://" + image))
            }
            
            calendarTitleLabel.text = postData.title
            calendarDescriptionLabel.text = postData.body
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
    override func prepareForReuse() {
        calendarImageView.image = nil
    }

}
