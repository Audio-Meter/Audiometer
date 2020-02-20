//
//  CodesRouter.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/10/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

struct CodesRouter {
    static let items = ["ICD10 Codes"] //"ICD9 Codes", "Favorite ICD 9 & 10 codes"
    
    static func showCodes(index: Int, report: Report, from: UINavigationController) {
        let codes: Variable<[MedicalCode]>
        switch index {
//        case 0:
//            codes = Variable(MedicalCodeService.icd9codes)
        case 0:
            codes = Variable(MedicalCodeService.icd10codes)
//        case 2:
//            codes = User.current!.favCodes
        default:
            fatalError()
            break
        }
        let vc = MedicalCodesViewController.newViewController(report: report, codes: codes)
        from.pushViewController(vc, animated: true)
    }
}


