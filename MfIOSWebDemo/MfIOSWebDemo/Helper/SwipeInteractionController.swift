//
//  SwipeInteractionController.swift
//  Angel Spark
//
//  Created by Robin Gupta on 18/01/21.
//  Copyright © 2021 Angel One. All rights reserved.
//

import UIKit

// Created a new interaction controller to show navigation controller like interactive pop gesture
public final class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

	public var interactionInProgress = false
	public var edgeSwipeGesture: UIScreenEdgePanGestureRecognizer?

	private var shouldCompleteTransition = false
	private lazy var initialPosition = CGPoint.zero
	private weak var viewController: UIViewController!
	private static let screenWidth = UIScreen.main.bounds.width

	public init(viewController: UIViewController) {
		super.init()
		self.viewController = viewController
		prepareGestureRecognizer(in: viewController.view)
	}

	private func prepareGestureRecognizer(in view: UIView) {
		edgeSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
		edgeSwipeGesture?.edges = .left
		edgeSwipeGesture?.delaysTouchesBegan = false
		view.addGestureRecognizer(edgeSwipeGesture!)
	}

	// This method handles the gesture and the progress of the animation
	@objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
		guard let view = gestureRecognizer.view else { return }
		let touchPoint = gestureRecognizer.location(in: view.window)

		switch gestureRecognizer.state {
			case .began:
				interactionInProgress = true
				initialPosition = touchPoint
				viewController.dismiss(animated: true, completion: nil)
			case .changed:
				var progress = (touchPoint.x - initialPosition.x) / SwipeInteractionController.screenWidth
				progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
				shouldCompleteTransition = progress > 0.5
				update(progress)
			case .cancelled:
				interactionInProgress = false
				cancel()
			case .ended:
				interactionInProgress = false
				if shouldCompleteTransition {
					finish()
				} else {
					cancel()
				}
			default:
				break
		}
	}
}
