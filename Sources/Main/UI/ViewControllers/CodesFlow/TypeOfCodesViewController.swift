//
//  TypeOfCodesViewController.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/10/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class TypeOfCodesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var report: Report!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func answerQuestionsAction(_ sender: UIButton) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CodesRouter.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = CodesRouter.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.font = FontStyle.normal.apply()
        cell.textLabel?.text = item
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        CodesRouter.showCodes(index: indexPath.row, report: report, from: self.navigationController!)
    }
    
    class func viewController(report: Report) -> TypeOfCodesViewController {
        let storyboard = UIStoryboard(name: "Codes", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TypeOfCodesViewController") as! TypeOfCodesViewController
        vc.report = report
        return vc
    }
}
