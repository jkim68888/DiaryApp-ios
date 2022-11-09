//
//  BaseViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/11/09.
//

import UIKit
import Toast_Swift

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopup(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.AUTH_FAIL), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 인증 실패 노티피케이션 등록 해제
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: NOTIFICATION.AUTH_FAIL),object: nil )
    }
    
    @objc func showErrorPopup(notification: NSNotification){
        print("BaseVC - showErrorPopup()")
        if let data = notification.userInfo?["statusCode"]{
            print("showErrorPopup() data: \(data)")
            // 메인 쓰레드에서 돌리기
            DispatchQueue.main.async {
                self.view.makeToast("네트워크 통신상에\n문제가 발생했습니다.\n😱\(data)에러입니다.",duration:3.0,position:.center)
            }
            
            
        }
    }

}
