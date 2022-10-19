//
//  DetailPostViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class PostViewerViewController: UIViewController {

    var tempPostData: TempPost?
    
    var formatter_time = DateFormatter()
    
    @IBOutlet weak var postViewerView: UIView!
    @IBOutlet weak var postViewerImageView: UIImageView!
    @IBOutlet weak var postViewerDateLabel: UILabel!
    @IBOutlet weak var postViewerTitleLabel: UILabel!
    @IBOutlet weak var postViewerDescriptionLabel: UILabel!
    @IBOutlet weak var postViewerStackView: UIStackView!
    @IBOutlet weak var postViewerEditDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setPost()
        setNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPost()
    }
    
    func setUI(){
        postViewerView.clipsToBounds = true
        postViewerView.layer.cornerRadius = 20
        postViewerView.layer.borderWidth = 0.5
        postViewerView.layer.borderColor = UIColor.black.cgColor /// Type이 달라서 공통 Color를 적용할 수 없었음.
        self.view.backgroundColor = UIColor.mainBGColor
    }
    func setNavigation(){
        self.navigationItem.leftBarButtonItem?.setBackgroundImage(UIImage(systemName: "back"), for: .normal, barMetrics: .default)
        if tempPostData == nil{
            guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
            postVC.postData = tempPostData
            postVC.delegate = self
            self.navigationController?.pushViewController(postVC, animated: false)
        }
    }
    
    func setPost(){
        guard var tempPostData = tempPostData else {return}
        postViewerImageView.image = tempPostData.postImage
        postViewerDateLabel.text = tempPostData.createDate.toString()
        postViewerEditDate.text = "최근 수정 : " + (tempPostData.editDate?.toString() ?? tempPostData.createDate.toString())
        postViewerTitleLabel.text = tempPostData.postTitle
        postViewerDescriptionLabel.text = tempPostData.postScript


    }
    


    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
        postVC.postData = tempPostData
        postVC.delegate = self
        self.navigationController?.pushViewController(postVC, animated: true)
    }
}
extension PostViewerViewController: TempPostDelegate{
    func update(){
        setPost()
    }
}
