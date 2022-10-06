//
//  TransitionViewController.swift
//  Angel Spark
//
//  Created by Robin Gupta on 18/01/21.
//  Copyright © 2021 Angel One. All rights reserved.
//

import Foundation
import UIKit

// This class is used to handle the navigation style transition in cases were we are unable to use the default navigation controller push view controller method or there is no navigation controller.
open class TransitionViewController: UIViewController {

	public let transition = ModalPushTransition()
	private let topConstraintValueNormalFont: CGFloat = 9
	private let topConstraintValueSmallerFont: CGFloat = 5

	open override func viewDidLoad() {
		//NotificationCenter.default.addObserver(self, selector: #selector(themeChanged(notification:)), name: .appearanceChanged, object: nil)
	}

	@objc func themeChanged(notification: Notification) {
		// Take Action on Notification
		//updateUIElements()
		setNeedsStatusBarAppearanceUpdate()
	}
/*
	open override var preferredStatusBarStyle: UIStatusBarStyle {
		switch AppAppearance.appTheme {
			case .light:
				if #available(iOS 13.0, *) {
					return .darkContent
				} else {
					return .default
				}
			case .dark:
				return .lightContent
			case .none:
				return .default
		}
	}*/

}

// MARK: - UIViewControllerTransitioningDelegate
extension TransitionViewController: UIViewControllerTransitioningDelegate {

	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.presenting = true
		return transition
	}

	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		guard let navController = dismissed as? NavigationController else {
			transition.presenting = false
			return transition
		}
		return SwipeDismissAnimationController(interactionController: navController.swipeInteractionController)
	}

	public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		guard let animator = animator as? SwipeDismissAnimationController,
			  let interactionController = animator.interactionController,
			  interactionController.interactionInProgress
		else {
			return nil
		}
		return interactionController
	}

}

extension TransitionViewController {

	public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		
	}

}

// MARK: - Logical Method
extension TransitionViewController {

	public func setFontAsPerText(_ text: String, textfield: UITextField, constraint: NSLayoutConstraint? = nil) {
        /*
		switch text.count {
			case 1...9:
				textfield.font = FontFamily.Barlow.medium.font(size: 36)
				constraint?.constant = topConstraintValueNormalFont
			case 10...17:
				textfield.font = FontFamily.Barlow.medium.font(size: 24)
				constraint?.constant = topConstraintValueSmallerFont
			default:
				break
		}*/
	}

}
