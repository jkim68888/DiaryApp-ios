//
//  ProfileSocialSignInViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController {
	@IBOutlet var signInButtons: [UIButton]!
    
	let viewModel = SignInViewModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		setNotification()
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
	}
	
	func setNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(didRecieveLoginSuccess(_:)), name: NSNotification.Name("loginSuccess"), object: nil)
	}
	
	func goNextVC() {
		guard let window = sceneDelegate.window else { return }
		
		guard let nicknameVC = storyboard?.instantiateViewController(identifier: "NicknameViewController") as? NicknameViewController else { return }
		guard let homeVC = storyboard?.instantiateViewController(identifier: "Home") as? HomeViewController else { return }
		let homeNavigationController = UINavigationController(rootViewController: homeVC)
		
		let authVerificationID = UserDefaults.standard.value(forKey: "nickname") as? String
		
		if authVerificationID == nil || authVerificationID == "" {
			self.navigationController?.pushViewController(nicknameVC, animated: false)
		} else {
			window.rootViewController = homeNavigationController
		}
	}
	
	// 로그인 완료시 다음 화면 이동
	@objc func didRecieveLoginSuccess(_ notification: Notification) {
		DispatchQueue.main.async {
			self.goNextVC()
		}
	}
	
	@IBAction func appleButtonTapped(_ sender: UIButton) {
		// viewModel.getAppleSignIn()
	}
	
	@IBAction func kakaoButtonTapped(_ sender: UIButton) {
		viewModel.getKakaoSignIn()
	}
	
	@IBAction func googleButtonTapped(_ sender: UIButton) {
		viewModel.getGoogleSignIn()
	}
	
	@IBAction func naverButtonTapped(_ sender: UIButton) {
		viewModel.getNaverSignIn()
	}
}
