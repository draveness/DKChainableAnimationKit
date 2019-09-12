//
//  DKChainableAnimationKit+Effects.swift
//  DKChainableAnimationKit
//
//  Created by Draveness on 15/6/12.
//  Copyright (c) 2015年 Draveness. All rights reserved.
//

import UIKit

public extension DKChainableAnimationKit {
    // MARK: - Animation Effects
    
    var easeIn: DKChainableAnimationKit {
        get {
            _ = self.easeInQuad
            return self
        }
    }
    
    var easeOut: DKChainableAnimationKit {
        get {
            _ = self.easeOutQuad
            return self
        }
    }
    
    var easeInOut: DKChainableAnimationKit {
        get {
            _ = self.easeInOutQuad
            return self
        }
    }
    
    var easeBack: DKChainableAnimationKit {
        get {
            _ = self.easeOutBack
            return self
        }
    }
    
    var spring: DKChainableAnimationKit {
        get {
            _ = self.easeOutElastic
            return self
        }
    }
    
    var bounce: DKChainableAnimationKit {
        get {
            _ = self.easeOutBounce
            return self
        }
    }
    
    var easeInQuad: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInQuad)
            return self
        }
    }
    
    var easeOutQuad: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutQuad)
            return self
        }
    }
    
    var easeInOutQuad: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutQuad)
            return self
        }
    }
    
    var easeInCubic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInCubic)
            return self
        }
    }
    
    var easeOutCubic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutCubic)
            return self
        }
    }
    
    var easeInOutCubic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutCubic)
            return self
        }
    }
    
    var easeInQuart: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInQuart)
            return self
        }
    }
    
    var easeOutQuart: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutQuart)
            return self
        }
    }
    
    var easeInOutQuart: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutQuart)
            return self
        }
    }
    
    var easeInQuint: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInQuint)
            return self
        }
    }
    
    var easeOutQuint: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutQuint)
            return self
        }
    }
    
    var easeInOutQuint: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutQuint)
            return self
        }
    }
    
    var easeInSine: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInSine)
            return self
        }
    }
    
    var easeOutSine: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutSine)
            return self
        }
    }
    
    var easeInOutSine: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutSine)
            return self
        }
    }
    
    var easeInExpo: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInExpo)
            return self
        }
    }
    
    var easeOutExpo: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutExpo)
            return self
        }
    }
    
    var easeInOutExpo: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutExpo)
            return self
        }
    }
    
    var easeInCirc: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInCirc)
            return self
        }
    }
    
    var easeOutCirc: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutCirc)
            return self
        }
    }
    
    var easeInOutCirc: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutCirc)
            return self
        }
    }
    
    var easeInElastic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInElastic)
            return self
        }
    }
    
    var easeOutElastic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutElastic)
            return self
        }
    }
    
    var easeInOutElastic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutElastic)
            return self
        }
    }
    
    var easeInBack: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInBack)
            return self
        }
    }
    
    var easeOutBack: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutBack)
            return self
        }
    }
    
    var easeInOutBack: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutBack)
            return self
        }
    }
    
    var easeInBounce: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInBounce)
            return self
        }
    }
    
    var easeOutBounce: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutBounce)
            return self
        }
    }
    
    var easeInOutBounce: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutBounce)
            return self
        }
    }
    
}
