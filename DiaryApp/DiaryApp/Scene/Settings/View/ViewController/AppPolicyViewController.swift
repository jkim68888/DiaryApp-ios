//
//  AppPolicyViewController.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/11/16.
//

import UIKit

class AppPolicyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.isUserInteractionEnabled = true
    }
	
	@IBAction func backButtonTapped(_ sender: UIButton) {
		self.dismiss(animated: true)
	}
	
}
