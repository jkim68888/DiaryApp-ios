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

// 로그인시 userDefaults에 저장되있는 키값에 따라 루트뷰 변경
func manageSignInSession() {
	guard let window = sceneDelegate.window else { return }
	
	let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
	let homeViewController = storyboard.instantiateViewController(withIdentifier: "Home")
	let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
	let homeNavigationController = UINavigationController(rootViewController: homeViewController)
	
//	var userData: UserData?
//	var user: User?
//
//	if user?.token != nil {
//		window.rootViewController = homeNavigationController
//	} else {
//		window.rootViewController = signInViewController
//	}
}

// 로그인 완료시 홈으로 루트뷰 바꿔줌
func goHomeVC() {
	guard let window = sceneDelegate.window else { return }

	let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
	let homeViewController = storyboard.instantiateViewController(withIdentifier: "Home")
	let homeNavigationController = UINavigationController(rootViewController: homeViewController)
	
	window.rootViewController = homeNavigationController
}

// 로그아웃 완료시 SignIn으로 루트뷰 바꿔줌
func goSingInVC() {
	guard let window = sceneDelegate.window else { return }
	
	let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
	let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
	
	window.rootViewController = signInViewController
}
