//
//  AuthorizationService.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/2/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation
import Apollo
import KeychainSwift

struct AuthorizationService: AuthorizationServiceProtocol {
    private static let kAuthorizationServicePassword = "authorizationServicePassword"
    
    static var userPassword: String? {
        let keychain = KeychainSwift()
        return keychain.get(kAuthorizationServicePassword)
    }
    
    func forgotPassword(email: String, completion: @escaping (Error?) -> Void) {
        let forgot = ForgotPasswordMutation(email: email)
        ApolloClient.sharedClient.perform(mutation: forgot) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(graphQLResult.errors!.first)
                } else {
                    if graphQLResult.data?.resetPassword != true {
                        let nsError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Can't reset password"])
                        completion(nsError)
                    }
                }
            case .failure(let error):
                NSLog("Error while fetching query: \(error.localizedDescription)")
                completion(error)
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        ApolloClient.sharedClient.clearCache(completion: { rs in
            let login = LoginMutation(email: email, password: password)
            ApolloClient.sharedClient.perform(mutation: login) { (result) in
                switch result {
                case .success(let graphQLResult):
                    if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                        completion(graphQLResult.errors!.first)
                    } else {
                        guard let data = graphQLResult.data else {
                            fatalError("expect to have data")
                        }
                        guard let token = data.login else {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty authorizarion token"])
                            completion(error)
                            return
                        }
                        ApolloClient.add(authorizationToken: token)
                        KeychainSwift().set(password, forKey: AuthorizationService.kAuthorizationServicePassword)
                        completion(nil)
                    }
                case .failure(let error):
                    completion(error)
                }
            }
        })
    }
}
