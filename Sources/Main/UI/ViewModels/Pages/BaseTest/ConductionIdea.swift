//
//  ConductionIdea.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/4/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class ConductionIdea {
    let conductionIndex = Variable(0)
    let conductionIndexPath = Variable(IndexPath(row: 0, section: 0))
    let channel = Variable(Channel.left)

    var left: Observable<Bool> {
        return pans.map { $0 != Channel.right.pan }
    }

    var right: Observable<Bool> {
        return pans.map { $0 != Channel.left.pan }
    }
    
    
    var type: Observable<Void> {
        return conductionIndexPath.asObservable().map {
            switch $0.row {
            case 0: self.channel.value = .left
            case 1: self.channel.value = .right
            default: break
            }
        }
    }
    
    
    var conductions: Observable<Conduction> {
        return Observable.combineLatest(conductionIndex.asObservable(), channel.asObservable()) {
            .create(index: $0, channel: $1)
        }.unwrap()
    }

    lazy var pans: Observable<Double> = {
        let values = Observable.combineLatest(channel.asObservable(), conductionIndex.asObservable()).map {
            (channel:$0, conduction:$1)
        }
        return values.scan(Channel.left.pan) { pan, value in
            if value.conduction == 2 {
                return value.channel.applyTo(pan: pan)
            } else {
                return value.channel.pan
            }
        }
    }()
}
