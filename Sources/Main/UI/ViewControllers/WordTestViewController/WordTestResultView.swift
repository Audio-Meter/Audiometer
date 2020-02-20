//
//  WordTestResultView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/20/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WordTestResultView: UIView {
    @IBOutlet var srt_l: UILabel!
    @IBOutlet var srt_r: UILabel!
    @IBOutlet var srt_sf: UILabel!

    @IBOutlet var sd_l: UILabel!
    @IBOutlet var sd_r: UILabel!
    @IBOutlet var sd_sf: UILabel!

    @IBOutlet var mcl_l: UILabel!
    @IBOutlet var mcl_r: UILabel!
    @IBOutlet var mcl_sf: UILabel!

    @IBOutlet var ucl_l: UILabel!
    @IBOutlet var ucl_r: UILabel!
    @IBOutlet var ucl_sf: UILabel!

    let disposeBag = DisposeBag()
}

extension WordTestResultView: Bindable {
    func bind(model: WordTestResultViewModel) {
        model.srt_l ||> srt_l.rx.text ||> disposeBag
        model.srt_r ||> srt_r.rx.text ||> disposeBag
        model.srt_sf ||> srt_sf.rx.text ||> disposeBag

        model.sd_l ||> sd_l.rx.text ||> disposeBag
        model.sd_r ||> sd_r.rx.text ||> disposeBag
        model.sd_sf ||> sd_sf.rx.text ||> disposeBag

        model.mcl_l ||> mcl_l.rx.text ||> disposeBag
        model.mcl_r ||> mcl_r.rx.text ||> disposeBag
        model.mcl_sf ||> mcl_sf.rx.text ||> disposeBag

        model.ucl_l ||> ucl_l.rx.text ||> disposeBag
        model.ucl_r ||> ucl_r.rx.text ||> disposeBag
        model.ucl_sf ||> ucl_sf.rx.text ||> disposeBag
    }
}
