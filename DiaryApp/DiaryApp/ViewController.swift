//
//  ViewController.swift
//  DiaryApp
//
//  Created by 김지현 on 2022/10/09.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var homeInfoView: UIView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    override func viewDidLoad() {
		super.viewDidLoad()
		homeViewSetting()
	}
    func homeViewSetting(){
        homeInfoView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        homeInfoView.clipsToBounds = true
        homeInfoView.layer.cornerRadius = 15
    }


}
extension ViewController: UICollectionViewDataSource{
    // 컬렉션 뷰 내부의 셀의 개수를 지정한다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    // 컬렉션 뷰 내부의 셀의 내용을 세팅하는 부분, 여기서 직접 주거나, Cell파일에서 didSet(속성감시자)을 통해 초기세팅을 줄 수 있다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
//extension ViewController: UICollectionViewDelegate{
//    // Collection의 항목을 선택 했을 경우, 발생하는 이벤트
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
//}
