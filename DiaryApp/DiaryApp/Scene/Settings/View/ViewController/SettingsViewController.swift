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
	
	let viewModel = SettingsViewModel()
	
	@IBOutlet weak var myNameLabel: UILabel!
	@IBOutlet weak var snsImageView: UIImageView!
	@IBOutlet weak var snsTitleLabel: UILabel!
	@IBOutlet var containerViews: [UIView]!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
    }
    
	func setUI() {
		self.title = "개인정보"
		customBackButton(self: self, target: self.navigationController!)
		
		view.backgroundColor = UIColor(hexString: "#FFDCDC")
		
		if let nickname = UserDefaults.standard.value(forKey: "nickname") as? String {
			myNameLabel.text = "\(nickname)님"
		}
		
		if let snsUserType = UserDefaults.standard.value(forKey: "snsUserType") as? String {
			
			switch snsUserType {
			case "apple":
				snsImageView.image = UIImage(named: "signInIcon0")
				snsTitleLabel.text = "애플 계정 사용중"
			case "kakao":
				snsImageView.image = UIImage(named: "signInIcon1")
				snsTitleLabel.text = "카카오 계정 사용중"
			case "google":
				snsImageView.image = UIImage(named: "signInIcon2")
				snsTitleLabel.text = "구글 계정 사용중"
			case "naver":
				snsImageView.image = UIImage(named: "signInIcon3")
				snsTitleLabel.text = "네이버 계정 사용중"
			default:
				break
			}
		}
	
		containerViews.forEach {
			$0.layer.cornerRadius = 10
			$0.layer.masksToBounds = true
			$0.layer.borderWidth = 1
			$0.layer.borderColor = UIColor(hexString: "#999999").cgColor
		}
		
	}
	
	@IBAction func logoutButtonTapped(_ sender: UIButton) {
		showPopUp(title: "로그아웃", message: "정말로 로그아웃 하시겠습니까?", attributedMessage: nil, leftActionTitle: "취소", rightActionTitle: "확인", rightActionCompletion:  {
			self.viewModel.getLogOut()
		})
	}
	
	@IBAction func changeNicknameButtonTapped(_ sender: UIButton) {
		guard let nicknameVC = storyboard?.instantiateViewController(identifier: "NicknameViewController") as? NicknameViewController else { return }
		self.navigationController?.pushViewController(nicknameVC, animated: true)
	}
	
	@IBAction func appPolicyButtonTapped(_ sender: UIButton) {
		guard let appPolicyVC = storyboard?.instantiateViewController(withIdentifier: "AppPolicyViewController") as? AppPolicyViewController else { return }
		self.present(appPolicyVC, animated: true, completion: nil)
	}
	
	@IBAction func privacyButtonTapped(_ sender: UIButton) {
		guard let privacyVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as? PrivacyViewController else { return }
		self.present(privacyVC, animated: true, completion: nil)
	}
}
