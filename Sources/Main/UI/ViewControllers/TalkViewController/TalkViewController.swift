//
//  TalkViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/13/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TalkViewController: BaseViewController {
    @IBOutlet var pushToTalk: UIButton!
    @IBOutlet var volume: UISegmentedControl!

    let player = TalkPlayer()
    
    let a = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    func attach(to menu: UIView) {
        let parent = menu.viewContainingController()!
        parent.addChildViewController(self)
        parent.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: menu.leftAnchor),
            view.topAnchor.constraint(equalTo: menu.topAnchor),
            view.bottomAnchor.constraint(equalTo: menu.bottomAnchor)
        ])
        didMove(toParentViewController: parent)
    }
}

extension TalkViewController {
    func bind() {
        let model = TalkIdea()
        pushToTalk.rx.tap ||> model.toggle ||> model.isStarted ||> disposeBag
        volume.rx.value <||> model.volume ||> disposeBag
        model.isPushed ||> Styles.button.selected ||> pushToTalk ||> disposeBag
        model.pushTitle ||> pushToTalk.rx.title() ||> disposeBag
        model.gain ||> player.rx.gain ||> disposeBag
    }
}
