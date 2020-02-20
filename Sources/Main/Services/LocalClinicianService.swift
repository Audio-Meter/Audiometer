//
//  LocalClinicianService.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 8/30/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation
import Apollo

class LocalClinicianService {

    static func createLocalClinician(clinician: LocalClinician, completion: @escaping (_ id: String?, Error?) -> Void) {
        var input = LocalClinicianInput()
        
        input.name = clinician.name
        input.email = clinician.email
        input.certification = clinician.certification
        input.degrees = clinician.degrees
        input.pcp = clinician.pcp
        
        let mutation = CreateLocalClinicianMutation(clinician: input)
        
        ApolloClient.sharedClient.perform(mutation: mutation) { (rs) in
            switch rs {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(nil, graphQLResult.errors!.first)
                } else {
                    completion(graphQLResult.data?.createLocalClinician?.fragments.localClinicianDetails.id, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static func updateLocalClinician(clinician: LocalClinician, completion: @escaping (_ rs:Bool, Error?) -> Void) {
        var input = LocalClinicianInput()
        
        input.name = clinician.name
        input.email = clinician.email
        input.certification = clinician.certification
        input.degrees = clinician.degrees
        input.pcp = clinician.pcp
        
        let mutation = UpdateLocalClinicianMutation(id: clinician.server_id ?? "", clinician: input)
        
        ApolloClient.sharedClient.perform(mutation: mutation) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(false, graphQLResult.errors!.first)
                } else {
                    completion(graphQLResult.data?.updateLocalClinician ?? false, nil)
                }
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    static func fetchLocalClinicians(completion: @escaping ([LocalClinician], Error?) -> Void) {
        let query = LocalCliniciansQuery()

        ApolloClient.sharedClient.fetch(query: query, cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion([], graphQLResult.errors!.first)
                } else {
                    let res = graphQLResult.data?.localClinicians?.compactMap { (item) -> LocalClinician in
                        var clinician = LocalClinician()
                        
                        clinician.server_id = item?.fragments.localClinicianDetails.id
                        clinician.name = item?.fragments.localClinicianDetails.name
                        clinician.email = item?.fragments.localClinicianDetails.email
                        clinician.certification = item?.fragments.localClinicianDetails.certification
                        clinician.degrees = item?.fragments.localClinicianDetails.degrees
                        clinician.pcp = item?.fragments.localClinicianDetails.pcp
                        return clinician
                    }
                    
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
