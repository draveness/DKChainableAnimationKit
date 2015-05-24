
//
//  DKKeyframeAnimationFunction.swift
//  DKChainableAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//  This is a swift port for https://github.com/NachoSoto/NSBKeyframeAnimation/blob/master/NSBKeyframeAnimation/Classes/NSBKeyframeAnimation/NSBKeyframeAnimationFunctions.c file.

import UIKit

typealias DKKeyframeAnimationFunctionBlock = (Double, Double, Double, Double) -> Double

func DKKeyframeAnimationFunctionLinear(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return c * t + b
}

func DKKeyframeAnimationFunctionEaseInQuad(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return c * t * t + b;
}

func DKKeyframeAnimationFunctionEaseOutQuad(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return -c * t * (t - 2) + b;
}

func DKKeyframeAnimationFunctionEaseInOutQuad(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d / 2
    if t < 1 {
        return c / 2 * t * t + b;
    }
    return -c / 2 * ((--t) * (t - 2) - 1) + b;
}

func DKKeyframeAnimationFunctionEaseInCubic(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return c * t * t * t + b;
}

func DKKeyframeAnimationFunctionEaseOutCubic(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t = t / d - 1
    return c * (t * t * t + 1) + b;
}

func DKKeyframeAnimationFunctionEaseInOutCubic(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d / 2
    if t < 1 {
        return c / 2 * t * t * t + b;
    } else {
        t -= 2
        return c / 2 * (t * t * t + 2) + b;
    }
}

func DKKeyframeAnimationFunctionEaseInQuart(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return c * t * t * t * t + b;
}

func DKKeyframeAnimationFunctionEaseOutQuart(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t = t / d - 1
    return -c * (t * t * t * t - 1) + b;
}

func DKKeyframeAnimationFunctionEaseInOutQuart(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d / 2
    if t < 1 {
        return c / 2 * t * t * t * t + b;
    } else {
        t -= 2
        return -c / 2 * (t * t * t * t - 2) + b;
    }
}

func DKKeyframeAnimationFunctionEaseInQuint(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return c * t * t * t * t * t + b;
}

func DKKeyframeAnimationFunctionEaseOutQuint(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t = t / d - 1
    return c * (t * t * t * t * t + 1) + b;
}

func DKKeyframeAnimationFunctionEaseInOutQuint(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d / 2
    if t < 1 {
        return c / 2 * t * t * t * t * t + b;
    } else {
        t -= 2
        return c / 2 * (t * t * t * t * t + 2) + b;
    }
}

func DKKeyframeAnimationFunctionEaseInSine(var t: Double, b: Double, c: Double, d: Double) -> Double {
    return -c * cos(t / d * (M_PI_2)) + c + b;
}

func DKKeyframeAnimationFunctionEaseOutSine(var t: Double, b: Double, c: Double, d: Double) -> Double {
    return c * sin(t / d * (M_PI_2)) + b;
}

func DKKeyframeAnimationFunctionEaseInOutSine(var t: Double, b: Double, c: Double, d: Double) -> Double {
    return -c / 2 * (cos(M_PI * t / d) - 1) + b;
}

func DKKeyframeAnimationFunctionEaseInExpo(var t: Double, b: Double, c: Double, d: Double) -> Double {
    return (t==0) ? b : c * pow(2, 10 * (t / d - 1)) + b;
}

func DKKeyframeAnimationFunctionEaseOutExpo(var t: Double, b: Double, c: Double, d: Double) -> Double {

    return (t == d) ? b+c : c * (-pow(2, -10 * t / d) + 1) + b;
}

func DKKeyframeAnimationFunctionEaseInOutExpo(var t: Double, b: Double, c: Double, d: Double) -> Double {
    if t == 0 {
        return b
    }
    if t == d {
        return b + c
    }
    t /= d / 2
    if t < 1 {
        return c / 2 * pow(2, 10 * (t - 1)) + b
    }
    return c / 2 * (-pow(2, -10 * --t) + 2) + b
}

func DKKeyframeAnimationFunctionEaseInCirc(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return -c * (sqrt(1 - t * t) - 1) + b;
}

func DKKeyframeAnimationFunctionEaseOutCirc(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t = t / d - 1
    return c * sqrt(1 - t * t) + b
}

