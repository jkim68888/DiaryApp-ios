//
//  PopUpViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/27.
//

import UIKit

/// UIKit(코드)로 UI구현
class PopUpViewController: UIViewController {
    private var titleText: String?
    private var messageText: String?
    private var attributedMessageText: NSAttributedString?
    private var contentView: UIView?

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12.0
        view.alignment = .center
        return view
    }()
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 14.0
        view.distribution = .fillEqually
        return view
    }()
    private lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.text = titleText
        label.textAlignment = .center
        label.font = UIFont(name: "EF_Diary", size: 18)
        label.numberOfLines = 0
        label.textColor = UIColor.mainFontColor
        return label
    }()
    private lazy var messageLabel: UILabel? = {
        guard messageText != nil || attributedMessageText != nil else { return nil }
        let label = UILabel()
        label.text = messageText
        label.textAlignment = .center
        label.font = UIFont(name: "EF_Diary", size: 18)
        label.textColor = UIColor.blackColor
        label.numberOfLines = 0
        if let attributedMessageText = attributedMessageText {
            label.attributedText = attributedMessageText
        }
        return label
    }()
    public func addActionToButton(title: String? = nil,
                                  titleColor: UIColor = .white,
                                  backgroundColor: UIColor = UIColor.mainFontColor!,
                                  completion: (() -> Void)? = nil){
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)

        // enable
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundImage(backgroundColor.image(), for: .normal)

        // disable
        button.setTitleColor(.gray, for: .disabled)
        button.setBackgroundImage(UIColor.gray.image(), for: .disabled)

        // layer
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true

        button.addAction(for: .touchUpInside) { _ in
            completion?()
        }

        buttonStackView.addArrangedSubview(button)
    }
    convenience init(titleText: String? = nil,
                     messageText: String? = nil,
                     attributedMessageText: NSAttributedString? = nil) {
        self.init()

        self.titleText = titleText
        self.messageText = messageText
        self.attributedMessageText = attributedMessageText
        /// present 시 fullScreen (화면을 덮도록 설정) -> 설정 안하면 pageSheet 형태 (위가 좀 남아서 밑에 깔린 뷰가 보이는 형태)
        modalPresentationStyle = .overFullScreen
    }

    convenience init(contentView: UIView) {
        self.init()

        self.contentView = contentView
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addSubviews()
        makeConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(containerStackView)
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }

    private func addSubviews() {
        view.addSubview(containerStackView)

        if let contentView = contentView {
            containerStackView.addSubview(contentView)
        } else {
            if let titleLabel = titleLabel {
                containerStackView.addArrangedSubview(titleLabel)
            }

            if let messageLabel = messageLabel {
                containerStackView.addArrangedSubview(messageLabel)
            }
        }

        if let lastView = containerStackView.subviews.last {
            containerStackView.setCustomSpacing(24.0, after: lastView)
        }

        containerStackView.addArrangedSubview(buttonStackView)
    }

    private func makeConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 32),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -32),

            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            buttonStackView.heightAnchor.constraint(equalToConstant: 48),
            buttonStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor)
        ])
    }

    
    
}
extension UIColor {
    /// Convert color to image
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIControl {
    public typealias UIControlTargetClosure = (UIControl) -> ()

    private class UIControlClosureWrapper: NSObject {
        let closure: UIControlTargetClosure
        init(_ closure: @escaping UIControlTargetClosure) {
            self.closure = closure
        }
    }

    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }

    private var targetClosure: UIControlTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIControlClosureWrapper else { return nil }
            return closureWrapper.closure

        } set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIControlClosureWrapper(newValue),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }

    public func addAction(for event: UIControl.Event, closure: @escaping UIControlTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIControl.closureAction), for: event)
    }

}
extension UIViewController {
    func showPopUp(title: String? = nil,
                   message: String? = nil,
                   attributedMessage: NSAttributedString? = nil,
                   leftActionTitle: String = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(titleText: title,
                                                      messageText: message,
                                                      attributedMessageText: attributedMessage)
        showPopUp(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }

    func showPopUp(contentView: UIView,
                   leftActionTitle: String = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(contentView: contentView)

        showPopUp(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }

    private func showPopUp(popUpViewController: PopUpViewController,
                           leftActionTitle: String,
                           rightActionTitle: String,
                           leftActionCompletion: (() -> Void)?,
                           rightActionCompletion: (() -> Void)?) {
        popUpViewController.addActionToButton(title: leftActionTitle,
                                              titleColor: .systemGray,
                                              backgroundColor: .secondarySystemBackground) {
            popUpViewController.dismiss(animated: false, completion: leftActionCompletion)
        }

        popUpViewController.addActionToButton(title: rightActionTitle,
                                              titleColor: .white,
                                              backgroundColor: UIColor.mainFontColor!) {
            popUpViewController.dismiss(animated: false, completion: rightActionCompletion)
        }
        present(popUpViewController, animated: false, completion: nil)
    }
	
    func showToast(message : String) {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.font = UIFont(name: "EF_Diary", size: 18)
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
}
