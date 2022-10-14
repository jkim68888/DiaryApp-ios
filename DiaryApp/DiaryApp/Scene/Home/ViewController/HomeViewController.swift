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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(true, animated: false)
        setView()
        제스처부여하기()
        // Do any additional setup after loading the view.
    }
    
    func setView(){
        homeInfoView.clipsToBounds = true
        homeInfoView.layer.cornerRadius = 20
    }

    func 제스처부여하기(){
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
