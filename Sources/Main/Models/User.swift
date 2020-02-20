//
//  User.swift
//  Audiometer
//
//  Created by Roman Stetsenko on 6/12/18.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import Foundation
import RxSwift
import Apollo
import os
class User {
    static var current: User? = nil
    
    var signature: Variable<UIImage?> = Variable(nil)
    let favCodes: Variable<[MedicalCode]> = Variable([])
    var userCategory: UserCateogry?
    let helpAndInfo: Variable<URL?> = Variable(nil)
    
    func getUserCategory(completion: @escaping () -> Void) {
        ApolloClient.sharedClient.fetch(query: CommonProfileQuery(), cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result) in
            switch result {
            case .success(let graphQLResult):
                guard let profile = graphQLResult.data?.profile else {
                    return
                }
                self.userCategory = profile.type
                completion()
            case .failure(let error):
                os_log("getUserCategory failed.")
            }
        }
    }
    
    func getProfile() {
        ApolloClient.sharedClient.fetch(query: ProfileQuery(), cachePolicy: .fetchIgnoringCacheData) { (result) in
            switch result {
            case .success(let graphQLResult):
                guard let profile = graphQLResult.data?.profile else {
                    return
                }
                self.userCategory = profile.type

                if let signature = profile.signature {
                    guard let url = URL(string: signature) else { return }
                    
                    self.getImageFromUrl(url: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        self.signature.value = UIImage(data: data)
                    }
                }
                // icd9
                var icd9Favs = [MedicalCode]()
                if let icd = profile.fragments.profileDetails.icd_9 {
                    if let data = icd.data(using: .utf8) {
                        if let codes = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Bool] {
                            for (key, value) in codes {
                                if value != true {
                                    continue
                                }
                                if let icdCode = MedicalCodeService.icd9codes.first(where: { $0.title == key }) {
                                    icd9Favs.append(icdCode)
                                }
                            }
                        }
                    }
                }
                
                // icd10
                var icd10Favs = [MedicalCode]()
                if let icd = profile.fragments.profileDetails.icd_10 {
                    if let data = icd.data(using: .utf8) {
                        if let codes = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Bool] {
                            for (key, value) in codes {
                                if value != true {
                                    continue
                                }
                                if let icdCode = MedicalCodeService.icd10codes.first(where: { $0.title == key }) {
                                    icd10Favs.append(icdCode)
                                }
                            }
                        }
                    }
                }
                
                self.favCodes.value = icd9Favs + icd10Favs
                
                if let helpAndInfo = profile.helpAndInfo {
                    self.helpAndInfo.value = URL(string: helpAndInfo)
                }
             case .failure(let error):
                 os_log("getUserCategory failed.")
             }
        }
    }
    
    func favUnfav(code: MedicalCode, completion: @escaping (Error?) -> Void) {
        if favCodes.value.contains(code) {
            removeFromFav(code: code, completion: completion)
        } else {
            addToFav(code: code, completion: completion)
        }
    }
    
    private func addToFav(code: MedicalCode, completion: @escaping (Error?) -> Void) {
        let profile: ProfileInput
        switch code.table {
        case .icd9:
            var icdCodes = self.favCodes.value.filter({ $0.table == .icd9 })
            guard icdCodes.index(of: code) == nil else {
                return
            }
            icdCodes.append(code)
            let icd9String = icdString(for: icdCodes)
            profile = ProfileInput(icd_9: icd9String)
        case .icd10:
            var icdCodes = self.favCodes.value.filter({ $0.table == .icd10 })
            guard icdCodes.index(of: code) == nil else {
                return
            }
            icdCodes.append(code)
            let icd10String = icdString(for: icdCodes)
            profile = ProfileInput(icd_10: icd10String)
        default:
            fatalError("unsupported table")
        }
        
        saveProfile(profile: profile, completion: { (error) in
            if error == nil {
                self.favCodes.value.append(code)
            }
            completion(error)
        })
    }
    
    private func removeFromFav(code: MedicalCode, completion: @escaping (Error?) -> Void) {
        let profile: ProfileInput
        switch code.table {
        case .icd9:
            var icdCodes = self.favCodes.value.filter({ $0.table == .icd9 })
            guard let index = icdCodes.index(of: code) else {
                return
            }
            icdCodes.remove(at: index)
            let icd9String = icdString(for: icdCodes)
            profile = ProfileInput(icd_9: icd9String)
        case .icd10:
            var icdCodes = self.favCodes.value.filter({ $0.table == .icd10 })
            guard let index = icdCodes.index(of: code) else {
                return
            }
            icdCodes.remove(at: index)
            let icd10String = icdString(for: icdCodes)
            profile = ProfileInput(icd_10: icd10String)
        default:
            fatalError("unsupported table")
        }
        
        saveProfile(profile: profile, completion: { (error) in
            if error == nil {
                if let index = self.favCodes.value.index(of: code) {
                    self.favCodes.value.remove(at: index)
                }
            }
            completion(error)
        })
    }
    
    func updateSignature(image: UIImage, completion: @escaping (Error?) -> Void) {
        let profile = ProfileInput(signature: String.base64StringForApi(image: image))
        saveProfile(profile: profile) { (error) in
            if error == nil {
                self.signature.value = image
            }
            completion(error)
        }
    }
    
    func getImageFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    // MARK: - Helpers
    private func saveProfile(profile: ProfileInput, completion: @escaping (Error?) -> Void) {
        let updateProfile = UpdateProfileMutation(profile: profile)
        ApolloClient.sharedClient.perform(mutation: updateProfile) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.data?.updateProfile != true {
                    let error = NSError(domain: "api", code: -1, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
                    completion(error)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private func icdString(for codes: [MedicalCode]) -> String {
        var jsonObject = [String: Bool]()
        codes.forEach({ jsonObject[$0.title] = true })
        guard let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
