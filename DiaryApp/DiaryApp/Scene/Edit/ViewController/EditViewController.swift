//
//  DetailPostEditViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit
import PhotosUI

class EditViewController: UIViewController {

    @IBOutlet weak var detailPostEditImageView: UIImageView!
    @IBOutlet weak var detailPostEditDateLabel: UILabel!
    @IBOutlet weak var detailPostEditDatePicker: UIDatePicker!
    @IBOutlet weak var detailPostEditStackView: UIStackView!
    @IBOutlet weak var detailPostEditDateView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        제스처부여하기()
        //디자인세팅()
    }
    func 디자인세팅(){
        detailPostEditDateView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    func 제스처부여하기(){
        let tapGestureImageView = UITapGestureRecognizer(target: self, action: #selector(이미지를눌렀을때))
        detailPostEditImageView.addGestureRecognizer(tapGestureImageView) // 제스처를 추가....
        detailPostEditImageView.isUserInteractionEnabled = true // 유저와의 소통을 가능하게...

        let tapGestureDateLabel = UITapGestureRecognizer(target: self, action: #selector(달력을눌렀을때))
        detailPostEditDateLabel.addGestureRecognizer(tapGestureDateLabel) // 제스처를 추가....
        detailPostEditDateLabel.isUserInteractionEnabled = true // 유저와의 소통을 가능하게...
    }
    @objc func 이미지를눌렀을때(){
        ///피커뷰를 사용하기 위해서 configuration을 먼저 설정해준다.
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 //사진을 무한대로 가지고 올 수 있는... 1이면 1개만, 2는 2개만 가져온다.
        configuration.filter = .any(of: [.images, .videos]) // 지금은 사진과 비디오를 가져올 수 있게 설정하였다.
        /// 기본 설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        /// 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        /// 피커뷰 띄우기
        self.present(picker, animated: true,completion: nil)
    }
    @objc func 달력을눌렀을때(){
        detailPostEditStackView.isHidden = true
        detailPostEditDateView.isHidden = false
    }
    
}
extension EditViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.detailPostEditImageView.image = image as? UIImage
                }
            }
        }else {
            print("이미지를 불러올 수 없습니다.")
        }
    }
    
    
}
