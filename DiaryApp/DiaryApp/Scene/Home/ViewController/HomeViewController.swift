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
    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var addPostBtn: UIButton!
    
    var haveData:Bool = false
    let flowLayout = UICollectionViewFlowLayout()
    let dataManager = TempDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(true, animated: false)
        setView()
        dataRoad()
        setGesture()
        setCollectionView()
        // Do any additional setup after loading the view.
    }
    
    func setView(){
        homeInfoView.clipsToBounds = true
        homeInfoView.layer.cornerRadius = 20
        addPostBtn.setTitle("", for: .normal)
        addPostBtn.clipsToBounds = true
        addPostBtn.layer.cornerRadius = addPostBtn.frame.width / 2
    }
    func setCollectionView(){
        if haveData == true{
            homeCollectionView.isHidden = false
            defaultStackView.isHidden = true
            
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
    // 제스처 기능을 부여하는 함수
    func setGesture(){
        let tapGestureImageView = UITapGestureRecognizer(target: self, action: #selector(달력이미지를눌렀을때))
        calendarImage.addGestureRecognizer(tapGestureImageView) // 제스처를 추가....
        calendarImage.isUserInteractionEnabled = true // 유저와의 소통을 가능하게...
    }
    @objc func 달력이미지를눌렀을때(){
        guard let calendarVC = storyboard?.instantiateViewController(identifier: "CalendarViewController") as? CalendarViewController else { return }
        self.navigationController?.pushViewController(calendarVC, animated: true)
    }

    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
        self.navigationController?.pushViewController(postVC, animated: true)
    }
    @IBAction func settingButtonTapped(_ sender: UIBarButtonItem) {
        guard let settingVC = storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController else { return }
        self.navigationController?.pushViewController(settingVC, animated: true)
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
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        <#code#>
//    }
}
