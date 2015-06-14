//
//  DKChainableAnimationKit.swift
//  DKChainableAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

public class DKChainableAnimationKit {

    weak var view: UIView!

    typealias AnimationCalculationAction = UIView -> Void
    typealias AnimationCompletionAction = UIView -> Void

    internal var animationCalculationActions: [[AnimationCalculationAction]]!
    internal var animationCompletionActions: [[AnimationCompletionAction]]!
    internal var animationGroups: NSMutableArray!
    internal var animations: [[DKKeyFrameAnimation]]!
    public var animationCompletion: (Void -> Void)?


    // MARK: - Initialize

    init() {
        self.setup()
    }

    private func setup() {
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

    // MARK: - Animation Time

    public func delay(delay: NSTimeInterval) -> DKChainableAnimationKit {
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

    public func delay(time: CGFloat) -> DKChainableAnimationKit {
        return delay(NSTimeInterval(time))
    }

    public var seconds: DKChainableAnimationKit {
        get {
            return self
        }
    }

    public func wait(delay: NSTimeInterval) -> DKChainableAnimationKit {
        return self.delay(delay)
    }

    public func animate(duration: NSTimeInterval) -> DKChainableAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = duration
            self.animateChain()
        }
        return self
    }

    public func animate(duration: CGFloat) -> DKChainableAnimationKit {
        return animate(NSTimeInterval(duration))
    }

//    public func animateWithRepeat(duration: NSTimeInterval) -> DKChainableAnimationKit {
//        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
//            group.duration = duration
//            saveAnimations()
//            animationCompletion = {
//                self.restoreAnimations()
//                self.animateChain()
//            }
//            self.animateChain()
//        }
//        return self
//    }
//
//    internal var tempAnimationCalculationActions: [[AnimationCalculationAction]]!
//    internal var tempAnimationCompletionActions: [[AnimationCompletionAction]]!
//    internal var tempAnimationGroups: NSMutableArray!
//    internal var tempAnimations: [[DKKeyFrameAnimation]]!
//
//    internal func saveAnimations() {
//        self.tempAnimationCalculationActions = self.animationCalculationActions
//        self.tempAnimationCompletionActions = self.animationCompletionActions
//        self.tempAnimationGroups = self.animationGroups.mutableCopy() as! NSMutableArray
//        self.tempAnimations = self.animations
//    }
//
//    internal func restoreAnimations() {
//        self.animationCalculationActions = self.tempAnimationCalculationActions
//        self.animationCompletionActions = self.tempAnimationCompletionActions
//        self.animationGroups = self.tempAnimationGroups.mutableCopy() as! NSMutableArray
//        self.animations = self.tempAnimations
//    }

    public func thenAfter(after: NSTimeInterval) -> DKChainableAnimationKit {
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

    public func thenAfter(after: CGFloat) -> DKChainableAnimationKit {
        return thenAfter(NSTimeInterval(after))
    }

    public func animateWithCompletion(duration: NSTimeInterval, _ completion: Void -> Void) -> DKChainableAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = duration
            self.animationCompletion = completion
            self.animateChain()
        }
        return self
    }

    public func animateWithCompletion(duration: CGFloat, _ completion: Void -> Void) -> DKChainableAnimationKit {
        return animateWithCompletion(NSTimeInterval(duration), completion)
    }

    internal func degreesToRadians(degree: Double) -> Double {
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
        if let group: CAAnimationGroup = self.animationGroups.firstObject as? CAAnimationGroup,
            animationCluster: [DKKeyFrameAnimation] = self.animations.first {
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

    internal func addAnimationKeyframeCalculation(functionBlock: DKKeyframeAnimationFunctionBlock) {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let animationCluster = self.animations.first
            if let animation = animationCluster?.last {
                animation.functionBlock = functionBlock
            }
        }
    }

    internal func addAnimationCalculationAction(action: AnimationCalculationAction) {
        if var actions = self.animationCalculationActions.last as [AnimationCalculationAction]? {
            actions.append(action)
            self.animationCalculationActions.removeLast()
            self.animationCalculationActions.append(actions)
        }
    }

    internal func addAnimationCompletionAction(action: AnimationCompletionAction) {
        if var actions = self.animationCompletionActions.last as [AnimationCompletionAction]? {
            actions.append(action)
            self.animationCompletionActions.removeLast()
            self.animationCompletionActions.append(actions)
        }
    }

    internal func addAnimationFromCalculationBlock(animation: DKKeyFrameAnimation) {
        if var animationCluster = self.animations.first {
            animationCluster.append(animation)
            self.animations.removeAtIndex(0)
            self.animations.insert(animationCluster, atIndex: 0)
        }
    }

    // MARK: - Basic Animation Helper

    internal func basicAnimationGroup() -> CAAnimationGroup {
        return CAAnimationGroup()
    }
    
    internal func basicAnimationForKeyPath(keyPath: String) -> DKKeyFrameAnimation {
        let animation = DKKeyFrameAnimation(keyPath: keyPath)
        animation.repeatCount = 0
        animation.autoreverses = false
        return animation
    }

    internal func newPositionFrom(#newOrigin: CGPoint) -> CGPoint {
        let anchor = self.view.layer.anchorPoint
        let size = self.view.bounds.size
        let newPosition = CGPoint(x: newOrigin.x + anchor.x * size.width, y: newOrigin.y + anchor.y * size.height)
        return newPosition
    }

    internal func newPositionFrom(#newCenter: CGPoint) -> CGPoint {
        let anchor = self.view.layer.anchorPoint
        let size = self.view.bounds.size
        let newPosition = CGPoint(x: newCenter.x + (anchor.x - 0.5) * size.width, y: newCenter.y + (anchor.y - 0.5) * size.height)
        return newPosition
    }

}
