//
//  AppDelegate.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/09.
//

import UIKit
import KakaoSDKCommon
import GoogleSignIn
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// 네비게이션바 공통 스타일
		UINavigationBar.appearance().customNavigationBar()
	
		// kakao init
		KakaoSDK.initSDK(appKey: Config().kakaoAppKey)
		
        // google init - OAuth 2.0 클라이언트 ID
        GoogleSignIn.GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil{
                // Show the app's signed-out state.
            }else{
                // Show the app's signed-in state.
            }
        }
		
		// Naver init
		let instance = NaverThirdPartyLoginConnection.getSharedInstance()
		// 네이버 앱으로 인증하는 방식을 활성화
		instance?.isNaverAppOauthEnable = true
		// SafariViewController에서 인증하는 방식을 활성화
		instance?.isInAppOauthEnable = true
		// 애플리케이션을 등록할 때 입력한 URL Scheme
		instance?.serviceUrlScheme = Config().naverServiceAppUrlScheme
		// 애플리케이션 등록 후 발급받은 클라이언트 아이디
		instance?.consumerKey = Config().naverConsumerKey
		// 애플리케이션 등록 후 발급받은 클라이언트 시크릿
		instance?.consumerSecret = Config().naverConsumerSecret
		// 애플리케이션 이름
		instance?.appName = Config().naverServiceAppName
		
		return true
	}
	
	// 구글 handleUrl
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		GIDSignIn.sharedInstance.handle(url)
		NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
    func application(_ app: UIApplication, open url: URL, option: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        return true
    }


}

