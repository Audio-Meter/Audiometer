//
//  SteppedViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/17/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import VerticalSteppedSlider
import RxSwift
import RxCocoa

class SteppedViewController: BaseViewController {
    @IBOutlet var type: UISegmentedControl!
    @IBOutlet var slider: VSSlider!
    @IBOutlet var sliderView: SliderOptionView!
    @IBOutlet var buttonView: UIView!

    @IBOutlet var plus: UIButton!
    @IBOutlet var minus: UIButton!
    @IBOutlet var value: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    func attach(to label: UILabel) {
        let parent = label.viewContainingController()!
        parent.addChildViewController(self)
        parent.view.addSubview(view)

        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: label.leftAnchor),
            view.topAnchor.constraint(equalTo: label.bottomAnchor)
        ])
        didMove(toParentViewController: parent)
    }
}

extension SteppedViewController: Bindable {
    func bind(model: SteppedViewModel) {
        type.rx.value <||> model.type ||> disposeBag
        model.sliderSelected ||> sliderView.rx.isShown ||> disposeBag
        model.sliderSelected ||> buttonView.rx.isHidden ||> disposeBag

        sliderView.marks = model.possibleValues
        slider.rx.value <||> model.index ||> disposeBag
        model.index ||> sliderView.rx.selectedIndex ||> disposeBag

        plus.rx.tap ||> model.next ||> model.index ||> disposeBag
        minus.rx.tap ||> model.previous ||> model.index ||> disposeBag
        model.valueLabel ||> value.rx.text ||> disposeBag
    }
}
