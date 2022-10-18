//
//  CalendarViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/13.
//

import UIKit

class CalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		customBackButton(self: self, target: self.navigationController!)
    }

	func setUI() {
		self.title = "캘린더"
	}
}
