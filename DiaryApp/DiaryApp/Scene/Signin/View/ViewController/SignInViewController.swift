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
	
	func goNicknameVC() {
		guard let nicknameVC = storyboard?.instantiateViewController(identifier: "NicknameViewController") as? NicknameViewController else { return }
		self.navigationController?.pushViewController(nicknameVC, animated: false)
	}
	
	// 로그인이 success면 콜렉션뷰 다시 그림 (바인딩된 데이터로 그리기 위함)
	@objc func didRecieveLoginSuccess(_ notification: Notification) {
		DispatchQueue.main.async {
			self.goNicknameVC()
		}
	}
	
	@IBAction func appleButtonTapped(_ sender: UIButton) {
        goHomeVC()
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
	
    func goHomeVC() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        
        guard let window = sceneDelegate.window else { return }
        
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "Home")
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        
        window.rootViewController = homeNavigationController
    }
}
