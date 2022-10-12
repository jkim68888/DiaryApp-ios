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
    @IBOutlet weak var addPostBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(true, animated: false)
        setView()
        // Do any additional setup after loading the view.
    }
    
    func setView(){
        homeInfoView.clipsToBounds = true
        homeInfoView.layer.cornerRadius = 20
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addPost(_ sender: UIButton) {
        performSegue(withIdentifier: "toDetailPost", sender: nil)
    }
    @IBAction func profileSetClick(_ sender: Any) {
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
}
