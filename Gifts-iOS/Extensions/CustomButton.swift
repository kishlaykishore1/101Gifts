//
//  CustomButton.swift
//  Yellow Kitchens
//
//  Created by angrej singh on 25/09/20.
//  Copyright © 2020 com.agency55. All rights reserved.
//

import Foundation
import UIKit
class CustomButton: UIButton {
    required init(title: String, subtitle: String) {
        super.init(frame: CGRect.zero)
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        let titleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle),
            NSAttributedString.Key.paragraphStyle : style
        ]
        let subtitleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
            NSAttributedString.Key.paragraphStyle : style
        ]
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
        setAttributedTitle(attributedString, for: UIControl.State.normal)
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
