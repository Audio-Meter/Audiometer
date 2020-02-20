//
//  BlankField.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/22/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BlankField: UIControl {
    private var _inputView: UIView?

    override var inputView: UIView? {
        return _inputView
    }

    func inputView(_ value: UIView) {
        _inputView = value
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        becomeFirstResponder()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        return toolbar
    }
}
