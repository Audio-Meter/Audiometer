//
//  ProfileService.swift
//  Audiometer
//
//  Created by Bogachov on 25.06.2018.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import Foundation
import Apollo

protocol ProfileServiceProtocol {
    func updateProfile(completion: @escaping (Error?) -> Void)
}

struct ProfileService: ProfileServiceProtocol {
    func updateProfile(completion: @escaping (Error?) -> Void) {
        guard let profile =  User.current?.toProfileInput() else {
            return
        }
        let updateProfile = UpdateProfileMutation(profile: profile)
        ApolloClient.sharedClient.perform(mutation: updateProfile) { (result, error) in
            if let errors = result?.errors, errors.count > 0 {
                completion(errors[0])
                return
            }
            completion(error)
        }
    }
    
}

extension User {
    func toProfileInput() -> ProfileInput {
        return ProfileInput(
            icd_9: CodeHelper.codeToString(codes: ic_9.value),
            icd_10: CodeHelper.codeToString(codes: ic_10.value),
            signature: signature.value)
    }
}
