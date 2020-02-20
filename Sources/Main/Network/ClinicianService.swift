//
//  ClinicianService.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 7/24/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation
import Apollo


struct CliniciansService: CliniciansServiceProtocol {
    func createNewClinician(info: Clinician, completion: @escaping (String?, Error?) -> Void) {

        let clinicianItem = info.toClinicianItem()
        let createClinician = CreateClinicianMutation(clinician: clinicianItem)
        ApolloClient.sharedClient.perform(mutation: createClinician) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(nil, graphQLResult.errors!.first)
                } else {
                    let id: String? = graphQLResult.data?.createClinician?.fragments.clinicianDetails.id
                    completion(id, nil)
                }
            case .failure(let error):
                NSLog("Error while fetching query: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    func editClinician(info: Clinician, completion: @escaping (Error?) -> Void) {
        let clinicianItem = info.toClinicianItem()
        let update = UpdateClinicianMutation(id: info.id ?? "", clinician: clinicianItem)
        ApolloClient.sharedClient.perform(mutation: update) { (result) in
            
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(graphQLResult.errors!.first)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                NSLog("Error while fetching query: \(error.localizedDescription)")
                completion(error)
            }
        }
    }
    
    func fetchClinicians(completion: @escaping ([Clinician], Error?) -> Void) {
        let cliniciansQuery = CliniciansQuery()
        ApolloClient.sharedClient.fetch(query: cliniciansQuery, cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result) in
            switch result {
                case .success(let graphQLResult):
                    if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                        completion([], graphQLResult.errors!.first)
                    } else {
                        let res = graphQLResult.data?.clinicians?.flatMap({ (item) -> Clinician in
                            var clinician = Clinician()
                            clinician.id = item?.fragments.clinicianDetails.id
                            clinician.name = item?.fragments.clinicianDetails.name
                            clinician.email = item?.fragments.clinicianDetails.email
                            clinician.degrees = item?.fragments.clinicianDetails.degrees
                            clinician.certification = item?.fragments.clinicianDetails.certification
                            clinician.pcp = item?.fragments.clinicianDetails.pcp
                            clinician.disabled = item?.fragments.clinicianDetails.disabled
                            return clinician
                        })
                        if res != nil {
                            completion(res!, nil)
                        }
                    }
                case .failure(let error):
                    completion([], error)
            }
        }
    }
}

extension Clinician {
    func toClinicianItem() -> ClinicianInput {
        var cinput = ClinicianInput()
        cinput.name = self.name
        cinput.degrees = self.degrees
        cinput.email = self.email
        cinput.certification = self.certification
        cinput.pcp = self.pcp
        cinput.disabled = self.disabled
        cinput.password = self.password
        return cinput
    }
}
