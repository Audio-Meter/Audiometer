//
//  TestTypesViewControoler.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/10/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import AgoraRtmKit
import AgoraRtcKit

class TestTypesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var report: Report?
    var items = Tests.allTypes
    
    
    @IBAction func showReportAction() {
        guard let report = report else { return }
        let service = AllTestNetworkService()
        if let id = report.patient?.id {
            service.fetchTests(patientId: id) { (tests, error) in
                self.report?.tests = tests
                ReportsRouter.show(report: report, from: self)
            }
        }
    }
   
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.font = FontStyle.normal.apply()
        cell.textLabel?.text = type.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = items[indexPath.row]
        guard let patient = report?.patient else {
            return
        }
        TestsRouter.showTest(type: type,
        patient: patient,
        from: self,
        report: report!)
        //TestsRouter.showPreviousTests(type: type, patient: patient, from: self, report: report!)
    }
 
    class var viewController: TestTypesViewController {
        let storyboard = UIStoryboard(name: "Tests", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TestTypesViewController") as! TestTypesViewController
    }
}
