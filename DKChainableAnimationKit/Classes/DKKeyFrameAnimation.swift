//
//  DKKeyFrameAnimation.swift
//  DKChainableAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

public class DKKeyFrameAnimation: CAKeyframeAnimation {

    internal let kFPS = 60

    internal typealias DKKeyframeAnimationFunction = (Double, Double, Double, Double) -> Double;

    internal var fromValue: AnyObject!
    internal var toValue: AnyObject!
    internal var functionBlock: DKKeyframeAnimationFunction!

    convenience init(keyPath path: String!) {
        self.init()
        self.keyPath = path
        self.functionBlock = DKKeyframeAnimationFunctionLinear
    }

    internal func calculte() {
        self.createValueArray()
    }

    internal func createValueArray() {
        if let fromValue: AnyObject = self.fromValue, let toValue: AnyObject = self.toValue {
            if valueIsKindOf(NSNumber) {
                self.values = self.valueArrayFor(startValue: CGFloat(fromValue.floatValue), endValue: CGFloat(toValue.floatValue)) as [AnyObject]
            } else if valueIsKindOf(UIColor) {
                let fromColor = self.fromValue.CGColor
                let toColor = self.toValue.CGColor
                let fromComponents = CGColorGetComponents(fromColor)
                let toComponents = CGColorGetComponents(toColor)

                let redValues = self.valueArrayFor(startValue: fromComponents[0], endValue: toComponents[0]) as! [CGFloat]
                let greenValues = self.valueArrayFor(startValue: fromComponents[1], endValue: toComponents[1]) as! [CGFloat]
                let blueValues = self.valueArrayFor(startValue: fromComponents[2], endValue: toComponents[2]) as! [CGFloat]
                let alphaValues = self.valueArrayFor(startValue: fromComponents[3], endValue: toComponents[3]) as! [CGFloat]

                self.values = self.colorArrayFrom(redValues: redValues, greenValues: greenValues, blueValues: blueValues, alphaValues: alphaValues) as [AnyObject]
            } else if valueIsKindOf(NSValue) {
                self.fromValue.objCType
                let valueType: NSString! = NSString(CString: self.fromValue.objCType, encoding: 1)
                if valueType.containsString("CGRect") {
                    let fromRect = self.fromValue.CGRectValue()
                    let toRect = self.toValue.CGRectValue()

                    let xValues = self.valueArrayFor(startValue: fromRect.origin.x, endValue: toRect.origin.x) as! [CGFloat]
                    let yValues = self.valueArrayFor(startValue: fromRect.origin.y, endValue: toRect.origin.x) as! [CGFloat]
                    let widthValues = self.valueArrayFor(startValue: fromRect.size.width, endValue: toRect.size.width) as! [CGFloat]
                    let heightValues = self.valueArrayFor(startValue: fromRect.size.height, endValue: toRect.size.height) as! [CGFloat]

                    self.values = self.rectArrayFrom(xValues: xValues, yValues: yValues, widthValues: widthValues, heightValues: heightValues) as [AnyObject]

                } else if valueType.containsString("CGPoint") {
                    let fromPoint = self.fromValue.CGPointValue()
                    let toPoint = self.toValue.CGPointValue()
                    let path = self.createPathFromXYValues(self.valueArrayFor(startValue: fromPoint.x, endValue: toPoint.x), yValues: self.valueArrayFor(startValue: fromPoint.y, endValue: toPoint.y))
                    self.path = path
                } else if valueType.containsString("CGSize") {
                    let fromSize = self.fromValue.CGSizeValue()
                    let toSize = self.toValue.CGSizeValue()
                    let path = self.createPathFromXYValues(self.valueArrayFor(startValue: fromSize.width, endValue: toSize.width), yValues: self.valueArrayFor(startValue: fromSize.height, endValue: toSize.height))
                    self.path = path
                } else if valueType.containsString("CATransform3D") {
                    let fromTransform = self.fromValue.CATransform3DValue
                    let toTransform = self.toValue.CATransform3DValue

                    let m11 = self.valueArrayFor(startValue: fromTransform.m11, endValue: toTransform.m11)
                    let m12 = self.valueArrayFor(startValue: fromTransform.m12, endValue: toTransform.m12)
                    let m13 = self.valueArrayFor(startValue: fromTransform.m13, endValue: toTransform.m13)
                    let m14 = self.valueArrayFor(startValue: fromTransform.m14, endValue: toTransform.m14)
                    let m21 = self.valueArrayFor(startValue: fromTransform.m21, endValue: toTransform.m21)
                    let m22 = self.valueArrayFor(startValue: fromTransform.m22, endValue: toTransform.m22)
                    let m23 = self.valueArrayFor(startValue: fromTransform.m23, endValue: toTransform.m23)
                    let m24 = self.valueArrayFor(startValue: fromTransform.m24, endValue: toTransform.m24)
                    let m31 = self.valueArrayFor(startValue: fromTransform.m31, endValue: toTransform.m31)
                    let m32 = self.valueArrayFor(startValue: fromTransform.m32, endValue: toTransform.m32)
                    let m33 = self.valueArrayFor(startValue: fromTransform.m33, endValue: toTransform.m33)
                    let m34 = self.valueArrayFor(startValue: fromTransform.m34, endValue: toTransform.m34)
                    let m41 = self.valueArrayFor(startValue: fromTransform.m41, endValue: toTransform.m41)
                    let m42 = self.valueArrayFor(startValue: fromTransform.m42, endValue: toTransform.m42)
                    let m43 = self.valueArrayFor(startValue: fromTransform.m43, endValue: toTransform.m43)
                    let m44 = self.valueArrayFor(startValue: fromTransform.m44, endValue: toTransform.m44)

                    self.values = self.createTransformArrayFrom(
                        m11: m11, m12: m12, m13: m13, m14: m14,
                        m21: m21, m22: m22, m23: m23, m24: m24,
                        m31: m31, m32: m32, m33: m33, m34: m34,
                        m41: m41, m42: m42, m43: m43, m44: m44) as [AnyObject]
                }
            }
            self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        }
    }

