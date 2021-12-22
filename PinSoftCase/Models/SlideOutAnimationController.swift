//
//  SlideOutAnimationController.swift
//  PinSoftCase
//
//  Created by Tolga Sayan on 22.12.2021.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return 0.3
  }

  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    if let fromView = transitionContext.view(
      forKey: UITransitionContextViewKey.from) {
      let containerView = transitionContext.containerView
      let time = transitionDuration(using: transitionContext)
      UIView.animate(
        withDuration: time,
        animations: {
        fromView.center.x -= containerView.bounds.size.height
        fromView.transform = CGAffineTransform(
          scaleX: 0.7, y: 0.7)
        }, completion: { finished in
        transitionContext.completeTransition(finished)
        }
      )
    }
  }
}

