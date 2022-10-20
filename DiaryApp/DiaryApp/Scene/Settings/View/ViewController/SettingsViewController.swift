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
	
	@IBOutlet weak var myNameLabel: UILabel!
	@IBOutlet weak var snsImageView: UIImageView!
	@IBOutlet weak var snsTitleLabel: UILabel!
	@IBOutlet var containerViews: [UIView]!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		customBackButton(self: self, target: self.navigationController!)
    }
    
	func setUI() {
		self.title = "개인정보"
		
		view.backgroundColor = UIColor(hexString: "#FFDCDC")
		
		myNameLabel.text = "홍길동"
		
		snsImageView.image = UIImage(named: "signInIcon1")
		
		snsTitleLabel.text = "카카오 계정 사용중"
		
		containerViews.forEach {
			$0.layer.cornerRadius = 10
			$0.layer.masksToBounds = true
			$0.layer.borderWidth = 1
			$0.layer.borderColor = UIColor(hexString: "#999999").cgColor
		}
		
	}
	
	@IBAction func logoutButtonTapped(_ sender: UIButton) {
		signInService.getLogOut()
		goSingInVC()
	}
	
}
