//
//  NicknameViewController.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/11/10.
//

import UIKit

class NicknameViewController: UIViewController {

	lazy var doneButton: UIBarButtonItem = {
		let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonTapped(_:)))
		
		return button
	}()
	
	@IBOutlet weak var nicknameTF: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		setTextField()
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func setTextField() {
		nicknameTF.delegate = self
		nicknameTF.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
	}

	func setUI() {
		self.navigationController?.navigationBar.customNavigationBar()
		customBackButton(self: self, target: self.navigationController!)
		doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "EF_Diary", size: 18)!], for: .normal)
		self.navigationItem.rightBarButtonItem = self.doneButton
		
		nicknameTF.layer.borderWidth = 1
		nicknameTF.layer.borderColor = UIColor.gray.cgColor
		nicknameTF.layer.cornerRadius = 8
		
		if let nickname = UserDefaults.standard.value(forKey: "nickname") as? String {
			nicknameTF.text = nickname
		}
	}
	
	// 완료 버튼
	@objc private func doneButtonTapped(_ sender: Any) {
		let nickname = nicknameTF.text
	
		if nickname == "" {
			showPopUp(title: "알림", message: "닉네임을 한글자 이상 입력해주세요!", attributedMessage: nil, leftActionTitle: "취소", rightActionTitle: "확인")
		} else {
			UserDefaults.standard.setValue(nickname, forKey: "nickname")
			changeRootVC()
		}
	}
}

extension NicknameViewController: UITextFieldDelegate {
	
	@objc private func textFieldValueChanged(textField: UITextField) {
		if textField.text?.count == 1 {
			if textField.text?.first == " " {
				textField.text = ""
				return
			}
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
}