func DKKeyframeAnimationFunctionEaseInOutCirc(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d / 2
    if t < 1 {
        return -c / 2 * (sqrt(1 - t * t) - 1) + b
    }
    t -= 2
    return c / 2 * (sqrt(1 - t * t) + 1) + b
}

func DKKeyframeAnimationFunctionEaseInElastic(var t: Double, b: Double, c: Double, d: Double) -> Double {
    var s = 1.70158
    var p = 0.0
    var a = c

    if t == 0 {
        return b
    }
    t /= d
    if t == 1 {
        return b + c
    }
    if p == 0.0 {
        p = d * 0.3
    }
    if a < fabs(c) {
        a = c
        s = p / 4
    } else {
        s = p / (2 * M_PI) * asin (c / a)
    }
    t -= 1
    return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * M_PI) / p )) + b;
}

func DKKeyframeAnimationFunctionEaseOutElastic(var t: Double, b: Double, c: Double, d: Double) -> Double {
    var s = 1.70158
    var p = 0.0
    var a = c
    if t == 0 {
        return b
    }
    t /= d
    if t == 1 {
        return b + c
    }
    if p == 0.0 {
        p = d * 0.3
    }
    if a < fabs(c) {
        a = c
        s = p / 4
    } else {
        s = p / (2 * M_PI) * asin (c / a)
    }
    t -= 1
    return (a * pow(2, 10 * t) * sin((t * d - s) * (2 * M_PI) / p)) + b;
}

func DKKeyframeAnimationFunctionEaseInOutElastic(var t: Double, b: Double, c: Double, d: Double) -> Double {
    var s = 1.70158
    var p = 0.0
    var a = c;
    if t == 0 {
        return b
    }
    t /= d
    if t == 2 {
        return b + c
    }
    if p == 0.0 {
        p = d * 0.3 * 1.5
    }
    if a < fabs(c) {
        a = c
        s = p / 4
    } else {
        s = p / (2 * M_PI) * asin (c / a)
    }

    if t < 1 {
        t -= 1
        return -0.5 * (a * pow(2,10 * t) * sin( (t * d - s) * (2 * M_PI) / p )) + b
    } else {
        t -= 1
        return a * pow(2,-10 * t) * sin( (t * d - s) * (2 * M_PI) / p ) * 0.5 + c + b
    }
}

func DKKeyframeAnimationFunctionEaseInBack(var t: Double, b: Double, c: Double, d: Double) -> Double {
    let s = 1.70158
    t /= d
    return c * t * t * ((s + 1) * t - s) + b;
}

func DKKeyframeAnimationFunctionEaseOutBack(var t: Double, b: Double, c: Double, d: Double) -> Double {
    let s = 1.70158
    t = t / d - 1
    return c * (t * t * ((s + 1) * t + s) + 1) + b;
}

func DKKeyframeAnimationFunctionEaseInOutBack(var t: Double, b: Double, c: Double, d: Double) -> Double {
    var s = 1.70158
    t /= d / 2

    if t < 1 {
        s *= 1.525
        return c / 2 * (t * t * ((s + 1) * t - s)) + b;
    } else {
        t -= 2
        s *= 1.525
        return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b;
    }
}

func DKKeyframeAnimationFunctionEaseInBounce(var t: Double, b: Double, c: Double, d: Double) -> Double {
    return c - DKKeyframeAnimationFunctionEaseOutBounce(d - t, 0, c, d) + b;
}

func DKKeyframeAnimationFunctionEaseOutBounce(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    if t < 1 / 2.75 {
        return c * (7.5625 * t * t) + b;
    } else if t < 2 / 2.75 {
        t -= 1.5 / 2.75
        return c * (7.5625 * t * t + 0.75) + b;
    } else if t < 2.5 / 2.75 {
        t -= 2.25 / 2.75
        return c * (7.5625 * t * t + 0.9375) + b;
    } else {
        t -= 2.625 / 2.75
        return c * (7.5625 * t * t + 0.984375) + b;
    }
}

func DKKeyframeAnimationFunctionEaseInOutBounce(var t: Double, b: Double, c: Double, d: Double) -> Double {
    if t < d / 2 {
        return DKKeyframeAnimationFunctionEaseInBounce (t * 2, 0, c, d) * 0.5 + b;
    } else {
        return DKKeyframeAnimationFunctionEaseOutBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b;
    }
}