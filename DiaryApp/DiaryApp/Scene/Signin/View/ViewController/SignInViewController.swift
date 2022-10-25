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
    @IBOutlet weak var googleSignButton: GIDSignInButton!
    @IBOutlet weak var titleLabel: UILabel!
	
    let signInConfig = GIDConfiguration.init(clientID: "26123316352-qog5eiia1daeme2ohk62dgm9erms73u7.apps.googleusercontent.com")
    
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
    
    func getGoogleSignIn() {
        GIDSignIn.sharedInstance.signIn(with: self.signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            user.authentication.do { [self] authentication, error in
                guard error == nil else { print(error); return }
                guard let authentication = authentication else { return }
                let idToken = authentication.idToken
                // Send ID token to backend (example below)
                // 서버에 보낼 함수
                tokenSign(idToken: idToken!)
                
            }
        }
    }
    func tokenSign(idToken:String){
        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else{ return }
        let url = URL(string: "http://localhost:4000/api/auth/callback/google")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            //Handle response from your backend.
            print(response)
        }
        task.resume()
        goHomeVC()
    }
	
	@IBAction func appleButtonTapped(_ sender: UIButton) {
		
	}
	
	@IBAction func kakaoButtonTapped(_ sender: UIButton) {
		viewModel.getKakaoSignIn()
	}
	
	@IBAction func googleButtonTapped(_ sender: UIButton) {
        getGoogleSignIn()
	}
	
	@IBAction func naverButtonTapped(_ sender: UIButton) {
		
	}
}

