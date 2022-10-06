//
//  UINavigationController.swift
//  Angel Spark
//
//  Created by Robin Gupta on 18/01/21.
//  Copyright © 2021 Angel One. All rights reserved.
//

import UIKit

// When using a custom back button or no navigation bar at all, this re-enables the pop gesture
extension UINavigationController {

	open override func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
	}

}

open class NavigationController: UINavigationController, UINavigationControllerDelegate {

	open var swipeInteractionController: SwipeInteractionController?

	public var statusBarStyle: UIStatusBarStyle = .lightContent {
		didSet {
			setNeedsStatusBarAppearanceUpdate()
		}
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
	}

	open override var preferredStatusBarStyle: UIStatusBarStyle {
		return statusBarStyle
	}

	public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		navigationController.topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}

	public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		// Need to disable the swipe gesture so that we don't over ride the default edge swipe gesture of navigation controller
		if viewControllers.count == 1 {
			swipeInteractionController?.edgeSwipeGesture?.isEnabled = true
		} else {
			swipeInteractionController?.edgeSwipeGesture?.isEnabled = false
		}
	}

	public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return nil
	}

}

extension UINavigationController {

	open override var childForStatusBarStyle: UIViewController? {
		return topViewController
	}

}
