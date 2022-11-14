//
//  PostViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/14.
//
import UIKit
import PhotosUI

class PostViewController: UIViewController {
	let postService = PostService.shared
    //Post 고유 번호도 가져와서 수정할때 사용해야한다.
	var post: Post?
    var image: UIImage? // 이전 화면인 postViewer에서 가져온 image
    var imageData = Data()
    
    // Post에 대한 정보를 담고있는 변수
    var postData: TempPost?
    
    var dataManager = TempDataManager.shared
    // 현재 Post의 index번호를 담는 변수 -> 삭제나 업데이트 시에 사용
    var postNumber:Int? = 0
    // Post 수정 시에, delegate를 통해 다른 View를 reload하는데 사용
    var delegate:TempPostDelegate?
	
	
    // 게시글 내부에 들어갈 Placeholedr 담는 변수
    var postScriptTVPlaceHolder:String = "텍스트를 여기에 입력하세요"
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var cancleImgBtn: UIButton!
    @IBOutlet weak var postImageBtn: UIButton!
    @IBOutlet weak var postStackView: UIStackView!
    @IBOutlet weak var postDateTF: UITextField!
    @IBOutlet weak var postTitleTF: UITextField!
    @IBOutlet weak var postScriptTV: UITextView!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
		setDefaultDataUI()
        setDatePicker()
        setDelegate()
        setImagePickView()
    }


    func setDefaultDataUI(){
        guard var post = post else {
            print("데이터불러오기실패 또는 데이터 추가")
            postDateTF.text = Date().toString()
            postTitleTF.text = ""
            postScriptTV.text = postScriptTVPlaceHolder
            return
        }
        
        print("데이터불러오기성공")
        postImageView.image = image
        postDateTF.text = post.datetime.toString()
        postTitleTF.text = post.title
        if postScriptTV.text! == ""{postScriptTV.textColor = .lightGray}
        postScriptTV.text = post.body ?? postScriptTVPlaceHolder
        
        // 삭제 및 수정을 위해
        postNumber = post.id
        }
	
    func setUI(){
        
        // 사진선택 버튼에 테두리 넣기
        postImageBtn.setTitle("", for: .normal)
        postImageBtn.clipsToBounds = true
        postImageBtn.layer.cornerRadius = 5
        postImageBtn.layer.borderWidth = 1
		postImageBtn.layer.borderColor = UIColor(hexString: "#666666").cgColor
        
        // 선택된 사진에 테두리 넣기
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 5
        postImageView.layer.borderWidth = 1
        postImageView.layer.borderColor = UIColor(hexString: "#cccccc").cgColor
        
		doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "EF_Diary", size: 18)!], for: .normal)
		
        // TextField에 얇은 테두리 안보이게 설정
        postTitleTF.borderStyle = .none
        postDateTF.borderStyle = .none
		
        // 공통 네비게이션바 사용
        self.navigationController?.navigationBar.customNavigationBar()
    }
	
    // MARK: - 1. Date Picker를 호출하여 날짜를 입력할 수 있도록 설정
    func setDatePicker(){
        let locale = NSLocale(localeIdentifier: "ko_KO")
        let datepicker = UIDatePicker()
        datepicker.locale = locale as Locale
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.datePickerMode = UIDatePicker.Mode.date
        datepicker.addTarget(self, action: #selector(DatepickerCh(sender:)), for: UIControl.Event.valueChanged)
        postDateTF.inputView = datepicker
    }
    @objc func DatepickerCh(sender:UIDatePicker){
        postDateTF.text = sender.date.toString()
    }
	
    // TextField와 TextView에대한 Delegate 선언
    func setDelegate(){
        postTitleTF.delegate = self
        postScriptTV.delegate = self
    }
	
    // 불러온 PostData에 이미지에 따라 ImageView를 세팅
    func setImagePickView(){
        print(#function)
        if postImageView.image == nil{
            postImageView.isHidden = true
            cancleImgBtn.isHidden = true
            print("새 게시글")
        }else{
            postImageView.isHidden = false
            cancleImgBtn.isHidden = false
            print("기존 글 수정")
        }
    }
    
     //특정 항목들이 저장되어있지 않으면, 뒤로가지 못하게 막아야함
    
    @IBAction func postImagePickButtonTapped(_ sender: UIButton) {
        // 피커뷰를 사용하기 위해서 configuration을 먼저 설정해준다.
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 //사진을 무한대로 가지고 올 수 있는... 1이면 1개만, 2는 2개만 가져온다.
		configuration.filter = .any(of: [.images, .videos]) // 지금은 사진과 비디오를 가져올 수 있게 설정하였다.
        // 기본 설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        // 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        // 피커뷰 띄우기
        self.present(picker, animated: true,completion: nil)
    }
    
    // 현재 선택된 Image를 제거
    @IBAction func cancleImgButtonTapped(_ sender: UIButton) {
        postImageView.image = nil
        postImageView.isHidden = true
        cancleImgBtn.isHidden = true
    }
	
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        if postTitleTF.text! == ""{
            showPopUp(title: "알림", message: "작성을 취소하시겠습니까?\n[확인]을 누르시면\n이전 화면으로 되돌아갑니다.?", attributedMessage: nil, leftActionTitle: "취소", rightActionTitle: "확인", rightActionCompletion:  {
                self.navigationController?.popToRootViewController(animated: true)
                self.dataManager.delete(uniqueNum: self.postNumber!)
            })
        }
        showPopUp(title: "알림", message: "편집을 중단하시겠습니까?", attributedMessage: nil, leftActionTitle: "취소", rightActionTitle: "확인", rightActionCompletion:  {
            self.navigationController?.popViewController(animated: true)
        })
    }
	
    // 완료 버튼을 눌렀을 때
    @IBAction func doneButtonTapped(_ sender: Any) {
        print(#function)
        
        let postViewerVCindex = navigationController!.viewControllers.count - 2
        let postViewerVC = navigationController?.viewControllers[postViewerVCindex] as! PostViewerViewController
        print("확인절차")
        print(post)
        print("확인절차끝")
        // MARK: - 백엔드 연동
        if let token = UserDefaults.standard.value(forKey: "authVerificationID") as? String {
            guard var post = post else {
            // Post가 없는 경우
                postService.addPostData_Alamofire(accessToken: token,
                                                  title: postTitleTF.text ?? "",
                                                  body: postScriptTV.text ?? "",
                                                  datetime: postDateTF.text?.toDate() ?? Date(),
                                                  image: postImageView.image ?? UIImage(named: "NoImage.png")!) {
                    print("addPost 성공!!!")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                return
            }
            // post가 있었을 경우
            print("UpdatePost")
            postService.updatePostData(post.id,
                                       accessToken: token,
                                       title: postTitleTF.text ?? "",
                                       body: postScriptTV.text ?? "",
                                       datetime: postDateTF.text?.toDate() ?? Date(),
                                       image: postImageView.image ?? UIImage(named: "NoImage.png")!) {
                print("UpdatePost 성공!!!")
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            return
        }
    }
	
    // MARK: - 3. 삭제 시에, 해당된 Post의 index에 해당하는 값을 지우고, 다시 배열을 정렬해야함
    @IBAction func postDeleteButtonTapped(_ sender: UIButton) {
        let homeVCindex = navigationController!.viewControllers.count - 3
        let homeVC = navigationController?.viewControllers[homeVCindex] as! HomeViewController
        dataManager.delete(uniqueNum: postNumber!)
        self.navigationController?.popToViewController(homeVC, animated: true)
        print(dataManager.getPostDate())
    }
	
    /// 다른 곳을 누르면 키보드가 내려가게 설정
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension PostViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.postImageView.image = image as? UIImage
                    self.postImageView.isHidden = false
                    self.cancleImgBtn.isHidden = false
                }
            }
        }else {
            print("이미지를 불러올 수 없습니다.")
        }
    }
}

// MARK: - 4. TextView의 디폴트 내용(ex. 내용을 입력해주세요) 추가
extension PostViewController:UITextViewDelegate{
    //textView에 입력을 시작할 때
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text == postScriptTVPlaceHolder{
            textView.text = nil
            textView.textColor = .black
        }
    }

    //textView에 입력을 끝났을 때,
    func textViewDidEndEditing(_ textView: UITextView){
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            textView.text = postScriptTVPlaceHolder
            textView.textColor = .lightGray
        }
    }
}

extension PostViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.isFirstResponder
        return true
    }
}

