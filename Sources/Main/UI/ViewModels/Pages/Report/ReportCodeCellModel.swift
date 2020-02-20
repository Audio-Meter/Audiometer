//
//  ReportCodeCellModel.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/13/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift
import RxCocoa


protocol ReportCodeCellModelProtocol {
    var value: Variable<Bool> { get set }
    var used: PublishRelay<Void> { get set }
    var name: String { get }
    var type: MedicalCode.Table { get }
}

class ReportCodeCellModel: ReportCodeCellModelProtocol {
    var name: String {
        return code.fullName
    }
    
    var type: MedicalCode.Table {
        return code.table
    }
    
    let code: MedicalCode
    var value: Variable<Bool>
    var used = PublishRelay<Void>()

    init(codeAnswer: MedicalCodeAnswer) {
        self.code = codeAnswer.code
        self.value = Variable(codeAnswer.answer)
    }
}

