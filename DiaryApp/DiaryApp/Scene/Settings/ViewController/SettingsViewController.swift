//
//  ProfileViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		customBackButton(self: self, target: self.navigationController!)
    }
    
	func setUI() {
		self.title = "개인정보"
		
		view.backgroundColor = UIColor(hexString: "#FFDCDC")
	}
}
