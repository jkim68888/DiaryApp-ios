//
//  CalendarCollectionViewCell.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/21.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nowDay: UIView!
    @IBOutlet weak var mainView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        nowDay.translatesAutoresizingMaskIntoConstraints = false
        nowDay.topAnchor.constraint(equalTo: mainView.topAnchor, constant: -2).isActive = true
        nowDay.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -2).isActive = true
        nowDay.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: -2).isActive = true
        nowDay.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -2).isActive = true
        nowDay.alpha = 0.7

    }

}
