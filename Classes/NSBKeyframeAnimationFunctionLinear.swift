
//
//  NSBKeyframeAnimationFunctionLinear.swift
//  DKAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

func NSBKeyframeAnimationFunctionLinear(var t: Double, b: Double, c: Double, d: Double) -> Double {
    let a = t / d
    return c * a + b
}
