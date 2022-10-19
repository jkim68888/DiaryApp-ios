//
//  ProfileViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class SettingsViewController: UIViewController {
	// 싱글톤 가져옴
	let signInService = SignInService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		customBackButton(self: self, target: self.navigationController!)
    }
    
	func setUI() {
		self.title = "개인정보"
		
		view.backgroundColor = UIColor(hexString: "#FFDCDC")
	}
	
	@IBAction func logoutButtonTapped(_ sender: UIButton) {
		signInService.getLogOut()
		goSingInVC()
	}
	
}
