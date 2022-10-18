//
//  NavigationBarUtils.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/18.
//

import Foundation
import UIKit

func customBackButton(self: UIViewController, target: UINavigationController) {
	self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
															style: .plain,
															target: target,
															action: #selector(UINavigationController.popViewController(animated:)))
	
	// 네비바에 있는 back 버튼입니다
	// 뷰컨에 viewDidLoad() 에서 호출하면 됩니다
	// target은 self.navigationController!로 설정해서 사용히면 됩니당
}
