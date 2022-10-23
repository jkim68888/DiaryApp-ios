//
//  ProfileSocialSignInViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class SignInViewController: UIViewController {
	@IBOutlet var signInButtons: [UIButton]!
	@IBOutlet weak var titleLabel: UILabel!
	
	let viewModel = SignInViewModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
    }
	
	// 왼쪽이미지 가운데타이틀 설정 (extension 사용)
	func setButtonsStyle(index: Int, item: UIButton) {
		return item.setLeftImageCenterTitle(imageName: "signInIcon\(index)", padding: 10)
	}
	
	func setUI() {
		// 로그인 버튼 스타일 설정
		signInButtons.enumerated().forEach { (index, item) in
			setButtonsStyle(index: index, item: item)
			item.layer.cornerRadius = 5
			item.clipsToBounds = true
			item.layer.borderWidth = 1
			item.layer.borderColor = UIColor(hexString: "#999999").cgColor
		}
		
		// 라벨 컬러 설정
		titleLabel.textColor = UIColor(hexString: "#7E76DE")
	}
	
	@IBAction func appleButtonTapped(_ sender: UIButton) {

	}
	
	@IBAction func kakaoButtonTapped(_ sender: UIButton) {
		viewModel.getKakaoSignIn()
	}
	
	@IBAction func googleButtonTapped(_ sender: UIButton) {
		
	}
	
	@IBAction func naverButtonTapped(_ sender: UIButton) {
		
	}
}
