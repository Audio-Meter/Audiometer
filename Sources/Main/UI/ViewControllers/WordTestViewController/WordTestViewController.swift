//
//  WordTestViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/28/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import LGButton
import RxSwift
import MBProgressHUD

class WordTestViewController: BaseViewController {
    @IBOutlet var amplitudeLabel: UILabel!
    @IBOutlet var transducerPlace: UILabel!
    @IBOutlet var play: LGButton!
    @IBOutlet var save: LGButton!

    @IBOutlet var settings: WordSettingsView!
    @IBOutlet var masking: WordMaskingView!
    @IBOutlet var player: WordPlayerView!

    @IBOutlet var playedCount: UILabel!
    @IBOutlet var correctCount: UILabel!

    @IBOutlet var clear: UIButton!
    @IBOutlet var correct: UIButton!
    @IBOutlet var wrong: UIButton!
    @IBOutlet var skip: UIButton!
    @IBOutlet var score: UIButton!
    @IBOutlet weak var reset: UIButton!
    
    @IBOutlet var mcl: UIButton!
    @IBOutlet var ucl: UIButton!
    
    @IBOutlet var sync: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    var categoryPicker: UIPickerView!
    
    @IBOutlet var result: WordTestResultView!

    @IBOutlet var export: LGButton!
    @IBOutlet var bottomBar: UIView!

    var categoryDialog: UIAlertController!
    let talkController = TalkViewController()
    let amplitudeController = SteppedViewController()
    let transducerController = TransducerPickerController()
    var model: WordTestPage!
    var storage: Storage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        storage = Storage(storage: appDelegate.persistentContainer)

        amplitudeController.attach(to: amplitudeLabel)
        transducerController.attach(to: transducerPlace)
        talkController.attach(to: bottomBar)
        self.navigationController?.navigationBar.backItem?.title = "Back"
    }
}

extension WordTestViewController: Bindable {
    func bind(model: WordTestPage) {
        self.model = model
        amplitudeController.bind(model: model.amplitudeModel)
        transducerController.bind(model: model.transducerModel)
        talkController.bind()

        model.playButton ||> play ||> disposeBag

        settings.bind(model: model.conductionIdea)
        masking.bind(model: model.masking)
        settings.bind(model: model.player)
        player.bind(model: model.player)
        result.bind(model: model.result)

        play.rx.tap ||> model.pause2 ||> disposeBag
        model.player.didStopped ||> model.pause ||> disposeBag

        model.player.isPlaying ||> skip.rx.isEnabled ||> disposeBag
        setUpCategoryDialog()
        clear.rx.tap ||> model.zeroStat ||> model.wordStat ||> disposeBag
        categoryPicker.rx.itemSelected
            .subscribe { (event) in
                switch event {
                case .next(let selected):
                    model.player.currentCategoryIndex.value = selected.row
                default:
                    break
                }
            } ||> disposeBag
        model.player.currentCategoryIndex.asObservable().subscribe(onNext: { [weak self] (value) in
            self?.categoryButton.setTitle("Select Word List".uppercased(), for: .normal)
        }) ||> disposeBag

        model.category.bind(to: categoryPicker.rx.itemTitles) { (row, element) in
            return element
        } ||> disposeBag

        correct.rx.tap.subscribe({ [weak self] selected in
            guard let `self` = self else { return }
            model.markAsCorrect(file: self.player.player.currentPlayingFile)
        }).disposed(by: disposeBag)

        categoryButton.rx.tap ||> { [weak self] in
            self?.showCategoryDialog()
        } ||> disposeBag

        wrong.rx.tap.subscribe({ [weak self] selected in
            guard let `self` = self else { return }
            model.wrong(file: self.player.player.currentPlayingFile)
        }).disposed(by: disposeBag)

        model.player.didStopped ||> model.zeroStat ||> model.wordStat ||> disposeBag
        score.rx.tap ||> model.score ||> disposeBag
        reset.rx.tap ||> model.reset ||> disposeBag

        model.mclComfortLevelSelected.asObservable().subscribe(onNext: { [weak self] selected in
            self?.configure(button: self?.mcl, selected: selected)
        }).disposed(by: disposeBag)

        model.uclComfortLevelSelected.asObservable().subscribe(onNext: { [weak self] selected in
            self?.configure(button: self?.ucl, selected: selected)
        }).disposed(by: disposeBag)

        model.playedCount ||> playedCount.rx.text ||> disposeBag
        model.correctCount ||> correctCount.rx.text ||> disposeBag

        mcl.rx.tap ||> { .mcl } ||> model.comfortLevel ||> disposeBag
        ucl.rx.tap ||> { .ucl } ||> model.comfortLevel ||> disposeBag
        

//        sync.rx.tap ||> { [weak self] in self?.syncAudio() } ||> disposeBag

        let audio = AudioManager(players: masking.player, talkController.player, player.player)
        self ||> audio ||> disposeBag

        save.rx.tap ||> model.testResultPage ||> { [weak self] (testResultPage: TestResultPage<WordTestResult>) in
            guard let `self` = self else { return }
            // TODO: probably need to add loading property to model and observe it
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            testResultPage.save(with: self.result.asImage()).subscribe(onNext: { [weak self] (success) in
                if success {
                    self?.navigator.back()
                }
                }, onError: { [weak self] (error) in
                    self?.showAlert(error: error)
                }, onDisposed: {
                    hud.hide(animated: true)
            }).disposed(by: self.disposeBag)
            } ||> disposeBag
        
        self.syncAudio()
    }
    
    func setUpCategoryDialog() {
        let message = "\n\n\n\n\n\n"
        categoryDialog = UIAlertController(title: "Please Select Category", message: message, preferredStyle: UIAlertControllerStyle.alert)

        categoryDialog.isModalInPopover = true
        categoryPicker = UIPickerView(frame: CGRect(x: 0, y: 20, width: 200, height: 140))
        
        categoryPicker.center.x = 130
        categoryPicker.tag = 555
        
        categoryDialog.view.addSubview(categoryPicker)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        categoryDialog.addAction(okAction)
    }
    
    func showCategoryDialog() {
        self.parent!.present(categoryDialog, animated: true, completion: nil)
    }
    
    private func syncAudio() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "loading..."
        model.syncAudio { [weak self] (error) in
            guard let `self` = self else { return }
            hud.hide(animated: true)
            guard error == nil else {
                self.showAlert(error: error!)
                return
            }
            self.player.resetDisposeBag()
            self.player.bind(model: self.model.player)
        }
    }
    

    
    private func configure(button: UIButton?, selected: Bool) {
        guard let button = button else {
            return
        }
        button.isSelected = selected

        if selected {
            let buttonStyle = Styles.button.solid()
            buttonStyle.apply(to: button)
        }
        else {
            let buttonStyle = Styles.button.bordered()
            buttonStyle.apply(to: button)
        }
    }
    
    class var viewController: WordTestViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "wordTest") as! WordTestViewController
    }
}

extension WordTestPage: PageViewModel {
    func createController(router: Router) -> UIViewController {
        return router.createController(page: self) as WordTestViewController
    }
}
