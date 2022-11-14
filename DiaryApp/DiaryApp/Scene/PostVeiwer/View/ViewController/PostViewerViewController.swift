//
//  DetailPostViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class PostViewerViewController: UIViewController {
	// MARK: - 백엔드 연동
	let postService = PostService.shared
	var post: Post?
    
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
	@IBOutlet weak var editButton: UIBarButtonItem!
	
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
        postViewerView.layer.cornerRadius = 15
        postViewerView.layer.borderWidth = 1
		postViewerView.layer.borderColor = UIColor(hexString: "#999999").cgColor
		
		editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "EF_Diary", size: 18)!], for: .normal)
        
        self.view.backgroundColor = UIColor.mainBGColor
        self.navigationController?.navigationBar.customNavigationBar()
    }
    
    /// 해당 View에서 사용하는 Data에 대한 Setting
    func setData(){
        /// Post에 대한 데이터가 없는 경우 -> Home에서 New Post Button을 누른 경우
        if post == nil{
            guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
            postVC.delegate = self
            self.navigationController?.pushViewController(postVC, animated: false)
        }
        /// Post에 대한 데이터가 있는 경우 -> Home에서 CollectionView의 Cell 누르고 접근하는 경우
        else{
            guard var post = post else {return}
            if let image = post.image.path{
                postViewerImageView.load(url: URL(string: "http://" + image))
            }
            
            postViewerDateLabel.text = post.createdAt.toString()
            postViewerTitleLabel.text = post.title
            postViewerDescriptionLabel.text = post.body
        }
//        if postViewerImageView.image == nil{
//            print("💄💄💄\nimage가 없습니다.")
//            postViewerStackView.translatesAutoresizingMaskIntoConstraints = false
//            postViewerStackView.topAnchor.constraint(equalTo: postViewerView.topAnchor,constant: 0).isActive = true
//        }
    }
	
	// MARK: - 백엔드 연동
//	func setData(id: String) {
//        if id == ""{
//            //만약 id가 ""이면
//            print("add버튼을 눌렀다.")
//        }
//        print("💄💄💄💄💄💄💄💄💄💄💄💄")
//		postService.getPostData(id: id) { [self] (success, data) in
//			self.post = data
//			print("getPost 성공 - \(data)")
//		}
//	}
	
	
    /// 수정 버튼을 눌렀을 때
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
        postVC.post = post
        postVC.image = postViewerImageView.image
        postVC.delegate = self
        self.navigationController?.pushViewController(postVC, animated: true)
    }
}
/// 커스텀 Delegate를 사용하는 부분
extension PostViewerViewController: TempPostDelegate{
    func update(){

//        setData()
    }
}

// MARK: - 백엔드 연동
extension PostViewerViewController: PostDelegate {
	func updatePost(id: String) {
		setData()
	}
}
