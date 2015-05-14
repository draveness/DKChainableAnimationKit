
//
//  NSBKeyframeAnimationFunction.swift
//  DKAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

typealias NSBKeyframeAnimationFunctionBlock = (Double, Double, Double, Double) -> Double

func NSBKeyframeAnimationFunctionLinear(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return c * t + b
}

func NSBKeyframeAnimationFunctionEaseInQuad(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return c * t * t + b;
}

func NSBKeyframeAnimationFunctionEaseOutQuad(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return -c * t * (t - 2) + b;
}

func NSBKeyframeAnimationFunctionEaseInOutQuad(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d / 2
    if t < 1 {
        return c / 2 * t * t + b;
    }
    return -c / 2 * ((--t) * (t - 2) - 1) + b;
}

func NSBKeyframeAnimationFunctionEaseInCubic(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return c * t * t * t + b;
}

func NSBKeyframeAnimationFunctionEaseOutCubic(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t = t / d - 1
    return c * (t * t * t + 1) + b;
}

func NSBKeyframeAnimationFunctionEaseInOutCubic(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d / 2
    if t < 1 {
        return c / 2 * t * t * t + b;
    } else {
        t -= 2
        return c / 2 * (t * t * t + 2) + b;
    }
}

func NSBKeyframeAnimationFunctionEaseInQuart(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return c * t * t * t * t + b;
}

func NSBKeyframeAnimationFunctionEaseOutQuart(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t = t / d - 1
    return -c * (t * t * t * t - 1) + b;
}

func NSBKeyframeAnimationFunctionEaseInOutQuart(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d / 2
    if t < 1 {
        return c / 2 * t * t * t * t + b;
    } else {
        t -= 2
        return -c / 2 * (t * t * t * t - 2) + b;
    }
}

func NSBKeyframeAnimationFunctionEaseInQuint(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return c * t * t * t * t * t + b;
}

func NSBKeyframeAnimationFunctionEaseOutQuint(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t = t / d - 1
    return c * (t * t * t * t * t + 1) + b;
}

func NSBKeyframeAnimationFunctionEaseInOutQuint(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d / 2
    if t < 1 {
        return c / 2 * t * t * t * t * t + b;
    } else {
        t -= 2
        return c / 2 * (t * t * t * t * t + 2) + b;
    }
}

func NSBKeyframeAnimationFunctionEaseInSine(var t: Double, b: Double, c: Double, d: Double) -> Double {
    return -c * cos(t / d * (M_PI_2)) + c + b;
}

func NSBKeyframeAnimationFunctionEaseOutSine(var t: Double, b: Double, c: Double, d: Double) -> Double {
    return c * sin(t / d * (M_PI_2)) + b;
}

func NSBKeyframeAnimationFunctionEaseInOutSine(var t: Double, b: Double, c: Double, d: Double) -> Double {
    return -c / 2 * (cos(M_PI * t / d) - 1) + b;
}

func NSBKeyframeAnimationFunctionEaseInExpo(var t: Double, b: Double, c: Double, d: Double) -> Double {
    return (t==0) ? b : c * pow(2, 10 * (t / d - 1)) + b;
}

func NSBKeyframeAnimationFunctionEaseOutExpo(var t: Double, b: Double, c: Double, d: Double) -> Double {

    return (t == d) ? b+c : c * (-pow(2, -10 * t / d) + 1) + b;
}

func NSBKeyframeAnimationFunctionEaseInOutExpo(var t: Double, b: Double, c: Double, d: Double) -> Double {
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

func NSBKeyframeAnimationFunctionEaseInCirc(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d
    return -c * (sqrt(1 - t * t) - 1) + b;
}

func NSBKeyframeAnimationFunctionEaseOutCirc(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t = t / d - 1
    return c * sqrt(1 - t * t) + b
}

func NSBKeyframeAnimationFunctionEaseInOutCirc(var t: Double, b: Double, c: Double, d: Double) -> Double {
    t /= d / 2
    if t < 1 {
        return -c / 2 * (sqrt(1 - t * t) - 1) + b
    }
    t -= 2
    return c / 2 * (sqrt(1 - t * t) + 1) + b
}

func NSBKeyframeAnimationFunctionEaseInElastic(var t: Double, b: Double, c: Double, d: Double) -> Double {
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

func NSBKeyframeAnimationFunctionEaseOutElastic(var t: Double, b: Double, c: Double, d: Double) -> Double {
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

func NSBKeyframeAnimationFunctionEaseInOutElastic(var t: Double, b: Double, c: Double, d: Double) -> Double {
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

func NSBKeyframeAnimationFunctionEaseInBack(var t: Double, b: Double, c: Double, d: Double) -> Double {
    let s = 1.70158
    t /= d
    return c * t * t * ((s + 1) * t - s) + b;
}

func NSBKeyframeAnimationFunctionEaseOutBack(var t: Double, b: Double, c: Double, d: Double) -> Double {
    let s = 1.70158
    t = t / d - 1
    return c * (t * t * ((s + 1) * t + s) + 1) + b;
}

func NSBKeyframeAnimationFunctionEaseInOutBack(var t: Double, b: Double, c: Double, d: Double) -> Double {
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

func NSBKeyframeAnimationFunctionEaseInBounce(var t: Double, b: Double, c: Double, d: Double) -> Double {
    return c - NSBKeyframeAnimationFunctionEaseOutBounce(d - t, 0, c, d) + b;
}

func NSBKeyframeAnimationFunctionEaseOutBounce(var t: Double, b: Double, c: Double, d: Double) -> Double {
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

func NSBKeyframeAnimationFunctionEaseInOutBounce(var t: Double, b: Double, c: Double, d: Double) -> Double {
    if t < d / 2 {
        return NSBKeyframeAnimationFunctionEaseInBounce (t * 2, 0, c, d) * 0.5 + b;
    } else {
        return NSBKeyframeAnimationFunctionEaseOutBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b;
    }
}