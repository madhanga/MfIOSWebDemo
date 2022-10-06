//
//  ModalPushTransition.swift
//  Angel Spark
//
//  Created by Robin Gupta on 18/01/21.
//  Copyright © 2021 Angel One. All rights reserved.
//

import UIKit

public final class ModalPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
	public var presenting = true

	internal let duration = 0.25
	internal var completion: (() -> Void)?
	// Calculated that the transition distance is 30 % of the screen width when UINavigationController pops a UIViewController
	internal static let viewTransitioningDistance = UIScreen.main.bounds.width * 0.3

	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}

	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let containerView = transitionContext.containerView

		guard
			let viewControllerTo = transitionContext.viewController(forKey: .to),
			let viewTransitioningTo = transitionContext.view(forKey: .to),
			let viewTransitioningFrom = transitionContext.view(forKey: .from) else {
			return transitionContext.completeTransition(true)
		}

		let finalFrameTo = transitionContext.finalFrame(for: viewControllerTo)

		containerView.addSubview(viewTransitioningTo)

		if presenting {
			viewTransitioningTo.frame = finalFrameTo
			viewTransitioningTo.frame.origin.x = finalFrameTo.width
		} else {
			viewTransitioningTo.frame = finalFrameTo
			viewTransitioningTo.frame.origin.x = -ModalPushTransition.viewTransitioningDistance
			containerView.sendSubviewToBack(viewTransitioningTo)
		}

		UIView.animate(withDuration: duration,
					   animations: {
						if self.presenting {
							viewTransitioningTo.frame.origin.x = 0
							viewTransitioningFrom.frame.origin.x = -ModalPushTransition.viewTransitioningDistance

						} else {
							viewTransitioningTo.frame.origin.x = 0
							viewTransitioningFrom.frame.origin.x = finalFrameTo.width
						}
					   },
					   completion: { _ in
						transitionContext.completeTransition(true)
						self.completion?()
					   })
	}

}
