//
//  WordPlayerView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class WordPlayerView: UIView {
    var disposeBag = DisposeBag()

    @IBOutlet var words: UITableView!

    var wordsProvider: WordTableProvider!
    let player = WordPlayer()
    
    func resetDisposeBag() {
        disposeBag = DisposeBag()
    }
}

extension WordPlayerView: Bindable {
    func bind(model: WordPlayerIdea) {
        wordsProvider = WordTableProvider(table: words, items: model.playlist)
        wordsProvider ||> disposeBag
        wordsProvider.selected <||> model.word ||> disposeBag
        model.wordChanged ||> (.bottom, true) ||> self.words.scrollToNearestSelectedRow ||> disposeBag
        
        model.test.playDidTapped ||> model.play ||> disposeBag
        model.typeChanged ||> model.stop ||> disposeBag

        model.config ||> player ||> disposeBag
        model.test.playDidToggled ||> player.next ||> model.nextWord ||> disposeBag
    }
}
