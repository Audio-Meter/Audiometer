//
//  PreviousTestsViewModel.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/23/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation
import RxSwift

protocol PreviousTestsViewModelProtocol {
    var testType: Tests { get set }
    var patientInfo: PatientInfo { get set }
    var tests: Variable<[TestInfoProtocol]> { get }
    var loading : Observable<Bool> { get }
    var title: String { get }
    var report: Report { get }
    func fetchTests()
    func testInfo(at indexPath: IndexPath) -> TestInfoProtocol
}

class PreviousTestsViewModel: PreviousTestsViewModelProtocol {
    fileprivate var isLoading: Variable<Bool> = Variable(false)
    
    var loading: Observable<Bool> {
        return isLoading.asObservable()
    }
    var title: String {
        return testType.title
    }
    var testType: Tests
    var patientInfo: PatientInfo
    var tests: Variable<[TestInfoProtocol]> = Variable<[TestInfoProtocol]>([])
    var report: Report
    
    init(testType: Tests, patientInfo: PatientInfo, report: Report) {
        self.testType = testType
        self.patientInfo = patientInfo
        self.report = report
    }
    func fetchTests() {
    }
    
    func testInfo(at indexPath: IndexPath) -> TestInfoProtocol {
        return tests.value[indexPath.row]
    }
}

class PreviousACBCTestsViewModel: PreviousTestsViewModel {
    let service = TestNetworkService<TestResult>()
    override func fetchTests() {
        self.isLoading.value = true
        service.fetchTests(patientId: patientInfo.id ?? "") { (result, error) in
            self.isLoading.value = false
            self.tests.value = result
        }
    }
}

class PreviousSRTSDSINTestsViewModel: PreviousTestsViewModel {
    let service = TestNetworkService<WordTestResult>()
    override func fetchTests() {
        self.isLoading.value = true
        service.fetchTests(patientId: patientInfo.id ?? "") { (result, error) in
            self.isLoading.value = false
            self.tests.value = result
        }
    }
}


