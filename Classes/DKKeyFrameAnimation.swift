//
//  DKKeyFrameAnimation.swift
//  DKAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

public class DKKeyFrameAnimation: CAKeyframeAnimation {

    let kFPS = 60

    public typealias NSBKeyframeAnimationFunction = (Double, Double, Double, Double) -> Double;

    public var fromValue: AnyObject!
    public var toValue: AnyObject!
    public var functionBlock: NSBKeyframeAnimationFunction!

    convenience init(keyPath path: String!) {
        self.init()
        self.keyPath = path
        self.functionBlock = NSBKeyframeAnimationFunctionLinear
    }

    func calculte() {
        self.createValueArray()
    }

    func createValueArray() {
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
                }
            }
            self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        }
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