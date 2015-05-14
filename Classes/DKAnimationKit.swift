//
//  DKAnimationKit.swift
//  DKAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

class DKAnimationKit: NSObject {

    var view: UIView!

    typealias AnimationCalculationAction = UIView -> Void
    typealias AnimationCompletionAction = UIView -> Void

    var animationCalculationActions: [[AnimationCalculationAction]]!
    var animationCompletionActions: [[AnimationCompletionAction]]!
    var animationGroups: NSMutableArray!
    var animations: [[DKKeyFrameAnimation]]!
    var animationCompletion: (Void -> Void)?

    // MARK: - Initialize

    override init() {
        super.init()
        self.setup()
    }

    func setup() {
        self.animations = [[]]
        self.animationGroups = [self.basicAnimationGroup()]
        self.animationCompletionActions = [[]]
        self.animationCalculationActions = [[]]
    }

    private func clear() {
        self.animations.removeAll()
        self.animationGroups.removeAllObjects()
        self.animationCompletionActions.removeAll()
        self.animationCalculationActions.removeAll()
        self.animations.append([])
        self.animationCompletionActions.append([AnimationCalculationAction]())
        self.animationCalculationActions.append([AnimationCompletionAction]())
        self.animationGroups.addObject(self.basicAnimationGroup())
    }

    // MARK: - Animation Properties

    internal func makeFrame(rect: CGRect) -> DKAnimationKit {
        return self.makeOrigin(rect.origin.x, rect.origin.y).makeBounds(rect)
    }

    internal func makeBounds(rect: CGRect) -> DKAnimationKit {
        return self.makeSize(rect.size.width, rect.size.height)
    }

    internal func makeSize(width: CGFloat, _ height: CGFloat) -> DKAnimationKit {

        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let sizeAnimation = self.basicAnimationForKeyPath("bounds.size")
            sizeAnimation.fromValue = NSValue(CGSize: view.layer.bounds.size)
            sizeAnimation.toValue = NSValue(CGSize: CGSize(width: width, height: height))
            self.addAnimationFromCalculationBlock(sizeAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var bounds = CGRect(x: 0, y: 0, width: width, height: height)
            view.layer.bounds = bounds
            view.bounds = bounds
        }
        return self
    }

