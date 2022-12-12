//
//  ProfileSocialSignInViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit
import AuthenticationServices

class SignInViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return self.view.window!
	}
	
	@IBOutlet var signInButtons: [UIButton]!
    
	let viewModel = SignInViewModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		setNotification()
    }
	
	// MARK: - UI 세팅
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
	
	// MARK: - 다음화면 설정
	// 로그인 후 닉네임 존재 여부에 따라 다음 화면 설정
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
	
	func setNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(didRecieveLoginSuccess(_:)), name: NSNotification.Name("loginSuccess"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(didRecieveloginFail(_:)), name: NSNotification.Name("loginFail"), object: nil)
	}
	
	// 로그인 완료 노티피케이션 받으면, 다음 화면으로 이동
	@objc func didRecieveLoginSuccess(_ notification: Notification) {
		DispatchQueue.main.async {
			self.goNextVC()
		}
	}
	
	// 로그인 실패 노티피케이션 받으면, 토스트 띄움
	@objc func didRecieveloginFail(_ notification: Notification) {
		DispatchQueue.main.async {
			LoadingIndicator.hideLoading()
			self.view.makeToast("네트워크 통신상에 문제가 발생했습니다😱", duration: 5.0, position: .center)
		}
	}
	
	// Apple ID 연동 성공 시
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		switch authorization.credential {
		// Apple ID
		case let appleIDCredential as ASAuthorizationAppleIDCredential:
			
			// 계정 정보 가져오기
			let userIdentifier = appleIDCredential.user
			let fullName = appleIDCredential.fullName
			
			print("User ID : \(userIdentifier)")
			print("User Name : \((fullName?.givenName ?? ""))")
			
			viewModel.getAppleSignIn(name: fullName?.givenName ?? "", token: userIdentifier)
	
		default:
			break
		}
	}
	
	// Apple ID 연동 실패 시
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
			// Handle error.
	}
	
	// MARK: - 로그인 버튼 클릭
	@IBAction func appleButtonTapped(_ sender: UIButton) {
		LoadingIndicator.showLoading()
		
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.fullName, .email]
		
		let authorizationController = ASAuthorizationController(authorizationRequests: [request])
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self
		authorizationController.performRequests()
	}
	
	@IBAction func kakaoButtonTapped(_ sender: UIButton) {
		LoadingIndicator.showLoading()
		viewModel.getKakaoSignIn()
	}
	
	@IBAction func googleButtonTapped(_ sender: UIButton) {
		LoadingIndicator.showLoading()
		viewModel.getGoogleSignIn()
	}
	
	@IBAction func naverButtonTapped(_ sender: UIButton) {
		LoadingIndicator.showLoading()
		viewModel.getNaverSignIn()
	}
}
