//
//  NativeWebViewController.swift
//  web-bridge-swift
//
//  Created by 60104968 on 2021/07/22.
//

import UIKit
import SnapKit
import RxFlow
import RxCocoa
import Foundation

class NativeViewController: UIViewController, RxFlow.Stepper {
    // ================================================================
    // Member Variable
    // ================================================================
    let steps = PublishRelay<Step>()

    /// 뷰 설정
    private var didSetupConstraints = false

    /// Title Label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "Native View"
        label.textColor = UIColor(red: 41/255, green: 76/255, blue: 61/255, alpha: 1.0)
        label.backgroundColor = UIColor(red: 254/255, green: 253/255, blue: 252/255, alpha: 1.0)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()

    /// Open Second Webview Button
    private let openWebViewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 41/255, green: 76/255, blue: 61/255, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("Second Webview", for: .normal)
        button.setTitleColor(UIColor(red: 254/255, green: 253/255, blue: 252/255, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(actionOpenSecondWebView), for: .touchUpInside)
        return button
    }()
    
    // ================================================================
    // ViewController Delegate Function
    // ================================================================

    /// 화면 로드 완료
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubview()
        view.setNeedsUpdateConstraints()
    }

    /// AutoLayout Constraints를 설정한다.
    override func updateViewConstraints() {
        innerUpdateViewConstraints()
        super.updateViewConstraints()
    }

    // ================================================================
    // UI 처리
    // ================================================================
    private func addSubview() {
        view.backgroundColor = .gray
        
        view.addSubview(titleLabel)
        view.addSubview(openWebViewButton)
    }

    private func innerUpdateViewConstraints() {
        if (!didSetupConstraints) {
            titleLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(40)
            }
            
            openWebViewButton.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                make.height.equalTo(40)
            }
            
            didSetupConstraints = true
        }
    }

    @objc func actionOpenSecondWebView(sender: UIButton!) {
        print("actionOpenSecondWebView")
        self.steps.accept(AppStep.secondWebView)
    }
}
