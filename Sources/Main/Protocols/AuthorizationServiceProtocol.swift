//
//  AuthorizationServiceProtocol.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/2/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

protocol AuthorizationServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Error?) -> Void)
    func forgotPassword(email: String, completion: @escaping (Error?) -> Void)
    
    static var userPassword: String? { get }
}