    internal func makeOrigin(x: CGFloat, _ y: CGFloat) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position")
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: y))
            positionAnimation.fromValue = NSValue(CGPoint: view.layer.position)
            positionAnimation.toValue = NSValue(CGPoint: newPosition)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: y))
            view.layer.position = newPosition
        }
        return self

    }

    internal func makeCenter(x: CGFloat, _ y: CGFloat) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position")
            let newPosition = self.newPositionFrom(newCenter: CGPoint(x: x, y: y))
            positionAnimation.fromValue = NSValue(CGPoint: view.layer.position)
            positionAnimation.toValue = NSValue(CGPoint: newPosition)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.center = CGPoint(x: x, y: y)
        }
        return self
    }

    internal func makeX(x: CGFloat) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.x")
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: view.layer.frame.origin.y))
            positionAnimation.fromValue = view.layer.position.x
            positionAnimation.toValue = newPosition.x
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: view.layer.frame.origin.y))
            view.layer.position = newPosition
        }
        return self
    }

    internal func makeY(y: CGFloat) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.y")
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: view.layer.frame.origin.x, y: y))
            positionAnimation.fromValue = view.layer.position.y
            positionAnimation.toValue = newPosition.y
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: view.layer.frame.origin.x, y: y))
            view.layer.position = newPosition
        }
        return self
    }

    internal func makeWidth(width: CGFloat) -> DKAnimationKit {
        return self.makeSize(width, self.view.layer.frame.size.height)
    }

    internal func makeHeight(height: CGFloat) -> DKAnimationKit {
        return self.makeOrigin(self.view.layer.frame.size.width, height)
    }

    internal func makeOpacity(opacity: CGFloat) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let opacityAnimation = self.basicAnimationForKeyPath("opacity")
            opacityAnimation.fromValue = view.alpha
            opacityAnimation.toValue = opacity
            self.addAnimationFromCalculationBlock(opacityAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.alpha = opacity
        }
        return self
    }

    internal func makeBackground(color: UIColor) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let backgroundColorAnimation = self.basicAnimationForKeyPath("backgroundColor")
            backgroundColorAnimation.fromValue = view.backgroundColor
            backgroundColorAnimation.toValue = color
            self.addAnimationFromCalculationBlock(backgroundColorAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.backgroundColor = color
        }
        return self
    }

    internal func makeBorderColor(color: UIColor) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let borderColorAnimation = self.basicAnimationForKeyPath("borderColor")
            borderColorAnimation.fromValue = view.layer.borderColor
            borderColorAnimation.toValue = color
            self.addAnimationFromCalculationBlock(borderColorAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.layer.borderColor = color.CGColor
        }
        return self
    }

    internal func makeBorderWidth(width: CGFloat) -> DKAnimationKit {
        let width = max(0, width)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let borderColorAnimation = self.basicAnimationForKeyPath("borderWidth")
            borderColorAnimation.fromValue = view.layer.borderWidth
            borderColorAnimation.toValue = width
            self.addAnimationFromCalculationBlock(borderColorAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.layer.borderWidth = width
        }
        return self
    }

    internal func makeCornerRadius(cornerRadius: CGFloat) -> DKAnimationKit {
        let cornerRadius = max(0, cornerRadius)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let cornerRadiusAnimation = self.basicAnimationForKeyPath("cornerRadius")
            cornerRadiusAnimation.fromValue = view.layer.cornerRadius
            cornerRadiusAnimation.toValue = cornerRadius
            self.addAnimationFromCalculationBlock(cornerRadiusAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.layer.cornerRadius = cornerRadius
        }
        return self
    }

    internal func makeScale(scale: CGFloat) -> DKAnimationKit {
        let scale = max(0, scale)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let scaleAnimation = self.basicAnimationForKeyPath("bounds")
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * scale, 0), height: max(view.bounds.size.height * scale, 0))
            scaleAnimation.fromValue = NSValue(CGRect: view.layer.bounds)
            scaleAnimation.toValue = NSValue(CGRect: rect)
            self.addAnimationFromCalculationBlock(scaleAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * scale, 0), height: max(view.bounds.size.height * scale, 0))
            view.layer.bounds = rect
            view.bounds = rect
        }
        return self
    }

    internal func makeScaleX(xScale: CGFloat) -> DKAnimationKit {
        let xScale = max(0, xScale)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let scaleAnimation = self.basicAnimationForKeyPath("bounds")
            let rect = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: max(view.bounds.size.height * xScale, 0))
            scaleAnimation.fromValue = NSValue(CGRect: view.layer.bounds)
            scaleAnimation.toValue = NSValue(CGRect: rect)
            self.addAnimationFromCalculationBlock(scaleAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let rect = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: max(view.bounds.size.height * xScale, 0))
            view.layer.bounds = rect
            view.bounds = rect
        }
        return self
    }

    internal func makeScaleY(yScale: CGFloat) -> DKAnimationKit {
        let yScale = max(0, yScale)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let scaleAnimation = self.basicAnimationForKeyPath("bounds")
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * yScale, 0), height: view.bounds.size.height)
            scaleAnimation.fromValue = NSValue(CGRect: view.layer.bounds)
            scaleAnimation.toValue = NSValue(CGRect: rect)
            self.addAnimationFromCalculationBlock(scaleAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * yScale, 0), height: view.bounds.size.height)
            view.layer.bounds = rect
            view.bounds = rect
        }
        return self
    }

    // MARK: - Anchor

    private func makeAnchorFrom(#x: CGFloat, y: CGFloat) {
        let anchorPoint = CGPoint(x: x, y: y)
        func action(view: UIView) {
            if CGPointEqualToPoint(anchorPoint, view.layer.anchorPoint) {
                return
            }
            var newPoint = CGPoint(
                x: view.bounds.size.width * anchorPoint.x,
                y: view.bounds.size.height * anchorPoint.y
            )
            var oldPoint = CGPoint(
                x: view.bounds.size.width * view.layer.anchorPoint.x,
                y: view.bounds.size.height * view.layer.anchorPoint.y
            )
            newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
            oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)

            var position = view.layer.position

            position.x -= oldPoint.x
            position.x += newPoint.x

            position.y -= oldPoint.y
            position.y += newPoint.y

            view.layer.position = position
            view.layer.anchorPoint = anchorPoint
        }

        if var lastCalculationActions = self.animationCalculationActions.last {
            lastCalculationActions.insert(action, atIndex: 0)
            self.animationCalculationActions.removeLast()
            self.animationCalculationActions.append(lastCalculationActions)
        }
    }

    internal func makeAnchor(x: CGFloat, _ y: CGFloat) -> DKAnimationKit {
        self.makeAnchorFrom(x: x, y: y)
        return self
    }

    internal var anchorDefault: DKAnimationKit {
        get {
            return self.anchorCenter
        }
    }

    internal var anchorCenter: DKAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.5, y: 0.5)
            return self
        }
    }

    internal var anchorTopLeft: DKAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.0, y: 0.0)
            return self
        }
    }

    internal var anchorTopRight: DKAnimationKit {
        get {
            self.makeAnchorFrom(x: 1.0, y: 0.0)
            return self
        }
    }

    internal var anchorBottomLeft: DKAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.0, y: 1.0)
            return self
        }
    }

    internal var anchorBottomRight: DKAnimationKit {
        get {
            self.makeAnchorFrom(x: 1.0, y: 1.0)
            return self
        }
    }

    internal var anchorTop: DKAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.5, y: 0.0)
            return self
        }
    }

    internal var anchorBottom: DKAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.5, y: 1.0)
            return self
        }
    }

    internal var anchorLeft: DKAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.0, y: 0.5)
            return self
        }
    }

    internal var anchorRight: DKAnimationKit {
        get {
            self.makeAnchorFrom(x: 1.0, y: 0.5)
            return self
        }
    }

    // MARK: - Move

    internal func moveX(x: CGFloat) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.x")
            positionAnimation.fromValue = view.layer.position.x
            positionAnimation.toValue = view.layer.position.x + x
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var position = view.layer.position
            position.x += x
            view.layer.position = position
        }
        return self
    }

    internal func moveY(y: CGFloat) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.y")
            positionAnimation.fromValue = view.layer.position.y
            positionAnimation.toValue = view.layer.position.y + y
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var position = view.layer.position
            position.y += y
            view.layer.position = position
        }
        return self
    }

    internal func moveXY(x :CGFloat, _ y: CGFloat) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position")
            let oldOrigin = view.layer.frame.origin
            let newPosition = CGPoint(x: view.layer.position.x + x, y: view.layer.position.y + y)
            positionAnimation.fromValue = NSValue(CGPoint: oldOrigin)
            positionAnimation.toValue = NSValue(CGPoint: newPosition)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var position = view.layer.position
            position.x += x
            position.y += y
            view.layer.position = position
        }
        return self
    }

    internal func moveHeight(height: CGFloat) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("bounds.size")
            let newSize = CGSize(width: view.layer.bounds.size.width, height: max(view.layer.bounds.size.width + height, 0))
            positionAnimation.fromValue = NSValue(CGSize: view.layer.bounds.size)
            positionAnimation.toValue = NSValue(CGSize: newSize)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newSize = CGSize(width: view.layer.bounds.size.width, height: max(view.layer.bounds.size.width + height, 0))
            let bounds = CGRect(origin: CGPointZero, size: newSize)
            view.layer.bounds = bounds
            view.bounds = bounds
        }
        return self
    }

    internal func moveWidth(width: CGFloat) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("bounds.size")
            let newSize = CGSize(width: max(view.layer.bounds.size.width + width, 0), height: view.layer.bounds.size.height)
            positionAnimation.fromValue = NSValue(CGSize: view.layer.bounds.size)
            positionAnimation.toValue = NSValue(CGSize: newSize)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newSize = CGSize(width: max(view.layer.bounds.size.width + width, 0), height: view.layer.bounds.size.height)
            let bounds = CGRect(origin: CGPointZero, size: newSize)
            view.layer.bounds = bounds
            view.bounds = bounds
        }
        return self
    }

    internal func movePolar(radius: Double, _ angle: Double) -> DKAnimationKit {
        let radians  = self.degreesToRadians(angle)
        let x = CGFloat(radius * cos(radians))
        let y = CGFloat(-radius * sin(radians))
        return self.moveXY(x, y)
    }

    internal func rotate(angle: Double) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let rotationAnimation = self.basicAnimationForKeyPath("transform.rotation")
            let transform = view.layer.transform
            let originalRotation = Double(atan2(transform.m12, transform.m11))
            rotationAnimation.fromValue = originalRotation
            rotationAnimation.toValue = originalRotation + self.degreesToRadians(angle)
            self.addAnimationFromCalculationBlock(rotationAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let transform = view.layer.transform
            let originalRotation = Double(atan2(transform.m12, transform.m11))
            let zRotation = CATransform3DMakeRotation(CGFloat(self.degreesToRadians(angle) + originalRotation), 0.0, 0.0, 1.0)
            view.layer.transform = zRotation
        }
        return self
    }

    // MARK: - Bezier

    internal func moveOnPath(path: UIBezierPath) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let pathAnimation = self.basicAnimationForKeyPath("position")
            pathAnimation.path = path.CGPath
            self.addAnimationFromCalculationBlock(pathAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let endPoint = path.currentPoint
            view.layer.position = endPoint
        }
        return self
    }

    internal func moveAndRotateOnPath(path: UIBezierPath) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let pathAnimation = self.basicAnimationForKeyPath("position")
            pathAnimation.path = path.CGPath
            pathAnimation.rotationMode = kCAAnimationRotateAuto
            self.addAnimationFromCalculationBlock(pathAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let endPoint = path.currentPoint
            view.layer.position = endPoint
        }
        return self
    }

    internal func moveAndReverseRotateOnPath(path: UIBezierPath) -> DKAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let pathAnimation = self.basicAnimationForKeyPath("position")
            pathAnimation.path = path.CGPath
            pathAnimation.rotationMode = kCAAnimationRotateAutoReverse
            self.addAnimationFromCalculationBlock(pathAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let endPoint = path.currentPoint
            view.layer.position = endPoint
        }
        return self
    }

    // MARK: - Animation Effects

    internal var easeIn: DKAnimationKit {
        get {
            self.easeInQuad
            return self
        }
    }

    internal var easeOut: DKAnimationKit {
        get {
            self.easeOutQuad
            return self
        }
    }

    internal var easeInOut: DKAnimationKit {
        get {
            self.easeInOutQuad
            return self
        }
    }

    internal var easeBack: DKAnimationKit {
        get {
            self.easeOutBack
            return self
        }
    }

    internal var spring: DKAnimationKit {
        get {
            self.easeOutElastic
            return self
        }
    }

    internal var bounce: DKAnimationKit {
        get { 
            self.easeOutBounce
            return self         
        }
    }

    internal var easeInQuad: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInQuad)
            return self
        }
    }

    internal var easeOutQuad: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutQuad)
            return self
        }
    }

    internal var easeInOutQuad: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutQuad)
            return self
        }
    }

    internal var easeInCubic: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInCubic)
            return self
        }
    }

    internal var easeOutCubic: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutCubic)
            return self
        }
    }

    internal var easeInOutCubic: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutCubic)
            return self
        }
    }

    internal var easeInQuart: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInQuart)
            return self
        }
    }

    internal var easeOutQuart: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutQuart)
            return self
        }
    }

    internal var easeInOutQuart: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutQuart)
            return self
        }
    }

    internal var easeInQuint: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInQuint)
            return self
        }
    }

    internal var easeOutQuint: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutQuint)
            return self
        }
    }

    internal var easeInOutQuint: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutQuint)
            return self
        }
    }

    internal var easeInSine: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInSine)
            return self
        }
    }

    internal var easeOutSine: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutSine)
            return self
        }
    }

    internal var easeInOutSine: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutSine)
            return self
        }
    }

    internal var easeInExpo: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInExpo)
            return self
        }
    }

    internal var easeOutExpo: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutExpo)
            return self
        }
    }

    internal var easeInOutExpo: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutExpo)
            return self
        }
    }

    internal var easeInCirc: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInCirc)
            return self
        }
    }

    internal var easeOutCirc: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutCirc)
            return self
        }
    }

    internal var easeInOutCirc: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutCirc)
            return self
        }
    }

    internal var easeInElastic: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInElastic)
            return self
        }
    }

    internal var easeOutElastic: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutElastic)
            return self
        }
    }

    internal var easeInOutElastic: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutElastic)
            return self
        }
    }

    internal var easeInBack: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInBack)
            return self
        }
    }

    internal var easeOutBack: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutBack)
            return self
        }
    }

    internal var easeInOutBack: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutBack)
            return self
        }
    }

    internal var easeInBounce: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInBounce)
            return self
        }
    }

    internal var easeOutBounce: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutBounce)
            return self
        }
    }

    internal var easeInOutBounce: DKAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutBounce)
            return self
        }
    }

    private func addAnimationKeyframeCalculation(functionBlock: NSBKeyframeAnimationFunctionBlock) {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let animationCluster = self.animations.first
            if let animation = animationCluster?.last {
                animation.functionBlock = functionBlock
            }
        }
    }

    // MARK: - Animation Time

    internal func delay(delay: NSTimeInterval) -> DKAnimationKit {
        var delay = delay
        for group in self.animationGroups {
            let duration = group.duration as NSTimeInterval
            delay += duration
        }
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.beginTime = CACurrentMediaTime() + delay
        }
        return self
    }

    internal func wait(delay: NSTimeInterval) -> DKAnimationKit {
        return self.delay(delay)
    }

    internal func animate(duration: NSTimeInterval) -> DKAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = duration
            self.animateChain()
        }
        return self
    }

    internal func thenAfter(after: NSTimeInterval) -> DKAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = after
            let newGroup = self.basicAnimationGroup()
            self.animationGroups.addObject(newGroup)
            self.animations.append([])
            self.animationCalculationActions.append([])
            self.animationCompletionActions.append([])
        }
        return self
    }

    internal func animateWithCompletion(duration: NSTimeInterval, completion: Void -> Void) -> DKAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = duration
            self.animationCompletion = completion
            self.animateChain()
        }
        return self
    }

    private func degreesToRadians(degree: Double) -> Double {
        return (degree / 180.0) * M_PI
    }

    private func animateChain() {
        self.sanityCheck()
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.view.layer.removeAnimationForKey("AnimationChain")
            self.chainLinkDidFinishAnimating()
        }
        self.animateChainLink()
        CATransaction.commit()

        self.executeCompletionActions()
    }

    private func animateChainLink() {
        self.makeAnchor(0.5, 0.5)
        if let animationCluster = self.animationCalculationActions.first {
            for action in animationCluster {
                action(self.view)
            }
        }
        if let group: CAAnimationGroup = self.animationGroups.firstObject as? CAAnimationGroup, animationCluster: [DKKeyFrameAnimation] = self.animations.first {
            for animation in animationCluster {
                animation.duration = group.duration
                animation.calculte()
            }
            group.animations = animationCluster
            self.view.layer.addAnimation(group, forKey: "AnimationChain")
        }
    }

    private func executeCompletionActions() {
        if let group = self.animationGroups.firstObject as? CAAnimationGroup {
            let delay = max(group.beginTime - CACurrentMediaTime(), 0.0)
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                if let actionCluster: [AnimationCompletionAction] = self.animationCompletionActions.first {
                    for action in actionCluster {
                        action(self.view)
                    }
                }
            }
        }
    }

    private func chainLinkDidFinishAnimating() {
        self.animationCompletionActions.removeAtIndex(0)
        self.animationCalculationActions.removeAtIndex(0)
        self.animations.removeAtIndex(0)
        self.animationGroups.removeObjectAtIndex(0)

        if self.animationGroups.count == 0 {
            self.clear()
            if let completion = self.animationCompletion {
                self.animationCompletion = nil
                completion()
            }
        } else {
            self.animateChain()
        }
    }

    private func sanityCheck() {
        assert(self.animations.count == self.animationGroups.count, "FATAL ERROR: ANIMATION GROUPS AND ANIMATIONS ARE OUT OF SYNC");
        assert(self.animationCalculationActions.count == self.animationCompletionActions.count, "FATAL ERROR: ANIMATION CALCULATION OBJECTS AND ANIMATION COMPLETION OBJECTS ARE OUT OF SYNC");
        assert(self.animations.count == self.animationCompletionActions.count, "FATAL ERROR: ANIMATIONS AND ANIMATION COMPLETION OBJECTS ARE OUT OF SYNC");
    }

    // MARK: - Animation Action

    private func addAnimationCalculationAction(action: AnimationCalculationAction) {
        if var actions = self.animationCalculationActions.last as [AnimationCalculationAction]? {
            actions.append(action)
            self.animationCalculationActions.removeLast()
            self.animationCalculationActions.append(actions)
        }
    }

    private func addAnimationCompletionAction(action: AnimationCompletionAction) {
        if var actions = self.animationCompletionActions.last as [AnimationCompletionAction]? {
            actions.append(action)
            self.animationCompletionActions.removeLast()
            self.animationCompletionActions.append(actions)
        }
    }

    private func addAnimationFromCalculationBlock(animation: DKKeyFrameAnimation) {
        if var animationCluster = self.animations.first {
            animationCluster.append(animation)
            self.animations.removeAtIndex(0)
            self.animations.insert(animationCluster, atIndex: 0)
        }
    }

    // MARK: - Basic Animation Helper

    private func basicAnimationGroup() -> CAAnimationGroup {
        return CAAnimationGroup()
    }
    
    private func basicAnimationForKeyPath(keyPath: String) -> DKKeyFrameAnimation {
        let animation = DKKeyFrameAnimation(keyPath: keyPath)
        animation.repeatCount = 0
        animation.autoreverses = false

        return animation
    }

    private func newPositionFrom(#newOrigin: CGPoint) -> CGPoint {
        let anchor = self.view.layer.anchorPoint
        let size = self.view.bounds.size
        let newPosition = CGPoint(x: newOrigin.x + anchor.x * size.width, y: newOrigin.y + anchor.y * size.height)
        return newPosition
    }

    private func newPositionFrom(#newCenter: CGPoint) -> CGPoint {
        let anchor = self.view.layer.anchorPoint
        let size = self.view.bounds.size
        let newPosition = CGPoint(x: newCenter.x + (anchor.x - 0.5) * size.width, y: newCenter.y + (anchor.y - 0.5) * size.height)
        return newPosition
    }

}
