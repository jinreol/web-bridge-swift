//
//  AppStep.swift
//  web-bridge-swift
//
//  Created by jinreol.kim on 2021/07/22.
//

import RxFlow

enum AppStep: Step {
    case splash
    case firstWebView
    case nativeView
    case secondWebView
    case popViewController
}
