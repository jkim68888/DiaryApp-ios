//
//  DetailPostViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class PostViewerViewController: BaseViewController {
	var post: Post?
    var image: UIImage?
    
    @IBOutlet weak var postViewerView: UIView!
    @IBOutlet weak var postViewerImageView: UIImageView!
    @IBOutlet weak var postViewerDateLabel: UILabel!
    @IBOutlet weak var postViewerTitleLabel: UILabel!
    @IBOutlet weak var postViewerDescriptionLabel: UILabel!
    @IBOutlet weak var postViewerStackView: UIStackView!
    @IBOutlet weak var postViewerEditDate: UILabel!
	@IBOutlet weak var editButton: UIBarButtonItem!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
		customBackButton(self: self, target: self.navigationController!)
    }
    
    // MARK: - UI 세팅
    func setUI(){
        postViewerView.clipsToBounds = true
        postViewerView.layer.cornerRadius = 15
        postViewerView.layer.borderWidth = 1
		postViewerView.layer.borderColor = UIColor(hexString: "#999999").cgColor
		
		editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "EF_Diary", size: 18)!], for: .normal)
        
        self.view.backgroundColor = UIColor.mainBGColor
        self.navigationController?.navigationBar.customNavigationBar()
		
		postViewerImageView.image = image
		guard let post = post else { return }
		postViewerDateLabel.text = post.createdAt.toString()
		postViewerTitleLabel.text = post.title
		postViewerDescriptionLabel.text = post.body
		
		if postViewerImageView.image == nil {
			print("image가 없습니다!!")
			postViewerStackView.translatesAutoresizingMaskIntoConstraints = false
			postViewerStackView.topAnchor.constraint(equalTo: postViewerView.topAnchor,constant: 0).isActive = true
		}
    }
	
    // MARK: - 버튼 클릭
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
		postVC.viewModel.post = post
        postVC.image = postViewerImageView.image
        self.navigationController?.pushViewController(postVC, animated: true)
    }
}
