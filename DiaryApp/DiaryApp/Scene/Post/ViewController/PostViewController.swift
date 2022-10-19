//
//  PostViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/14.
//

import UIKit
import PhotosUI

class PostViewController: UIViewController {
    
    var postData: TempPost?
    var postNumber:Int? = 0
    var pickImage:UIImage? = nil
    var editFormatter_time = DateFormatter()
    var delegate:TempPostDelegate?
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageBtn: UIButton!
    @IBOutlet weak var postStackView: UIStackView!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postTitleTF: UITextField!
    @IBOutlet weak var postScriptTV: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setUI()
        setGesture()
        setImagePickView()
        // Do any additional setup after loading the view.
    }
    func setDateFormat(_ date:Date) -> String{
        editFormatter_time.dateFormat = "yyyy.MM.dd"
        var current_time_string = editFormatter_time.string(from: date)
        return current_time_string
    }
    func setData(){
        guard var postData = postData else { return }
        //postNumber는 해당 Post의 고유 번호이다. 수정하거나 삭제할때 필요하다.
        postNumber = postData.postNumber
        
        // 기본적인 Post 정보에 담길 내용을 Setting해준다.
        print(#function)
        postImageView.image = postData.postImage
        postDateLabel.text = setDateFormat(postData.createDate)
        postTitleTF.text = postData.postTitle
        postScriptTV.text = postData.postScript
        
    }
    func setUI(){
        postImageBtn.setTitle("", for: .normal)
        postImageBtn.clipsToBounds = true
        postImageBtn.layer.cornerRadius = 10
        postImageBtn.layer.borderWidth = 1
        postImageBtn.layer.borderColor = UIColor.black.cgColor
        
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 10
        postImageView.layer.borderWidth = 1
        postImageView.layer.borderColor = UIColor.black.cgColor
        
        postTitleTF.borderStyle = .none
    }
    func setImagePickView(){
        print(#function)
        if postImageView.image == nil{
            postImageView.isHidden = true
            print("값이없다.")
        }else{
            postImageView.isHidden = false
        }
    }
    func setGesture(){
        let tapGestureDateLabel = UITapGestureRecognizer(target: self, action: #selector(달력을눌렀을때))
        postDateLabel.addGestureRecognizer(tapGestureDateLabel) // 제스처를 추가....
        postDateLabel.isUserInteractionEnabled = true // 유저와의 소통을 가능하게...
    }

    @objc func 달력을눌렀을때(){
//        postStackView.isHidden = true
//        postDateView.isHidden = false
    }
    
    @IBAction func postImagePickButtonTapped(_ sender: UIButton) {
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
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard var postData = postData else {
            return
        }
        print(postData.postTitle)
        print(postData.postScript)
        postData.postImage = postImageView.image
        postData.createDate = postDateLabel.text!.toDate() ?? Date()
        postData.postTitle = postTitleTF.text ?? ""
        postData.postScript = postScriptTV.text ?? ""
        
        let postViewerVCindex = navigationController!.viewControllers.count - 2
        let homeVCindex = navigationController!.viewControllers.count - 3
        
        let postViewerVC = navigationController?.viewControllers[postViewerVCindex] as! PostViewerViewController
        let homeVC = navigationController?.viewControllers[homeVCindex] as! HomeViewController
        
        delegate?.update()
        
        postViewerVC.tempPostData = postData
        homeVC.dataManager.update(index: postNumber!, postData)
        self.presentingViewController?.dismiss(animated: true)
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
                    self.postImageView.isHidden = false
                }
            }
        }else {
            print("이미지를 불러올 수 없습니다.")
        }
    }
    
    
}
