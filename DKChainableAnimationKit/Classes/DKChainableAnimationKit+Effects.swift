//
//  DKChainableAnimationKit+Effects.swift
//  DKChainableAnimationKit
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

public extension DKChainableAnimationKit {
    // MARK: - Animation Effects

    public var easeIn: DKChainableAnimationKit {
        get {
            self.easeInQuad
            return self
        }
    }

    public var easeOut: DKChainableAnimationKit {
        get {
            self.easeOutQuad
            return self
        }
    }

    public var easeInOut: DKChainableAnimationKit {
        get {
            self.easeInOutQuad
            return self
        }
    }

    public var easeBack: DKChainableAnimationKit {
        get {
            self.easeOutBack
            return self
        }
    }

    public var spring: DKChainableAnimationKit {
        get {
            self.easeOutElastic
            return self
        }
    }

    public var bounce: DKChainableAnimationKit {
        get {
            self.easeOutBounce
            return self
        }
    }

    public var easeInQuad: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInQuad)
            return self
        }
    }

    public var easeOutQuad: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutQuad)
            return self
        }
    }

    public var easeInOutQuad: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutQuad)
            return self
        }
    }

    public var easeInCubic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInCubic)
            return self
        }
    }

    public var easeOutCubic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutCubic)
            return self
        }
    }

    public var easeInOutCubic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutCubic)
            return self
        }
    }

    public var easeInQuart: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInQuart)
            return self
        }
    }

    public var easeOutQuart: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutQuart)
            return self
        }
    }

    public var easeInOutQuart: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutQuart)
            return self
        }
    }

    public var easeInQuint: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInQuint)
            return self
        }
    }

    public var easeOutQuint: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutQuint)
            return self
        }
    }

    public var easeInOutQuint: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutQuint)
            return self
        }
    }

    public var easeInSine: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInSine)
            return self
        }
    }

    public var easeOutSine: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutSine)
            return self
        }
    }

    public var easeInOutSine: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutSine)
            return self
        }
    }

    public var easeInExpo: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInExpo)
            return self
        }
    }

    public var easeOutExpo: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutExpo)
            return self
        }
    }

    public var easeInOutExpo: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutExpo)
            return self
        }
    }

    public var easeInCirc: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInCirc)
            return self
        }
    }

    public var easeOutCirc: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutCirc)
            return self
        }
    }

    public var easeInOutCirc: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutCirc)
            return self
        }
    }

    public var easeInElastic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInElastic)
            return self
        }
    }

    public var easeOutElastic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutElastic)
            return self
        }
    }

    public var easeInOutElastic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutElastic)
            return self
        }
    }

    public var easeInBack: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInBack)
            return self
        }
    }

    public var easeOutBack: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutBack)
            return self
        }
    }

    public var easeInOutBack: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutBack)
            return self
        }
    }

    public var easeInBounce: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInBounce)
            return self
        }
    }

    public var easeOutBounce: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutBounce)
            return self
        }
    }

    public var easeInOutBounce: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutBounce)
            return self
        }
    }

}