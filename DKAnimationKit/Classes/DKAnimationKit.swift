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

    internal func makeOrigin(x: CGFloat, _ y: CGFloat) -> DKAnimationKit {

        self.addAnimationCalculationAction { (weakSelf: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position")
            let newPosition = self.newPositionFromNewOrigin(CGPoint(x: x, y: y))
            positionAnimation.fromValue = NSValue(CGPoint: weakSelf.layer.position)
            positionAnimation.toValue = NSValue(CGPoint: newPosition)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (weakSelf: UIView) -> Void in
            var rect = weakSelf.frame
            rect.origin.x = x
            rect.origin.y = y
            weakSelf.layer.frame = rect
            weakSelf.frame = rect
        }

        return self
    }

    internal func animate(duration: NSTimeInterval) -> DKAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = duration
            self.animateChain()
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
        println(animation.keyPath)
        println(keyPath)

        return animation
    }

    private func newPositionFromNewOrigin(newOrigin: CGPoint) -> CGPoint {
        let anchor = self.view.layer.anchorPoint
        let size = self.view.bounds.size
        let newPosition = CGPoint(x: newOrigin.x + anchor.x * size.width, y: newOrigin.y + anchor.y * size.height)
        return newPosition
    }
    
    private func sanityCheck() {
        
    }

}
