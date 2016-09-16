//
//  DKChainableAnimationKit.swift
//  DKChainableAnimationKit
//
//  Created by Draveness on 15/5/13.
//  Copyright (c) 2015年 Draveness. All rights reserved.
//

import UIKit

open class DKChainableAnimationKit {

    weak var view: UIView!

    typealias AnimationCalculationAction = (UIView) -> Void
    typealias AnimationCompletionAction = (UIView) -> Void

    internal var animationCalculationActions: [[AnimationCalculationAction]]!
    internal var animationCompletionActions: [[AnimationCompletionAction]]!
    internal var animationGroups: NSMutableArray!
    internal var animations: [[DKKeyFrameAnimation]]!
    open var animationCompletion: ((Void) -> Void)?

    // MARK: - Initialize

    init() {
        self.setup()
    }

    fileprivate func setup() {
        self.animations = [[]]
        self.animationGroups = [self.basicAnimationGroup()]
        self.animationCompletionActions = [[]]
        self.animationCalculationActions = [[]]
    }

    fileprivate func clear() {
        self.animations.removeAll()
        self.animationGroups.removeAllObjects()
        self.animationCompletionActions.removeAll()
        self.animationCalculationActions.removeAll()
        self.animations.append([])
        self.animationCompletionActions.append([AnimationCalculationAction]())
        self.animationCalculationActions.append([AnimationCompletionAction]())
        self.animationGroups.add(self.basicAnimationGroup())
    }

    // MARK: - Animation Time

