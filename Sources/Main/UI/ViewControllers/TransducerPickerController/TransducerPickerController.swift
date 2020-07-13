//
//  TransducerPickerController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/23/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TransducerPickerController: BaseViewController {
    @IBOutlet var control: BlankField!
    @IBOutlet var label: UILabel!
    @IBOutlet var icon: UIImageView!

    @IBOutlet var picker: UIPickerView!
    var provider: TransducerPickerProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        control.inputView(picker)
    }

    func attach(to placeholder: UIView) {
        let parent = placeholder.viewContainingController()!
        parent.addChild(self)
        parent.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.rightAnchor.constraint(equalTo: placeholder.rightAnchor),
//            view.centerYAnchor.constraint(equalTo: placeholder.centerYAnchor),
            view.leftAnchor.constraint(equalTo: placeholder.leftAnchor),
            view.topAnchor.constraint(equalTo: placeholder.topAnchor),
            view.bottomAnchor.constraint(equalTo: placeholder.bottomAnchor),
        ])
        didMove(toParent: parent)
    }
}

extension TransducerPickerController: Bindable {
    func bind(model: TransducerPickerIdea) {
        model.selectedName ||> label.rx.text ||> disposeBag
        provider = TransducerPickerProvider(picker: picker, transducers: model.items)
        provider ||> disposeBag
        provider.selected <||> model.selectedItem ||> disposeBag
    }
}
