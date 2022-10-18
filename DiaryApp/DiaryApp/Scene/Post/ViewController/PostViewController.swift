//
//  PostViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/14.
//

import UIKit
import PhotosUI

class PostViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postStackView: UIStackView!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postDateView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        제스처부여하기()

        // Do any additional setup after loading the view.
    }
    func setUI(){
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 10
    }
    func 제스처부여하기(){
        let tapGestureImageView = UITapGestureRecognizer(target: self, action: #selector(이미지를눌렀을때))
        postImageView.addGestureRecognizer(tapGestureImageView) // 제스처를 추가....
        postImageView.isUserInteractionEnabled = true // 유저와의 소통을 가능하게...

        let tapGestureDateLabel = UITapGestureRecognizer(target: self, action: #selector(달력을눌렀을때))
        postDateLabel.addGestureRecognizer(tapGestureDateLabel) // 제스처를 추가....
        postDateLabel.isUserInteractionEnabled = true // 유저와의 소통을 가능하게...
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
        postStackView.isHidden = true
        postDateView.isHidden = false
    }
    
}
extension PostViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.postImageView.image = image as? UIImage
                }
            }
        }else {
            print("이미지를 불러올 수 없습니다.")
        }
    }
    
    
}
