    //
//  TestService.swift
//  Audiometer
//
//  Created by Bogachov on 22.06.2018.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//
import Apollo
import Foundation
struct TestNetworkService<T : TestInfoProtocol> {
    func fetchTests(patientId: String, completion: @escaping ([T], Error?) -> Void) {
        let patientQuery = PatientQuery(id: patientId)
        ApolloClient.sharedClient.fetch(query: patientQuery, cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion([], graphQLResult.errors!.first)
                } else {
                    var tests: [T] = []
                    graphQLResult.data?.patient?.tests?.forEach { test in
                        var testToAppend: TestInfoProtocol? = nil
                        if test?.fragments.testDetails.kind == Tests.speech.rawValue {
                            testToAppend = WordTestResult.test(from: test?.fragments.testDetails.result)
                            testToAppend?.id = test?.fragments.testDetails.id
                        } else {
                            testToAppend = TestResult.test(from: test?.fragments.testDetails.result)
                            testToAppend?.id = test?.fragments.testDetails.id
                        }
                        if let test = testToAppend as? T {
                            tests.append(test)
                        }
                    }
                    completion(tests, nil)
                }
            case .failure(let error):
                completion([], error)
            }
        }
    }

    func createTest(patientId: String?, test: TestInfoProtocol, image: UIImage, completion: @escaping (Error?) -> Void) {
        let testInput = TestInput(result: test.result, kind: test.type, comment: test.comment, image: String.base64StringForApi(image: image))
        let createTest = CreateTestMutation(patient_id: patientId!, test: testInput)
        ApolloClient.sharedClient.perform(mutation: createTest) { (result) in
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
}

struct AllTestNetworkService {
    func fetchTests(patientId: String, completion: @escaping ([PatientTest], Error?) -> Void) {
        let patientQuery = PatientQuery(id: patientId)
        ApolloClient.sharedClient.fetch(query: patientQuery, cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion([], graphQLResult.errors!.first)
                } else {
                    let tests: [PatientTest] = self.toTestInfoProtocol(tests: graphQLResult.data?.patient?.tests)
                    completion(tests, nil)
                }
            case .failure(let error):
                completion([], error)
            }
        }
    }
}

extension AllTestNetworkService {
    func toTestInfoProtocol(tests: [PatientQuery.Data.Patient.Test?]?) -> [PatientTest] {
        var testsArray: [PatientTest] = []
        guard let tests = tests else {
            return []
        }
        tests.forEach { test in
            var testToAppend: TestInfoProtocol? = nil
            if test?.fragments.testDetails.kind == Tests.speech.rawValue {
                testToAppend = WordTestResult.test(from: test?.fragments.testDetails.result)
                testToAppend?.id = test?.fragments.testDetails.id
            } else {
                testToAppend = TestResult.test(from: test?.fragments.testDetails.result)
                testToAppend?.id = test?.fragments.testDetails.id
            }
            if let sTestToAppend = testToAppend {
                testsArray.append(sTestToAppend.toPatientTest())
            }
        }
        return testsArray
    }
}

extension TestInfoProtocol {
    func toPatientTest() -> PatientTest {
        return PatientTest(
            id: id,
            date: date,
            type: type,
            result: result,
            comment: comment)
    }
}
