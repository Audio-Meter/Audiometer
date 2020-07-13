//
//  MedicalCodeService.swift
//  Audiometer
//
//  Created by Roman Stetsenko on 3/14/18.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import RxSwift
import Apollo

struct MedicalCodeService {
    static let icd10codes: [MedicalCode] = {
        let pathToJSONFile = Bundle.main.url(forResource: "ICD-10-Codes", withExtension: "json")!
        return MedicalCodeService.parseCodes(jsonFilePath: pathToJSONFile, table: .icd10)
    }()
    
    static let icd9codes: [MedicalCode] = {
        let pathToJSONFile = Bundle.main.url(forResource: "ICD-9-Codes", withExtension: "json")!
        return parseCodes(jsonFilePath: pathToJSONFile, table: .icd9)
    }()
    
    static let fdaCodes: [MedicalCode] = {
        let pathToJSONFile = Bundle.main.url(forResource: "FDA-Codes", withExtension: "json")!
        return MedicalCodeService.parseCodes(jsonFilePath: pathToJSONFile, table: .fda)
    }()
    
    static let cptCodes: [MedicalCode] = {
        let pathToJSONFile = Bundle.main.url(forResource: "CPT-Codes", withExtension: "json")!
        return MedicalCodeService.parseCodes(jsonFilePath: pathToJSONFile, table: .cpt)
    }()
    
    static let cptCodesEmptyList: [(MedicalCode, Bool)] = {
        var list: [(MedicalCode, Bool)] = []
        for code in cptCodes {
            list.append((code, false))
        }
        return list
    }()
    
    static let recommendations: [MedicalCode] = {
        let dictionary = [
            [kTitle: "ABR"],
            [kTitle: "Additional Audiometric Tests"],
            [kTitle: "Amplification"],
            [kTitle: "Cerumen Removal"],
            [kTitle: "Refer to ENT"],
            [kTitle: "Hearing Aids"],
            [kTitle: "OAE's"],
            [kTitle: "ENG/VNG"],
            [kTitle: "Tympanogram"],
            [kTitle: "Stenger"],
            [kTitle: "Tone Decay"],
            [kTitle: "Auditory Processing testing"]]
        return MedicalCodeService.parseCodes(dictionary: dictionary, table: .recommendation)
    }()
    
    static let recommendationEmptyList: [(MedicalCode, Bool)] = {
        var list: [(MedicalCode, Bool)] = []
        for recomendation in recommendations {
            list.append((recomendation, false))
        }
        return list
    }()
    
    static let other: [MedicalCode] = {
        let dictionary = [
            [kTitle: "TYMPANOMETRY"],
            [kTitle: "OAE"],
            ]
        return MedicalCodeService.parseCodes(dictionary: dictionary, table: .other)
    }()
    
    // MARK: - Helpers
    private static let kTitle = "title"
    private static let kDescription = "description"
    
    private static func parseCodes(jsonFilePath: URL, table: MedicalCode.Table) -> [MedicalCode] {
        let data = (try? Data(contentsOf: jsonFilePath)) ?? Data()
        guard let parsedObject = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String: String]] else {
            return []
        }
        return parseCodes(dictionary: parsedObject, table: table)
    }
    
    private static func parseCodes(dictionary: [[String: String]], table: MedicalCode.Table) -> [MedicalCode] {
        let result = dictionary.enumerated().map({ (index, item) -> MedicalCode in
            let title = item[kTitle] ?? ""
            let description = item[kDescription]
            let code = MedicalCode(id: index, table: table, title: title, description: description)
            return code
        })
        return result
    }
}
