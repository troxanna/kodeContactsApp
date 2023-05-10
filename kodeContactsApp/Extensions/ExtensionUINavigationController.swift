//
//  File.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 10.05.2023.
//

import Foundation
import UIKit

extension UINavigationController {
  static public func navigationBarHeight() -> CGFloat {
    let viewController = UIApplication.shared.windows.first!.rootViewController
    let navigationController = UINavigationController(rootViewController: UIViewController(nibName: nil, bundle: nil))
      let navigationBarHeight = navigationController.navigationBar.frame.size.height + (viewController!.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + 5
    return navigationBarHeight
  }
}