    open func delay(_ delay: TimeInterval) -> DKChainableAnimationKit {
        var delay = delay
        for group in self.animationGroups {
            let duration = (group as AnyObject).duration as TimeInterval
            delay += duration
        }
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.beginTime = CACurrentMediaTime() + delay
        }
        return self
    }

    open func delay(_ time: CGFloat) -> DKChainableAnimationKit {
        return delay(TimeInterval(time))
    }

    open var seconds: DKChainableAnimationKit {
        get {
            return self
        }
    }

    open func wait(_ delay: TimeInterval) -> DKChainableAnimationKit {
        return self.delay(delay)
    }

    @discardableResult open func animate(_ duration: TimeInterval) -> DKChainableAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = duration
            self.animateChain()
        }
        return self
    }

    @discardableResult open func animate(_ duration: CGFloat) -> DKChainableAnimationKit {
        return animate(TimeInterval(duration))
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

    open func thenAfter(_ after: TimeInterval) -> DKChainableAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = after
            let newGroup = self.basicAnimationGroup()
            self.animationGroups.add(newGroup)
            self.animations.append([])
            self.animationCalculationActions.append([])
            self.animationCompletionActions.append([])
        }
        return self
    }

    open func thenAfter(_ after: CGFloat) -> DKChainableAnimationKit {
        return thenAfter(TimeInterval(after))
    }

    @discardableResult open func animateWithCompletion(_ duration: TimeInterval, _ completion: @escaping (Void) -> Void) -> DKChainableAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = duration
            self.animationCompletion = completion
            self.animateChain()
        }
        return self
    }

    @discardableResult open func animateWithCompletion(_ duration: CGFloat, _ completion: @escaping (Void) -> Void) -> DKChainableAnimationKit {
        return animateWithCompletion(TimeInterval(duration), completion)
    }

    internal func degreesToRadians(_ degree: Double) -> Double {
        return (degree / 180.0) * M_PI
    }

    fileprivate func animateChain() {
        self.sanityCheck()
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.view?.layer.removeAnimation(forKey: "AnimationChain")
            self.chainLinkDidFinishAnimating()
        }
        self.animateChainLink()
        CATransaction.commit()

        self.executeCompletionActions()
    }

    fileprivate func animateChainLink() {
        self.makeAnchor(0.5, 0.5)
        if let animationCluster = self.animationCalculationActions.first, let _ = self.view {
            for action in animationCluster {
                action(self.view)
            }
        }
        if let group: CAAnimationGroup = self.animationGroups.firstObject as? CAAnimationGroup,
            let animationCluster: [DKKeyFrameAnimation] = self.animations.first {
            for animation in animationCluster {
                animation.duration = group.duration
                animation.calculte()
            }
            group.animations = animationCluster
            self.view?.layer.add(group, forKey: "AnimationChain")
        }
    }

    fileprivate func executeCompletionActions() {
        if let group = self.animationGroups.firstObject as? CAAnimationGroup {
            let delay = max(group.beginTime - CACurrentMediaTime(), 0.0)
            let delayTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                if let
                    actionCluster: [AnimationCompletionAction] = self.animationCompletionActions.first,
                    let view = self.view {
                        for action in actionCluster {
                            action(view)
                        }
                }
            }
        }
    }

    fileprivate func chainLinkDidFinishAnimating() {
        self.animationCompletionActions.remove(at: 0)
        self.animationCalculationActions.remove(at: 0)
        self.animations.remove(at: 0)
        self.animationGroups.removeObject(at: 0)

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

    fileprivate func sanityCheck() {
        assert(self.animations.count == self.animationGroups.count, "FATAL ERROR: ANIMATION GROUPS AND ANIMATIONS ARE OUT OF SYNC");
        assert(self.animationCalculationActions.count == self.animationCompletionActions.count, "FATAL ERROR: ANIMATION CALCULATION OBJECTS AND ANIMATION COMPLETION OBJECTS ARE OUT OF SYNC");
        assert(self.animations.count == self.animationCompletionActions.count, "FATAL ERROR: ANIMATIONS AND ANIMATION COMPLETION OBJECTS ARE OUT OF SYNC");
    }

    // MARK: - Animation Action

    internal func addAnimationKeyframeCalculation(_ functionBlock: @escaping DKKeyframeAnimationFunctionBlock) {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let animationCluster = self.animations.first
            if let animation = animationCluster?.last {
                animation.functionBlock = functionBlock
            }
        }
    }

    internal func addAnimationCalculationAction(_ action: @escaping AnimationCalculationAction) {
        if var actions = self.animationCalculationActions.last as [AnimationCalculationAction]? {
            actions.append(action)
            self.animationCalculationActions.removeLast()
            self.animationCalculationActions.append(actions)
        }
    }

    internal func addAnimationCompletionAction(_ action: @escaping AnimationCompletionAction) {
        if var actions = self.animationCompletionActions.last as [AnimationCompletionAction]? {
            actions.append(action)
            self.animationCompletionActions.removeLast()
            self.animationCompletionActions.append(actions)
        }
    }

    internal func addAnimationFromCalculationBlock(_ animation: DKKeyFrameAnimation) {
        if var animationCluster = self.animations.first {
            animationCluster.append(animation)
            self.animations.remove(at: 0)
            self.animations.insert(animationCluster, at: 0)
        }
    }

    // MARK: - Basic Animation Helper

    internal func basicAnimationGroup() -> CAAnimationGroup {
        return CAAnimationGroup()
    }
    
    internal func basicAnimationForKeyPath(_ keyPath: String) -> DKKeyFrameAnimation {
        let animation = DKKeyFrameAnimation(keyPath: keyPath)
        animation.repeatCount = 0
        animation.autoreverses = false
        return animation
    }

    internal func newPositionFrom(newOrigin: CGPoint) -> CGPoint {
        let anchor = self.view.layer.anchorPoint
        let size = self.view.bounds.size
        let newPosition = CGPoint(x: newOrigin.x + anchor.x * size.width, y: newOrigin.y + anchor.y * size.height)
        return newPosition
    }

    internal func newPositionFrom(newCenter: CGPoint) -> CGPoint {
        let anchor = self.view.layer.anchorPoint
        let size = self.view.bounds.size
        let newPosition = CGPoint(x: newCenter.x + (anchor.x - 0.5) * size.width, y: newCenter.y + (anchor.y - 0.5) * size.height)
        return newPosition
    }

}
