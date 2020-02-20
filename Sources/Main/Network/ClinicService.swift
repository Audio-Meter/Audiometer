//
//  ClinicService.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 8/5/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation
import Apollo
import os

class ClinicService {
    
    func updateProfile(profile: Clinic, completion: @escaping (Error?) -> Void) {
        let clinicItem = profile.toItem()
        let update = UpdateClinicProfileMutation(clinic: clinicItem)
        ApolloClient.sharedClient.perform(mutation: update) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(graphQLResult.errors!.first)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    public func getProfile(completion: @escaping (Clinic?, Error?) -> Void) {
        let profileQuery = ClinicProfileQuery()
        ApolloClient.sharedClient.fetch(query: profileQuery, cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(nil, graphQLResult.errors!.first)
                } else {
                    guard let profile = graphQLResult.data?.clinicProfile else {
                        completion(nil, nil)
                        return
                    }

                    var clinic = Clinic()
                    clinic.id = profile.id
                    clinic.name = profile.name
                    clinic.email = profile.email
                    clinic.phone = profile.telephone
                    clinic.fax = profile.fax
                    clinic.website = profile.website
                    
                    completion(clinic, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

extension Clinic {
    func toItem() -> ClinicInput {
        var cinput = ClinicInput()
        cinput.email = self.email
        cinput.fax = self.fax
        cinput.telephone = self.phone
        cinput.password = self.password
        cinput.website = self.website
        return cinput
    }
}
