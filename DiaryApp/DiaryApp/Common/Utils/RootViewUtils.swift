//
//  RootViewUtils.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/19.
//

import UIKit

// window 객체 사용하기 위해서 싱글톤패턴으로 sceneDelegate 생성
let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate

let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
let homeViewController = storyboard.instantiateViewController(withIdentifier: "Home")
let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
let homeNavigationController = UINavigationController(rootViewController: homeViewController)

// 로그인시 userDefaults에 저장되있는 키값에 따라 루트뷰 변경
func manageSignInSession() {
	guard let window = sceneDelegate.window else { return }
	
	if UserDefaults.standard.bool(forKey: "authVerificationID") {
		window.rootViewController = homeNavigationController
	} else {
		window.rootViewController = signInViewController
	}
}

// 로그인 완료시 홈으로 루트뷰 바꿔줌
func goHomeVC() {
	guard let window = sceneDelegate.window else { return }
	
	window.rootViewController = homeNavigationController
}
