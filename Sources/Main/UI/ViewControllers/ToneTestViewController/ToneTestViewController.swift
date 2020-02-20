//
//  ToneTestViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/30/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import LGButton
import RxSwift
import RxCocoa
import MBProgressHUD

class ToneTestViewController: BaseViewController {
    @IBOutlet var toneSettings: ToneSettingsView!
    @IBOutlet var masking: ToneMaskingView!

    @IBOutlet var amplitudeLabel: UILabel!
    @IBOutlet var frequencyLabel: UILabel!

    @IBOutlet var audiogram: AudiogramView!
    @IBOutlet var swipe: UISwipeGestureRecognizer!

    @IBOutlet var play: LGButton!
    @IBOutlet var record: LGButton!
    @IBOutlet var noResponse: UIButton!
    @IBOutlet var save: LGButton!
    @IBOutlet var bottomBar: UIView!
    @IBOutlet var transducerPlace: UILabel!

    let amplitudeController = SteppedViewController()
    let transducerController = TransducerPickerController()
    let frequencyController = SteppedViewController()
    let talkController = TalkViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate.isFromCalibration = false

        amplitudeController.attach(to: amplitudeLabel)
        transducerController.attach(to: transducerPlace)
        frequencyController.attach(to: frequencyLabel)
        talkController.attach(to: bottomBar)
    }
    
    class var viewController: ToneTestViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "toneTest") as! ToneTestViewController
    }
}

extension ToneTestViewController: Bindable {
    func bind(model: ToneTestPage) {
        model.playButton ||> play ||> disposeBag

        toneSettings.bind(model: model.conductionIdea)
        toneSettings.bind(model: model.player)
        masking.bind(model: model.masking)

        let audio = AudioManager(players: toneSettings.player, masking.player, talkController.player)
        self ||> audio ||> disposeBag

        play.rx.controlEvent(.touchDown) ||> model.play ||> disposeBag
        play.rx.controlEvent([.touchUpInside, .touchUpOutside]) ||> model.pause ||> disposeBag

        record.rx.tap ||> model.passed ||> model.record ||> disposeBag
        noResponse.rx.tap ||> model.failed ||> model.record ||> disposeBag

        swipe.rx.recognized ||> model.clearAll ||> disposeBag
        audiogram.rx.tap ||> model.clearAt ||> disposeBag
        model.audiogram ||> audiogram.rx.value ||> disposeBag
        model.frequency ||> audiogram.rx.frequency ||> disposeBag
        model.amplitude ||> audiogram.rx.amplitude ||> disposeBag
        
        save.rx.tap ||> model.testResultPage ||> { [weak self] (testResultPage: TestResultPage<TestResult>) in
            guard let `self` = self else { return }
            // TODO: probably need to add loading property to model and observe it
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            testResultPage.save(with: self.audiogram.asImage()).subscribe(onNext: { [weak self] (success) in
                if success {
                    self?.navigator.back()
                }
                }, onError: { [weak self] (error) in
                    self?.showAlert(error: error)
                }, onDisposed: {
                    hud.hide(animated: true)
            }).disposed(by: self.disposeBag)
            } ||> disposeBag

        amplitudeController.bind(model: model.amplitudeModel)
        frequencyController.bind(model: model.frequencyModel)
        transducerController.bind(model: model.transducerModel)
        talkController.bind()
    }
}

extension ToneTestPage: PageViewModel {
    func createController(router: Router) -> UIViewController {
        return router.createController(page: self) as ToneTestViewController
    }
}
