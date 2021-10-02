//
//  AppStepper.swift
//  web-bridge-swift
//
//  Created by jinreol.kim on 2021/07/22.
//

import RxFlow
import RxSwift
import RxCocoa

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    var initialStep: Step {
        return AppStep.splash
    }
}
