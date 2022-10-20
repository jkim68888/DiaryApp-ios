//
//  DetailPostViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class PostViewerViewController: UIViewController {
    
    /// [글보기]View에서 post Data를 담고있는 변수
    var tempPostData: TempPost?
    /// 수정한 시간을 담고있는 변수
    var formatter_time = DateFormatter()
    
    @IBOutlet weak var postViewerView: UIView!
    @IBOutlet weak var postViewerImageView: UIImageView!
    @IBOutlet weak var postViewerDateLabel: UILabel!
    @IBOutlet weak var postViewerTitleLabel: UILabel!
    @IBOutlet weak var postViewerDescriptionLabel: UILabel!
    @IBOutlet weak var postViewerStackView: UIStackView!
    @IBOutlet weak var postViewerEditDate: UILabel!
    
    /// View가 Load된 후에 실행되는 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setData()
        customBackButton(self: self, target: self.navigationController!)
    }
    
    /// setUI: 해당 View에서의 UI를 Setting
    func setUI(){
        postViewerView.clipsToBounds = true
        postViewerView.layer.cornerRadius = 20
        postViewerView.layer.borderWidth = 0.5
        postViewerView.layer.borderColor = UIColor.black.cgColor /// Type이 달라서 공통 Color를 적용할 수 없었음.
        
        self.view.backgroundColor = UIColor.mainBGColor
        self.navigationController?.navigationBar.customNavigationBar()
    }
    
    /// 해당 View에서 사용하는 Data에 대한 Setting
    func setData(){
        /// Post에 대한 데이터가 없는 경우 -> Home에서 New Post Button을 누른 경우
        if tempPostData == nil{
            guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
            postVC.delegate = self
            self.navigationController?.pushViewController(postVC, animated: false)
        }
        /// Post에 대한 데이터가 있는 경우 -> Home에서 CollectionView의 Cell 누르고 접근하는 경우
        else{
        guard var tempPostData = tempPostData else {return}
            postViewerImageView.image = tempPostData.postImage
            postViewerDateLabel.text = tempPostData.createDate.toString()
            postViewerEditDate.text = "최근 수정 : " + (tempPostData.editDate?.toString() ?? tempPostData.createDate.toString())
            postViewerTitleLabel.text = tempPostData.postTitle
            postViewerDescriptionLabel.text = tempPostData.postScript
        }

    }
    /// 수정 버튼을 눌렀을 때
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
        postVC.postData = tempPostData
        postVC.delegate = self
        self.navigationController?.pushViewController(postVC, animated: true)
    }
}
/// 커스텀 Delegate를 사용하는 부분
extension PostViewerViewController: TempPostDelegate{
    func update(){
        setData()
    }
}
