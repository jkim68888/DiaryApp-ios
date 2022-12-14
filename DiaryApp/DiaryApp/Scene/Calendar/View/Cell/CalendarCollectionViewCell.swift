//
//  CalendarCollectionViewCell.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/21.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    var nowDate:String?
    var tempDate:Date?
     var count = 0
    var postData: Post?
    var postArray: [Post] = []{
        didSet{
//            var formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//
//            for item in postArray{
//                var item_date_string = formatter.string(from: item.createdAt)
//                guard var tempDate = tempDate else {return}
//                var nowCell_date_string = formatter.string(from: tempDate)
//  
//                if item_date_string == nowCell_date_string{
//                    count += 1
//                    print("💄실행됨")
//                }
//
//            }
            checkPoint.isHidden = false
//            if count != 0{
//                checkPoint.isHidden = false
//            }else{
//                checkPoint.isHidden = true
//            }
        }
    }
    
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                //nowDay.isHidden = false
                mainView.backgroundColor = UIColor.yellow
            }else{
                //nowDay.isHidden = true
                mainView.backgroundColor = UIColor.white
            }
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nowDay: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var checkPoint: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nowDay.translatesAutoresizingMaskIntoConstraints = false
        nowDay.topAnchor.constraint(equalTo: mainView.topAnchor, constant: -2).isActive = true
        nowDay.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -2).isActive = true
        nowDay.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: -2).isActive = true
        nowDay.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -2).isActive = true
        nowDay.alpha = 0.7
        nowDay.backgroundColor = UIColor.yellow
        
        checkPoint.backgroundColor = UIColor.mainFontColor
        checkPoint.clipsToBounds = true
        checkPoint.layer.cornerRadius = checkPoint.frame.width / 2
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        checkPoint.isHidden = true
    }
}
