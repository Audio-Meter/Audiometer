//
//  ButtonStyle.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/22/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

struct ButtonStyle {
    var backgroundColor: ColorStyle? = nil
    var textColor: ColorStyle? = nil
    var textFont: FontStyle? = nil
    var borderWidth: CGFloat? = nil
    var borderColor: ColorStyle? = nil
    var buttonImage : UIImage? = nil
    static func normal() -> ButtonStyle {
        return ButtonStyle().textFont(.normal)
    }

    static func solid() -> ButtonStyle {
        return normal().solid()
    }
    static func Cleared()-> ButtonStyle
    {
        return normal().Cleared()
    }

    static func bordered() -> ButtonStyle {
        return normal().bordered()
    }

    static func selected(_ value: Bool) -> ButtonStyle {
        let style = ButtonStyle()
        
        return value ? style.solid() : style.bordered()
    }

    func textFont(_ value: FontStyle) -> ButtonStyle {
        var style = self
        style.textFont = value
        return style
    }

    func solid() -> ButtonStyle {
        var style = self
        style.backgroundColor = ColorStyle.blue
        style.textColor = .white
        style.borderWidth = 0
        return style
    }
func Cleared() -> ButtonStyle
 {
     var style = self
         style.backgroundColor = ColorStyle.clear
           style.textColor = .white
           style.borderWidth = 0
           return style
    }

    func bordered() -> ButtonStyle {
        var style = self
        style.backgroundColor = .white
        style.textColor = ColorStyle.blue
        style.borderWidth = 1
        style.borderColor = ColorStyle.blue
        return style
    }
}

extension ButtonStyle {
    func apply(to button: UIButton) {
        backgroundColor.flatMap { button.backgroundColor = $0.apply() }
        textColor.flatMap { button.setTitleColor($0.apply(), for: .normal) }
        textFont.flatMap { button.titleLabel?.font = $0.apply() }
        borderWidth.flatMap { button.layer.borderWidth = $0 }
        borderColor.flatMap { button.layer.borderColor = $0.apply().cgColor }
       
    }

    func apply(title: String,buttonImage:UIImage, to button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 3
        button.setImage(buttonImage, for: .normal)
        apply(to: button)
    }
}

func ||>(styles: Observable<ButtonStyle>, button: UIButton) -> Disposable {
    return styles.subscribe(onNext: {
        $0.apply(to: button)
    })
}
