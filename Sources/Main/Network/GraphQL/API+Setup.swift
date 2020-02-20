//
//  API+Setup.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/24/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Apollo

#if DEBUG
//let graphlQLEndpointURL = "http://127.0.0.1:3000/graphql" // New Production
let graphlQLEndpointURL = "https://app.iaudiometer.com/graphql" // New Production
#else
let graphlQLEndpointURL = "https://app.iaudiometer.com/graphql" // New Production
#endif

//let graphlQLEndpointURL = "https://audiometer-api.herokuapp.com/graphql" // Staging
//let graphlQLEndpointURL = "https://app.melmedtronics.com/graphql" // Old Production

fileprivate var apollo = ApolloClient(url: URL(string: graphlQLEndpointURL)!)
fileprivate var authorizedApollo: ApolloClient?

class AuthorizedDelegator: HTTPNetworkTransportPreflightDelegate {
    static let shared = AuthorizedDelegator()
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return isAuthorized
    }

    func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        // Get the existing headers, or create new ones if they're nil
        var headers = request.allHTTPHeaderFields ?? [String: String]()

        // Add any new headers you need
        headers["Authorization"] = token

        // Re-assign the updated headers to the request.
        request.allHTTPHeaderFields = headers
    }
    
    private let authKey = "kAuthToken"
    private var token: String {
        return UserDefaults.standard.string(forKey: authKey) ?? ""
    }
    
    public func reset() {
        UserDefaults.standard.setValue(nil, forKeyPath: authKey)
    }
    
    public func add(authorizationToken: String) {
        UserDefaults.standard.setValue(authorizationToken, forKeyPath: authKey)
    }
    
    var isAuthorized: Bool {
        guard let token = UserDefaults.standard.string(forKey: authKey) else {
            return false
        }
        return token.isEmpty == false
    }
}

extension ApolloClient {
    class var sharedClient: ApolloClient {
        if isAuthorized {
            if authorizedApollo == nil {
//                let configuration = URLSessionConfiguration.default
//                let authToken = token
//                configuration.httpAdditionalHeaders = ["Authorization": authToken]

                let url = URL(string: graphlQLEndpointURL)!
                let nt = HTTPNetworkTransport(url: url, delegate: AuthorizedDelegator.shared)
                authorizedApollo =  ApolloClient(networkTransport: nt)
            }
            return authorizedApollo!
        }
        return apollo
    }
    
    class var isAuthorized: Bool {
        return AuthorizedDelegator.shared.isAuthorized
//        guard let token = UserDefaults.standard.string(forKey: authKey) else {
//            return false
//        }
//        return token.isEmpty == false
    }
    
    class func add(authorizationToken: String) {
        AuthorizedDelegator.shared.add(authorizationToken: authorizationToken)
//        type(of: preflightDelegate).add(authorizationToken: authorizationToken)
    }
    
    class func reset() {
        authorizedApollo = nil
        AuthorizedDelegator.shared.reset()
//        type(of: self).preflightDelegate.reset();
    }
}
