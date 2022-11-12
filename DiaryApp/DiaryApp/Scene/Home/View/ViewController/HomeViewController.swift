//
//  HomeViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit


class HomeViewController: BaseViewController {
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var addPostBtn: UIButton!
	
	let viewModel = HomeViewModel()
	
	// MARK: - 백엔드 연동
	let postService = PostService.shared
	var postsList: [Post]?
	
    let flowLayout = UICollectionViewFlowLayout()
    let dataManager = TempDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
		setNotification()
        setUI()
		setData()
        setCollectionView()
    }
	
    // 현재View(homeVC)가 보이려고할 때,
    /// 1. 네비게이션 바를 임의적으로 숨긴다.
    /// 2. CollectionView를 초기화(reload)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        homeCollectionView.reloadData()
    }
    // View가 사라지려고 할 때, 네비게이션 바를 임의적으로 보이게한다.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
	
    func setUI(){
		addPostBtn.setTitle("", for: .normal)
        addPostBtn.clipsToBounds = true
        addPostBtn.layer.cornerRadius = addPostBtn.frame.width / 2
		addPostBtn.layer.shadowOpacity = 0.25
		addPostBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
		addPostBtn.layer.shadowRadius = 4
		addPostBtn.layer.masksToBounds = false
    }
	
	func setNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(didRecieveGoHomeSuccess(_:)), name: NSNotification.Name("goHomeSuccess"), object: nil)
	}
    
    func setCollectionView(){
        let itemsPerRow: CGFloat = 2
        let textAreaHeight: CGFloat = 35
        let itemSpacing: CGFloat = 16
        let collectionViewInsets: CGFloat = 32
        let width = self.view.frame.width - collectionViewInsets
        let cellWidth = ((width - itemSpacing) / itemsPerRow)
        let cellHeight = cellWidth + textAreaHeight
        
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize(width: homeCollectionView.bounds.width, height: 136.0)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayout.minimumLineSpacing = itemSpacing
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.backgroundColor = .white
        homeCollectionView.collectionViewLayout = flowLayout
    }
	
	func setCollectionHeaderUI(header: HomePostCollectionReusableView) {
		header.homeInfoView.clipsToBounds = true
		header.homeInfoView.layer.cornerRadius = 15
		header.homeInfoView.backgroundColor = UIColor.mainBGColor
		header.homeInfoView.layer.shadowOpacity = 0.25
		header.homeInfoView.layer.shadowOffset = CGSize(width: 4, height: 4)
		header.homeInfoView.layer.shadowRadius = 2
		header.homeInfoView.layer.masksToBounds = false
		header.settingBtn.setTitle("", for: .normal)
		header.calendarBtn.setTitle("", for: .normal)
	}
	
	// MARK: - 백엔드 통신
    func setData(){
        postService.PostListData_Alamofire(){ (success, data) in
            self.postsList = data

            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
        }
    }
    
	
	// 로그인이 success면 콜렉션뷰 다시 그림 (바인딩된 데이터로 그리기 위함)
	@objc func didRecieveGoHomeSuccess(_ notification: Notification) {
		DispatchQueue.main.async {
			self.homeCollectionView.reloadData()
		}
	}

    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        guard let postViewerVC = storyboard?.instantiateViewController(identifier: "PostViewerViewController") as? PostViewerViewController else { return }
        self.navigationController?.pushViewController(postViewerVC, animated: false)
    }

    @IBAction func settingButtonTapped(_ sender: UIButton) {
        guard let settingVC = storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController else { return }
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        guard let calendarVC = storyboard?.instantiateViewController(identifier: "CalendarViewController") as? CalendarViewController else { return }
        calendarVC.postArray = dataManager.getPostDate()
        self.navigationController?.pushViewController(calendarVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource{
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let postsList = postsList {
			if postsList.count == 0 {
				collectionView.setEmptyMessage("게시글이 없습니다\n하루를 기록해주세요")
			}else{
				collectionView.restore()
			}
		}
		
		return postsList?.count ?? 0
    }
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomePostCollectionViewHeader", for: indexPath) as! HomePostCollectionReusableView
		
		setCollectionHeaderUI(header: headerView)
	
		if let nickname = UserDefaults.standard.value(forKey: "nickname") as? String {
			headerView.userNameLabel.text = "\(nickname)님"
		}
	
		return headerView
	}
	
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! HomePostCollectionViewCell
        
		cell.post = postsList?[indexPath.row]

        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate{

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		guard let postViewerVC = storyboard?.instantiateViewController(identifier: "PostViewerViewController") as? PostViewerViewController else { return }
		
        
		//postViewerVC.tempPostData = dataManager.getPostDate()[indexPath.row]
        //postViewerVC.id = postsList?[indexPath.row].userId
        postViewerVC.post = postsList?[indexPath.row]
		
		self.navigationController?.pushViewController(postViewerVC, animated: true)
	}
}

extension UICollectionView{
    func setEmptyMessage(_ message: String){
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = UIColor(hexString: "#C4C4C4")
            label.numberOfLines = 2
            label.textAlignment = .center
            label.font = UIFont(name: "EF_Diary", size: 22)
            label.sizeToFit()
            return label
        }()
        let defaultImage: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "NoPost.png")
            
            return imageView
        }()
        let emptyView: UIView = {
            let view = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: 300, height: 400))
            return view
        }()
        emptyView.addSubview(messageLabel)
        emptyView.addSubview(defaultImage)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        defaultImage.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        defaultImage.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        defaultImage.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10).isActive = true
        
        
        self.backgroundView = emptyView
        
        
    }
    func restore(){
        self.backgroundView = nil
    }
}
