//
//  DKAnimationKit.swift
//  DKAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

class DKAnimationKit: NSObject {

    weak var view: UIView!

    typealias AnimationCalculationAction = UIView -> Void
    typealias AnimationCompletionAction = UIView -> Void

    var animationCalculationActions: [[AnimationCalculationAction]]!

    var animationCompletionActions: [[AnimationCompletionAction]]!

    var animationGroups: NSMutableArray!

    var animations: [[DKKeyFrameAnimation]]!

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
            var rect = view.frame
            rect.origin.x = x
            rect.origin.y = y
            view.layer.frame = rect
            view.frame = rect
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
        return self.makeOrigin(x, self.view.layer.frame.origin.y)
    }

    internal func makeY(y: CGFloat) -> DKAnimationKit {
        return self.makeOrigin(self.view.layer.frame.origin.x, y)
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

        let chainCount = self.animationCompletionActions.count
        if chainCount == 1 {
            action(self.view)
        } else {
            self.animationCompletionActions[chainCount - 2].append(action)
        }
    }

    internal func makeAnchor(x: CGFloat, _ y: CGFloat) -> DKAnimationKit {
        self.makeAnchorFrom(x: x, y: y)
        return self
    }

    internal func moveX(x: CGFloat) -> DKAnimationKit {

        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let translationAnimation = self.basicAnimationForKeyPath("transform.translation.x")
            translationAnimation.fromValue = 0
            translationAnimation.toValue = x
            self.addAnimationFromCalculationBlock(translationAnimation)
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
            let translationAnimation = self.basicAnimationForKeyPath("transform.translation.y")
            translationAnimation.fromValue = 0
            translationAnimation.toValue = y
            self.addAnimationFromCalculationBlock(translationAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var position = view.layer.position
            position.y += y
            view.layer.position = position
        }
        return self
    }

    internal func moveXY(x :CGFloat, _ y: CGFloat) -> DKAnimationKit {
        return self.moveX(x).moveY(y)
    }

    internal func moveHeight(height: CGFloat) -> DKAnimationKit {
        return self.makeSize(self.view.bounds.size.width, max(self.view.bounds.size.height + height, 0))
    }

    internal func moveWidth(width: CGFloat) -> DKAnimationKit {
        return self.makeSize(max(self.view.bounds.size.width + width, 0), self.view.bounds.size.height)
    }

    private func degreesToRadians(degree: Double) -> Double {
        return degree / 180.0 * M_PI
    }

    internal func rotate(angle: Double) -> DKAnimationKit {

        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let rotationAnimation = self.basicAnimationForKeyPath("transform.rotation.z")
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

    internal func movePolar(radius: Double, _ angle: Double) -> DKAnimationKit {
        let radians  = self.degreesToRadians(angle)
        let x = CGFloat(radius * cos(radians))
        let y = CGFloat(-radius * sin(radians))
        return self.moveXY(x, y)
    }

    internal func anchorDefault() -> DKAnimationKit {
        return self.anchorCenter()
    }

    internal func anchorCenter() -> DKAnimationKit {
        self.makeAnchorFrom(x: 0.5, y: 0.5)
        return self
    }

    internal func anchorTopLeft() -> DKAnimationKit {
        self.makeAnchorFrom(x: 0.0, y: 0.0)
        return self
    }

    internal func anchorTopRight() -> DKAnimationKit {
        self.makeAnchorFrom(x: 1.0, y: 0.0)
        return self
    }

    internal func anchorBottomLeft() -> DKAnimationKit {
        self.makeAnchorFrom(x: 0.0, y: 1.0)
        return self
    }

    internal func anchorBottomRight() -> DKAnimationKit {
        self.makeAnchorFrom(x: 1.0, y: 1.0)
        return self
    }

    internal func anchorTop() -> DKAnimationKit {
        self.makeAnchorFrom(x: 0.5, y: 0.0)
        return self
    }

    internal func anchorBottom() -> DKAnimationKit {
        self.makeAnchorFrom(x: 0.5, y: 1.0)
        return self
    }

    internal func anchorLeft() -> DKAnimationKit {
        self.makeAnchorFrom(x: 1.0, y: 0.5)
        return self
    }

    internal func anchorRight() -> DKAnimationKit {
        self.makeAnchorFrom(x: 0.0, y: 0.5)
        return self
    }

    internal var easeIn: DKAnimationKit {
        get {
            self.easeInQuad()
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

    private func easeInQuad() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInQuad)
        return self
    }

    private func easeOutQuad() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutQuad)
        return self
    }

    private func easeInOutQuad() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutQuad)
        return self
    }

    private func easeInCubic() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInCubic)
        return self
    }

    private func easeOutCubic() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutCubic)
        return self
    }

    private func easeInOutCubic() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutCubic)
        return self
    }

    private func easeInQuart() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInQuart)
        return self
    }

    private func easeOutQuart() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutQuart)
        return self
    }

    private func easeInOutQuart() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutQuart)
        return self
    }

    private func easeInQuint() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInQuint)
        return self
    }

    private func easeOutQuint() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutQuint)
        return self
    }

    private func easeInOutQuint() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutQuint)
        return self
    }

    private func easeInSine() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInSine)
        return self
    }

    private func easeOutSine() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutSine)
        return self
    }

    private func easeInOutSine() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutSine)
        return self
    }

    private func easeInExpo() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInExpo)
        return self
    }

    private func easeOutExpo() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutExpo)
        return self
    }

    private func easeInOutExpo() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutExpo)
        return self
    }

    private func easeInCirc() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInCirc)
        return self
    }

    private func easeOutCirc() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutCirc)
        return self
    }

    private func easeInOutCirc() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutCirc)
        return self
    }

    private func easeInElastic() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInElastic)
        return self
    }

    private func easeOutElastic() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutElastic)
        return self
    }

    private func easeInOutElastic() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutElastic)
        return self
    }

    private func easeInBack() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInBack)
        return self
    }

    private func easeOutBack() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutBack)
        return self
    }

    private func easeInOutBack() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutBack)
        return self
    }
    
    private func easeInBounce() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInBounce)
        return self
    }
    
    private func easeOutBounce() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseOutBounce)
        return self
    }
    
    private func easeInOutBounce() -> DKAnimationKit {
        self.addAnimationKeyframeCalculation(NSBKeyframeAnimationFunctionEaseInOutBounce)
        return self
    }


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

    private func animateChain() {
        self.sanityCheck()
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.view.layer.removeAnimationForKey("AnimationChain")
            self.chainLinkDidFinishAnimating()
        }
        self.animateChainLink()
        CATransaction.commit()
    }

    private func animateChainLink() {
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

    private func chainLinkDidFinishAnimating() {
        if let actionCluster: [AnimationCompletionAction] = self.animationCompletionActions.first {
            for action in actionCluster {
                action(self.view)
            }
        }
        self.animationCompletionActions.removeAtIndex(0)
        self.animationCalculationActions.removeAtIndex(0)
        self.animations.removeAtIndex(0)
        self.animationGroups.removeObjectAtIndex(0)

        if self.animationGroups.count == 0 {
            self.clear()
        } else {
            self.animateChain()
        }
    }

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


    private func sanityCheck() {
        
    }

}
