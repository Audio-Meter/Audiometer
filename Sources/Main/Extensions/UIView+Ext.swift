//
//  UIView+Ext
//  Audiometer
//
//  Created by Sergey Kachan on 2/1/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable open var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }

        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat{
        get {
            return layer.cornerRadius
        }

        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat{
        get {
            return layer.borderWidth
        }

        set {
            layer.borderWidth = newValue
        }
    }
    
    

    func label(text: String, size: CGFloat, align: NSTextAlignment, x: CGFloat, y: CGFloat, width: CGFloat = 100, vertical: Bool = false, color: UIColor = .black) {
        let font = UIFont.systemFont(ofSize: size, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = align
        let string = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ])
        let offset = (align == .center ? width / 2 : 0)
        let rect = CGRect(x: x - offset, y: y, width: width, height: font.lineHeight)
        string.draw(in: rect)
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

protocol StyledView {}
extension UIView: StyledView {}

extension StyledView where Self: UIView {
    func from(_ view: UIView) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        return self
    }
}
