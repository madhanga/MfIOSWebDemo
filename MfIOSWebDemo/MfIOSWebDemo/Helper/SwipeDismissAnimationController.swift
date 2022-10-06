//
//  SwipeDismissAnimationController.swift
//  Angel Spark
//
//  Created by Robin Gupta on 18/01/21.
//  Copyright © 2021 Angel One. All rights reserved.
//

import UIKit

public final class SwipeDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

	public let interactionController: SwipeInteractionController?

	public init(interactionController: SwipeInteractionController?) {
		self.interactionController = interactionController
	}

	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.25
	}

	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard
			let viewControllerTo = transitionContext.viewController(forKey: .to),
			let viewTransitioningTo = transitionContext.view(forKey: .to),
			let viewTransitioningFrom = transitionContext.view(forKey: .from),
			let snapshot = viewTransitioningFrom.snapshotView(afterScreenUpdates: false) else {
			return transitionContext.completeTransition(true)
		}
		let finalFrameTo = transitionContext.finalFrame(for: viewControllerTo)

		let containerView = transitionContext.containerView
		containerView.insertSubview(viewTransitioningTo, at: 0)
		containerView.addSubview(snapshot)
		viewTransitioningFrom.isHidden = true

		let duration = transitionDuration(using: transitionContext)

		UIView.animateKeyframes(
			withDuration: duration,
			delay: 0,
			options: .allowUserInteraction,
			animations: {
				viewTransitioningTo.frame.origin.x = 0
				snapshot.frame.origin.x = finalFrameTo.width
			},
			completion: { _ in
				viewTransitioningFrom.isHidden = false
				snapshot.removeFromSuperview()
				if transitionContext.transitionWasCancelled {
					viewTransitioningTo.removeFromSuperview()
				}
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			})
	}

}
