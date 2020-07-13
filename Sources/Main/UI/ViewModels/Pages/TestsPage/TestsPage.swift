//
//  TestsPage.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/11/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

class TestsPage {
    let app = App()
    
     var viewModel:PreviousTestsViewModel!
    
    func toneTestPage(patientId: String, report: Report,viewModel: PreviousTestsViewModel) -> ToneTestPage {
        
        self.viewModel = viewModel
        return ToneTestPage(app: app, patientId: patientId, report: report, ViewModel: viewModel)
    }
    
    func wordTestPage(patientId: String, report: Report) -> WordTestPage {
        return WordTestPage(app: app, patientId: patientId, report: report)
    }
   
}
 class testinfo
{
     static var viewModel:PreviousTestsViewModel!
    
   static func SetViewModel(viewModels:PreviousTestsViewModel)
    {
        
        viewModel = viewModels
    }
    
   static func getTheviewmodel()->PreviousTestsViewModel
    {
        
        return testinfo.viewModel!
    }
    
    
}
