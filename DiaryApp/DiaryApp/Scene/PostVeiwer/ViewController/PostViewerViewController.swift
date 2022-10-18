//
//  DetailPostViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/12.
//

import UIKit

class PostViewerViewController: UIViewController {

    var tempPostData: TempPost?
    
    @IBOutlet weak var postViewerImageView: UIImageView!
    @IBOutlet weak var postViewerDateLabel: UILabel!
    @IBOutlet weak var postViewerTitleLabel: UILabel!
    @IBOutlet weak var postViewerDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func setPost(){
//        guard var tempPostData = tempPostData else {return}
//        postViewerImageView.image = tempPostData.postImage
//        postViewerDateLabel.text = tempPostData.createDate
//        postViewerTitleLabel.text = tempPostData.postTitle
//        postViewerDescriptionLabel.text = tempPostData.postScript

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let postVC = storyboard?.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
        self.navigationController?.pushViewController(postVC, animated: true)
    }
}