    private func createTransformArrayFrom(
        #m11: NSArray, m12: NSArray, m13: NSArray, m14: NSArray,
        m21: NSArray, m22: NSArray, m23: NSArray, m24: NSArray,
        m31: NSArray, m32: NSArray, m33: NSArray, m34: NSArray,
        m41: NSArray, m42: NSArray, m43: NSArray, m44: NSArray) -> NSArray {
            let numberOfTransforms = m11.count;
            var values = NSMutableArray(capacity: numberOfTransforms)
            var value: CATransform3D!
            for (var i = 1; i < numberOfTransforms; i++) {
                value = CATransform3DIdentity;
                value.m11 = CGFloat(m11.objectAtIndex(i).floatValue)
                value.m12 = CGFloat(m12.objectAtIndex(i).floatValue)
                value.m13 = CGFloat(m13.objectAtIndex(i).floatValue)
                value.m14 = CGFloat(m14.objectAtIndex(i).floatValue)

                value.m21 = CGFloat(m21.objectAtIndex(i).floatValue)
                value.m22 = CGFloat(m22.objectAtIndex(i).floatValue)
                value.m23 = CGFloat(m23.objectAtIndex(i).floatValue)
                value.m24 = CGFloat(m24.objectAtIndex(i).floatValue)

                value.m31 = CGFloat(m31.objectAtIndex(i).floatValue)
                value.m32 = CGFloat(m32.objectAtIndex(i).floatValue)
                value.m33 = CGFloat(m33.objectAtIndex(i).floatValue)
                value.m44 = CGFloat(m34.objectAtIndex(i).floatValue)

                value.m41 = CGFloat(m41.objectAtIndex(i).floatValue)
                value.m42 = CGFloat(m42.objectAtIndex(i).floatValue)
                value.m43 = CGFloat(m43.objectAtIndex(i).floatValue)
                value.m44 = CGFloat(m44.objectAtIndex(i).floatValue)

                values.addObject(NSValue(CATransform3D: value))
            }
            return values
    }

    private func createPathFromXYValues(xValues: NSArray, yValues: NSArray) -> CGPathRef {
        let numberOfPoints = xValues.count
        let path = CGPathCreateMutable()
        var value = CGPoint(
            x: CGFloat(xValues.objectAtIndex(0).floatValue),
            y: CGFloat(yValues.objectAtIndex(0).floatValue))
        CGPathMoveToPoint(path, nil, value.x, value.y)
        for i in 1..<numberOfPoints {
            value = CGPoint(
                x: CGFloat(xValues.objectAtIndex(i).floatValue),
                y: CGFloat(yValues.objectAtIndex(i).floatValue))
            CGPathAddLineToPoint(path, nil, value.x, value.y)
        }
        return path
    }

    private func valueIsKindOf(klass: AnyClass) -> Bool {
        return self.fromValue.isKindOfClass(klass) && self.toValue.isKindOfClass(klass)
    }

    private func rectArrayFrom(#xValues: [CGFloat], yValues: [CGFloat], widthValues: [CGFloat], heightValues: [CGFloat]) -> NSArray {
        let numberOfRects = xValues.count
        var values: NSMutableArray = []
        var value: NSValue

        for i in 1..<numberOfRects {
            value = NSValue(CGRect: CGRect(x: xValues[i], y: yValues[i], width: widthValues[i], height: heightValues[i]))
            values.addObject(value)
        }
        return values

    }

    private func colorArrayFrom(#redValues: [CGFloat], greenValues: [CGFloat], blueValues: [CGFloat], alphaValues: [CGFloat]) -> [CGColor] {
        let numberOfColors = redValues.count
        var values: [CGColor] = []
        var value: CGColor!

        for i in 1..<numberOfColors {
            value = UIColor(red: redValues[i], green: greenValues[i], blue: blueValues[i], alpha: alphaValues[i]).CGColor
            values.append(value)
        }
        return values
    }

    private func valueArrayFor(#startValue: CGFloat, endValue: CGFloat) -> NSArray {
        let startValue = Double(startValue)
        let endValue = Double(endValue)

        let steps: Int = Int(ceil(Double(kFPS) * self.duration)) + 2
        let increment = 1.0 / (Double)(steps - 1)
        var progress = 0.0
        var v = 0.0
        var value = 0.0

        var valueArray: [Double] = []

        for i in 0..<steps {
            v = self.functionBlock(self.duration * progress * 1000, 0, 1, self.duration * 1000);
            value = startValue + v * (endValue - startValue);

            valueArray.append(value)
            progress += increment
        }

        return valueArray
    }

}
