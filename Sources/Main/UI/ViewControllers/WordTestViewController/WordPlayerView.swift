//
//  WordPlayerView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import AgoraRtmKit

class WordPlayerView: UIView {
    var disposeBag = DisposeBag()

    @IBOutlet var words: UITableView!

    var wordsProvider: WordTableProvider!
    let player = WordPlayer()

    var currentConfig:WordConfig!
    
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

        
        if let channel = AgoraRtm.rtmChannel{
            model.config.subscribe({ (config) in
                self.sendRawMessage(config.element, channel: channel)
            }).disposed(by: disposeBag)
            
        }else{
          
        }
        model.config ||> player ||> disposeBag
        model.test.playDidToggled ||> player.next ||> model.nextWord ||> disposeBag

        
                
        
    }
    
    func sendRawMessage(_ word:WordConfig?, channel:AgoraRtmChannel){
        
        if let sendSetting = word?.getWordSendSettings(), let data = sendSetting.getData(){
            currentConfig = word
            print("sent raw message \(sendSetting)")
            let rawMessage = AgoraRtmRawMessage(rawData: data, description: "maskSetting")
            channel.send(rawMessage) { (errorCode) in
                
            }
        }
    }
}
