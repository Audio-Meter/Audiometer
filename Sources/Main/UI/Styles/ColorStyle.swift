//
//  ColorStyle.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/22/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

struct ColorStyle {
    let color: UIColor

    func apply() -> UIColor {
        return color
    }

    static func wrap(_ color: UIColor) -> ColorStyle {
        return ColorStyle(color: color)
    }

    static let clear = wrap(.clear)
    static let white = wrap(.white)

    // static let red = wrap(#colorLiteral(red: 0.6196078431, green: 0.04705882353, blue: 0.05882352941, alpha: 1))
    static let red = wrap(#colorLiteral(red: 0.2941176471, green: 0.5254901961, blue: 0.7058823529, alpha: 1))
    
    static let green = wrap(#colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1))
    static let black = wrap(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    static let lightBlack = wrap(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))  //333333

    static let lighterGray = wrap(#colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)) //F8F8F8
    static let lightGray = wrap(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1))   //F1F1F1
    static let stupidGray = wrap(#colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1))  //ECECEC
    static let middleGray = wrap(#colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1))  //CECECE
    static let darkGray = wrap(#colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1))    //B2B2B2
    static let darkGray2 = wrap(#colorLiteral(red: 0.5843137255, green: 0.5803921569, blue: 0.5764705882, alpha: 1))   //959493
    static let darkerGray = wrap(#colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1))  //777777
    //static let semiTransparentRed = wrap(#colorLiteral(red: 0.5607843137, green: 0.003921568627, blue: 0.05882352941, alpha: 0.8004066781))
    static let semiTransparentRed = wrap(#colorLiteral(red: 0.2941176471, green: 0.5254901961, blue: 0.7058823529, alpha: 0.8004066781))
    static let semiTransparentBlue = wrap(#colorLiteral(red: 0.2941176471, green: 0.5254901961, blue: 0.7058823529, alpha: 0.8004066781))
    static let blue = wrap(#colorLiteral(red: 0.2941176471, green: 0.5254901961, blue: 0.7058823529, alpha: 1))

}
