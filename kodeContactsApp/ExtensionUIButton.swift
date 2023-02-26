//
//  extensionUIButton.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 26.02.2023.
//

import Foundation
import UIKit

extension UIButton {
    func setTitleInsets(imageTitlePadding: CGFloat) {
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: imageTitlePadding,
            bottom: 0,
            right: -imageTitlePadding
        )
    }
}
