//
//  RootViewUtils.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import UIKit

let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate

// storyboard, home뷰컨, signIn뷰컨을 전역에서 선언하면 안됨!
// 전역변수로 선언하면, 매번 새롭게 가져오고 기존의 것은 메모리에서 해제되지 않음
// 함수에 선언하면, 함수는 끝나면 내부의 모든게 메모리에서 해제되므로 레퍼런스 카운트가 제대로 체킹됨

func changeRootVC() {
	guard let window = sceneDelegate.window else { return }
	
	let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
	let homeViewController = storyboard.instantiateViewController(withIdentifier: "Home")
	let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
	let homeNavigationController = UINavigationController(rootViewController: homeViewController)
	
	// 로그인시 userDefaults에 저장되있는 토큰값에 따라 루트뷰 변경
	if UserDefaults.standard.value(forKey: "authVerificationID") != nil {
		window.rootViewController = homeNavigationController
	} else {
		window.rootViewController = signInViewController
	}
}
