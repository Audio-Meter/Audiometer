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
        parent.addChild(self)
        parent.view.addSubview(view)
//        parent.view.sendSubviewToBack(<#T##view: UIView##UIView#>)
        NSLayoutConstraint.activate([
//            view.leftAnchor.constraint(equalTo: label.leftAnchor, constant: 16),
//            view.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -16),
            view.centerXAnchor.constraint(equalTo: label.centerXAnchor,constant: 8),
            view.topAnchor.constraint(equalTo: label.bottomAnchor),
            view.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor,constant: -70)
            
        ])
        didMove(toParent: parent)
    }
}

extension SteppedViewController: Bindable {
    func bind(model: SteppedViewModel) {
        
        
        if let typeFreq = model.typeFrequency{
            type.rx.value <||> typeFreq ||> disposeBag
            type.setTitle("Button", forSegmentAt: 0)
            type.setTitle("Slider", forSegmentAt: 1)
        }
        
        if let typeAmpl = model.typeAmplitude{
            type.rx.value <||> typeAmpl ||> disposeBag
            type.setTitle("Slider", forSegmentAt: 0)
            type.setTitle("Button", forSegmentAt: 1)
        }
        
        
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
