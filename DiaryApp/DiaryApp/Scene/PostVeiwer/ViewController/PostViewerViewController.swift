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
    @IBOutlet weak var postViewerEditDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setPost()
        setNavigation()
    }
    func setDateFormat(_ date:Date) -> String{
        formatter_time.dateFormat = "yyyy.MM.dd"
        var current_time_string = formatter_time.string(from: date)
        return current_time_string
    }
    func setUI(){
        postViewerView.clipsToBounds = true
        postViewerView.layer.cornerRadius = 20
        postViewerView.layer.borderWidth = 0.5
        postViewerView.layer.borderColor = UIColor.black.cgColor
        self.view.backgroundColor = UIColor(hexString: "#FFBBBC")
    }
    func setNavigation(){
        self.navigationItem.leftBarButtonItem?.setBackgroundImage(UIImage(systemName: "back"), for: .normal, barMetrics: .default)
    }
    
    func setPost(){
        guard var tempPostData = tempPostData else {return}
        postViewerImageView.image = tempPostData.postImage
        postViewerDateLabel.text = setDateFormat(tempPostData.createDate)
        postViewerEditDate.text = "최근 수정 : " + setDateFormat(tempPostData.editDate ?? tempPostData.createDate)
        postViewerTitleLabel.text = tempPostData.postTitle
        postViewerDescriptionLabel.text = tempPostData.postScript

    }
    


    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
        
        self.navigationController?.pushViewController(postVC, animated: true)
    }
}
