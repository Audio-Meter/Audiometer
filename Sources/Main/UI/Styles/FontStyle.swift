//
//  FontStyle.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/22/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

struct FontStyle {
    let descriptor: UIFontDescriptor

    func apply() -> UIFont {
        return UIFont(descriptor: descriptor, size: 0)
    }

    static func wrap(_ descriptor: UIFontDescriptor) -> FontStyle {
        return FontStyle(descriptor: descriptor)
    }

    static func family(_ value: String) -> FontStyle {
        return wrap(UIFontDescriptor().withFamily(value))
    }

    //static let normal = family("SF Pro Text").size(14)
    static let normal = family("Century Gothic").size(14)
    
    func size(_ value: CGFloat) -> FontStyle {
        return .wrap(descriptor.withSize(value))
    }

    func bold() -> FontStyle {
        return weight(.bold)
    }

    func weight(_ value: CGFloat) -> FontStyle {
        return weight(UIFont.Weight(rawValue: value))
    }

    func weight(_ value: UIFont.Weight) -> FontStyle {
        let traits = [UIFontDescriptor.TraitKey.weight: value]
        let attributes = [UIFontDescriptor.AttributeName.traits: traits]
        return .wrap(descriptor.addingAttributes(attributes))
    }
}
