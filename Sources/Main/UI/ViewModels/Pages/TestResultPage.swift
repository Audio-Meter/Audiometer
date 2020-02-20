//
//  TestResultPage.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/7/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class TestResultPage<T : TestInfoProtocol> {
    let app: App
    var testResult: T
    var canEdit = true
    var report: Report
    
    private let networkService: TestNetworkService<T>
    
    init(app: App, testResult: T, report: Report) {
        self.app = app
        self.testResult = testResult
        self.networkService = TestNetworkService()
        self.report = report
    }

    var title: String {
        return testResult.date.format()
    }
    
    func save(with image: UIImage) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let `self` = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.networkService.createTest(patientId: self.testResult.patientId, test: self.testResult, image: image) { (error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

extension TestResultPage : PageViewModel {
    func createController(router: Router) -> UIViewController {
        if let page = self as? TestResultPage<TestResult> {
            return router.createController(page: page) as TestResultViewController
        } else if let page = self as? TestResultPage<WordTestResult> {
            return router.createController(page: page) as WordTestResultViewController
        } else {
            fatalError("no controller for type \(type(of: self))")
        }
    }
}
