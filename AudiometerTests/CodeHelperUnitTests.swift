//
//  CodeHelperUnitTests.swift
//  AudiometerTests
//
//  Created by Bogachov on 26.06.2018.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import XCTest
@testable import Audiometer

class CodeHelperUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldMapCodeToString() {
        var codes: [(MedicalCode, Bool)] = []
        codes.append((MedicalCodeService.icd9codes[0], true))
        codes.append((MedicalCodeService.icd9codes[1], false))
        
        var string = CodeHelper.codeToString(codes: codes)
        assert(string == "{\"315.32\":true,\"380.00\":false}")
        
        codes = []
        codes.append((MedicalCodeService.icd10codes[0], true))
        codes.append((MedicalCodeService.icd10codes[1], false))
        string = CodeHelper.codeToString(codes: codes)
        assert(string == "{\"H93.25\":false,\"F80.2\":true}")
        
        //TODO: finish with cpt
//        codes = []
//        codes.append((MedicalCodeService.cptCodes[0], true))
//        codes.append((MedicalCodeService.cptCodes[1], true))
//        string = CodeHelper.codeToString(codes: codes)
//        assert(string == )
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
