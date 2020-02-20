            //
//  PatientsListViewModel.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/24/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class PatientsListViewModel {
    private var service: PatientsServiceProtocol
    private var allPatients: [PatientInfo] = []

    var patients = Variable<[PatientInfo]>([])
    var error = Variable<Error?>(nil)
    var loading = Variable(false)
    
    init(service: PatientsServiceProtocol = PatientsService()) {
        self.service = service
        guard let user = User.current else {
            return
        }
        user.getProfile()
    }
    
    func fetchPatients(completion: @escaping () -> Void) {
        self.loading.value = true
        service.fetchPatients { (items, error) in
            self.loading.value = false
            self.error.value = error
            self.allPatients = items
            self.patients.value = items
            
            completion()
        }
    }
    
    func searchPatients(text: String) {
        guard text.isEmpty == false else {
            patients.value = allPatients
            return
        }
        let filteredPatients = allPatients.filter { (item) -> Bool in
            return item.fullName.lowercased().contains(text.lowercased())
        }
        patients.value = filteredPatients
    }
    
    func update(patientInfo: PatientInfo) -> Int? {
        let index = allPatients.index { (patient) -> Bool in
            return patient.id == patientInfo.id
        }
        if let itemIndex = index {
            allPatients.remove(at: itemIndex)
            if itemIndex >= allPatients.count {
                allPatients.append(patientInfo)
            }
            else {
               allPatients.insert(patientInfo, at: itemIndex)
            }
            self.patients.value = allPatients
            return itemIndex
        }
        return nil
    }
}
