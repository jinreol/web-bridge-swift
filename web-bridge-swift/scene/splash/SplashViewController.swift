//
//  SplashViewController.swift
//  web-bridge-swift
//
//  Created by jinreol.kim on 2021/07/22.
//

import UIKit
import SnapKit
import RxFlow
import RxCocoa
import Foundation

class SplashViewController: UIViewController, RxFlow.Stepper {
    
    // ================================================================
    // Member Variable
    // ================================================================
    let steps = PublishRelay<Step>()

    /// 뷰 설정
    private var didSetupConstraints = false

    /// Splash Image
    private let splashImageView: UIImageView = {
        let image = UIImage(named: "deck")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    // ================================================================
    // ViewController Delegate Function
    // ================================================================

    /// 화면 로드 완료
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubview()
        view.setNeedsUpdateConstraints()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 1초 뒤 페미지 전환
            self.steps.accept(AppStep.firstWebView)
        }
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
        view.addSubview(splashImageView)
    }

    private func innerUpdateViewConstraints() {
        if (!didSetupConstraints) {
            splashImageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(80)
            }
            didSetupConstraints = true
        }
    }
}
