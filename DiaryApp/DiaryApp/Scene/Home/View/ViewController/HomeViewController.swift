//
//  HomeViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var defaultStackView: UIStackView!
    @IBOutlet weak var addPostBtn: UIButton!
	
	let signInVM = SignInViewModel()
	var snsUser: SnsUser?
	
    var haveData:Bool = false
    let flowLayout = UICollectionViewFlowLayout()
    let dataManager = TempDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: NSNotification.Name("getKakaoSignIn"), object: nil)
        setUI()
		bindData()
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
    
    func setCollectionView(){
        if haveData {
			let itemsPerRow: CGFloat = 2
			let textAreaHeight: CGFloat = 35
			let itemSpacing: CGFloat = 16
			let collectionViewInsets: CGFloat = 32
			let width = self.view.frame.width - collectionViewInsets
			let cellWidth = ((width - itemSpacing) / itemsPerRow)
			let cellHeight = cellWidth + textAreaHeight
			
            homeCollectionView.isHidden = false
            defaultStackView.isHidden = true
			
			flowLayout.scrollDirection = .vertical
			flowLayout.headerReferenceSize = CGSize(width: homeCollectionView.bounds.width, height: 136.0)
			flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
			flowLayout.minimumLineSpacing = itemSpacing
            
            homeCollectionView.delegate = self
            homeCollectionView.dataSource = self
            homeCollectionView.backgroundColor = .white
			homeCollectionView.collectionViewLayout = flowLayout
			
		} else {
			homeCollectionView.isHidden = true
			defaultStackView.isHidden = false
		}
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
	
    func bindData(){
        dataManager.roadPostData()
        print(#function)
        
        // 만약 데이터를 가져왔을때 nil이 아니라면, haveData를 True로 변경한다.
        if dataManager.getPostDate() != nil{
            haveData = true
            print("값을 정상적으로 불러왔습니다.")
        }
    }
	
	@objc func didRecieveNotification(_ notification: Notification) {
		guard let data = notification.object as? SnsUser else { return }
		self.snsUser = data
		
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
        calendarVC.postData = dataManager.getPostDate()
        self.navigationController?.pushViewController(calendarVC, animated: true)
    }
}
extension HomeViewController: UICollectionViewDataSource{
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.getPostDate().count
    }
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomePostCollectionViewHeader", for: indexPath) as! HomePostCollectionReusableView
		
		setCollectionHeaderUI(header: headerView)
		
		headerView.userNameLabel.text = "\(snsUser?.name ?? "홍길동")님"
	
		return headerView
	}
	
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! HomePostCollectionViewCell
		
        cell.postData = dataManager.getPostDate()[indexPath.row]
		 
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate{

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		guard let postViewerVC = storyboard?.instantiateViewController(identifier: "PostViewerViewController") as? PostViewerViewController else { return }
		
		postViewerVC.tempPostData = dataManager.getPostDate()[indexPath.row]
		
		
		self.navigationController?.pushViewController(postViewerVC, animated: true)
	}
}
