//
//  LocalClinicService.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 8/26/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation
import Apollo
import os

class LocalClinicService {
    
    static func createLocalClinic(clinic: LocalClinic, completion: @escaping (_ id: String?, Error?) -> Void) {
        var input = LocalClinicInput()
        
        input.name = clinic.name
        input.email = clinic.email
        input.tel = clinic.tel
        input.fax = clinic.fax
        input.address = clinic.address
        input.website = clinic.website
        
        let mutation = CreateLocalClinicMutation(clinic: input)
        
        ApolloClient.sharedClient.perform(mutation: mutation) { (rs) in
            switch rs {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(nil, graphQLResult.errors!.first)
                } else {
                    completion(graphQLResult.data?.createLocalClinic?.fragments.localClinicDetails.id, nil)
                }
            case .failure(let error):
                NSLog("Error while fetching query: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }

    static func updateLocalClinic(clinic: LocalClinic, completion: @escaping (_ rs:Bool, Error?) -> Void) {
        var input = LocalClinicInput()
        
        input.name = clinic.name
        input.email = clinic.email
        input.tel = clinic.tel
        input.fax = clinic.fax
        input.address = clinic.address
        input.website = clinic.website
        
        let mutation = UpdateLocalClinicMutation(id: clinic.server_id ?? "", clinic: input)

        ApolloClient.sharedClient.perform(mutation: mutation) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(false, graphQLResult.errors!.first)
                } else {
                    completion(graphQLResult.data?.updateLocalClinic ?? false, nil)
                }
            case .failure(let error):
                NSLog("Error while fetching query: \(error.localizedDescription)")
                completion(false, error)
            }
            
            
        }
    }

    static func fetchLocalClinics(completion: @escaping ([LocalClinic], Error?) -> Void) {
        let query = LocalClinicsQuery()
        
        ApolloClient.sharedClient.fetch(query: query, cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion([], graphQLResult.errors!.first)
                } else {
                    let res = graphQLResult.data?.localClinics?.map({ (item) -> LocalClinic in
                        var clinic = LocalClinic()
                        clinic.server_id = item?.fragments.localClinicDetails.id
                        clinic.name = item?.fragments.localClinicDetails.name
                        clinic.address = item?.fragments.localClinicDetails.address
                        clinic.email = item?.fragments.localClinicDetails.email
                        clinic.tel = item?.fragments.localClinicDetails.tel
                        clinic.fax = item?.fragments.localClinicDetails.fax
                        return clinic
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
