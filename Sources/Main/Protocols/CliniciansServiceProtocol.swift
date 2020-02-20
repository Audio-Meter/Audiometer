//
//  CliniciansProtocol.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 7/24/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation

protocol CliniciansServiceProtocol {
    func fetchClinicians(completion: @escaping ([Clinician], Error?) -> Void)
    func createNewClinician(info: Clinician, completion: @escaping (String?, Error?) -> Void)
    func editClinician(info: Clinician, completion: @escaping (Error?) -> Void)
}
