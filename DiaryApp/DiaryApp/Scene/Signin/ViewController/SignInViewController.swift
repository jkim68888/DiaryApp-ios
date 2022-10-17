//
//  ProfileSocialSignInViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class SignInViewController: UIViewController {
	
	// window 객체 사용하기 위해서 싱글톤패턴으로 sceneDelegate 생성
	let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
	
	@IBOutlet var signInButtons: [UIButton]!
	@IBOutlet weak var titleLabel: UILabel!
	
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
		}
		
		// 라벨 컬러 설정
		titleLabel.textColor = UIColor(hexString: "#7E76DE")
	}
	
	// 로그인 로직
	func getSignIn() {
		// userDefaults 에 로그인 식별하기 위한 키값 저장
		// 앱을 껐다켜도 로그인 유지
		UserDefaults.standard.setValue(true, forKey: "authVerificationID")
		UserDefaults.standard.synchronize()
		
		let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
		let homeViewController = storyboard.instantiateViewController(withIdentifier: "Home")
		let homeNavigationController = UINavigationController(rootViewController: homeViewController)
		
		guard let window = sceneDelegate.window else { return }
		
		// 로그인 완료시 루트뷰 바꿔줌
		window.rootViewController = homeNavigationController
	}
	
	@IBAction func appleButtonTapped(_ sender: UIButton) {
		getSignIn()
		
		print("애플 로그인함: ", UserDefaults.standard.value(forKey: "authVerificationID")!)
	}
	
	@IBAction func kakaoButtonTapped(_ sender: UIButton) {
		getSignIn()
		
		print("카카오 로그인함: ", UserDefaults.standard.value(forKey: "authVerificationID")!)
	}
	
	@IBAction func googleButtonTapped(_ sender: UIButton) {
		getSignIn()
		
		print("구글 로그인함: ", UserDefaults.standard.value(forKey: "authVerificationID")!)
	}
	
	@IBAction func naverButtonTapped(_ sender: UIButton) {
		getSignIn()
		
		print("네이버 로그인함: ", UserDefaults.standard.value(forKey: "authVerificationID")!)
	}
}
