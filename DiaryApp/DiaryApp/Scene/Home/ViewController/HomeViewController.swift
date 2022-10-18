//
//  HomeViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeInfoView: UIView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var defaultStackView: UIStackView!
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var addPostBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    var haveData:Bool = false
    let flowLayout = UICollectionViewFlowLayout()
    let dataManager = TempDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(true, animated: false)
        setUI()
        dataRoad()
        setCollectionView()
    }
    // View가 보이려고할 때, 네비게이션 바를 임의적으로 숨긴다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    // View가 사라지려고 할 때, 네비게이션 바를 임의적으로 보이게한다.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func setUI(){
        homeInfoView.clipsToBounds = true
        homeInfoView.layer.cornerRadius = 20
        homeInfoView.backgroundColor = UIColor(hexString: "#FFBBBC")
        homeInfoView.layer.shadowOpacity = 0.6
        homeInfoView.layer.shadowOffset = CGSize(width: 0, height: 5)
        homeInfoView.layer.shadowRadius = 5
        homeInfoView.layer.masksToBounds = false
        settingBtn.setTitle("", for: .normal)
        addPostBtn.setTitle("", for: .normal)
        calendarBtn.setTitle("", for: .normal)
        addPostBtn.clipsToBounds = true
        addPostBtn.layer.cornerRadius = addPostBtn.frame.width / 2

    }
    
    func setCollectionView(){
        if haveData == true{
            homeCollectionView.isHidden = false
            defaultStackView.isHidden = true
            
            homeCollectionView.delegate = self
            homeCollectionView.dataSource = self
            homeCollectionView.backgroundColor = .white
            flowLayout.scrollDirection = .vertical
            
            let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            let width = homeCollectionView.frame.width
            let height = homeCollectionView.frame.height
            let itemsPerRow: CGFloat = 2
            let itemsPerColumn: CGFloat = 3
            
            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
            let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
            let cellWidth = ((width - widthPadding) / itemsPerRow) - itemsPerRow
            let cellHeight = (height - heightPadding) / itemsPerColumn
            
//            let cellWidth = (homeInfoView.bounds.width / 2) - 6
//            let cellHeight = cellWidth * 0.7
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
//            let upDownSpacing:CGFloat = 10
//            let leftRightSpacing:CGFloat = 1
//            flowLayout.minimumInteritemSpacing = leftRightSpacing
//            flowLayout.minimumLineSpacing = upDownSpacing
            homeCollectionView.collectionViewLayout = flowLayout
        }
    }
    func dataRoad(){
        dataManager.roadPostData()
        print(#function)
        
        // 만약 데이터를 가져왔을때 nil이 아니라면, haveData를 True로 변경한다.
        if dataManager.getPostDate() != nil{
            haveData = true
            print("값을 정상적으로 불러왔습니다.")
        }
    }

    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
        self.navigationController?.pushViewController(postVC, animated: true)
    }

    @IBAction func settingButtonTapped(_ sender: UIButton) {
        guard let settingVC = storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController else { return }
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        guard let calendarVC = storyboard?.instantiateViewController(identifier: "CalendarViewController") as? CalendarViewController else { return }
        self.navigationController?.pushViewController(calendarVC, animated: true)
    }
}
extension HomeViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.getPostDate().count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! HomePostCollectionViewCell
        cell.postData = dataManager.getPostDate()[indexPath.row]
        return cell
    }
}
extension HomeViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        guard let postViewerVC = storyboard?.instantiateViewController(identifier: "PostViewerViewController") as? PostViewerViewController else { return }
        
        postViewerVC.tempPostData = dataManager.getPostDate()[indexPath.row]
        
        
        self.navigationController?.pushViewController(postViewerVC, animated: true)
        
        
    }

}
