//
//  AppFlow.swift
//  web-bridge-swift
//
//  Created by jinreol.kim on 2021/07/22.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

// NavigationController를 제어한다.
class AppFlow: Flow {
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()

    var root: Presentable {
        return self.rootViewController
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
            case .splash:
                return navigateToSplash()

            case .firstWebView:
                return navigateToFirstWebView()
                
            case .nativeView:
                return navigateToNativeView()

            case .secondWebView:
                return navigateToSecondWebView()

            // case .popViewController:
            //     return navigatePopViewController()
        
        default:
            return .none
        }
    }

    private func navigateToSplash() -> FlowContributors  {
        let viewController = SplashViewController()
        viewController.title = "Splash"
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }

    private func navigateToFirstWebView() -> FlowContributors {
        let viewController = FirstWebViewController()
        viewController.title = "First WebView"
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNext: viewController))
    }

     private func navigateToNativeView() -> FlowContributors {
         let viewController = NativeViewController()
         viewController.title = "Native View"
         self.rootViewController.pushViewController(viewController, animated: true)
         return .one(flowContributor: .contribute(withNext: viewController))
     }

     private func navigateToSecondWebView() -> FlowContributors {
         let viewController = SecondWebViewController()
         viewController.title = "Second WebView"
         self.rootViewController.pushViewController(viewController, animated: true)
         return .one(flowContributor: .contribute(withNext: viewController))
     }

    // private func navigatePopViewController() {
    //     self.rootViewController.popViewController(animated: true)
    //     return .none
    // }
}

