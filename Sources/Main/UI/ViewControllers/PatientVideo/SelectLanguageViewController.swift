//
//  SelectLanguageViewController.swift
//  Audiometer
//
//  Created by Arun Jangid on 27/04/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit

class SelectLanguageViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!

    let datasource = LanguageDatasource()
    class var viewController:SelectLanguageViewController{
        return UIStoryboard.patientVideo.instantiateViewController(withIdentifier: "SelectLanguageViewController") as! SelectLanguageViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = datasource
    }
    

    

}

extension SelectLanguageViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prev = datasource.selectedIndexpath
        datasource.selectedIndexpath = indexPath
        self.tableView.reloadRows(at: [prev, indexPath], with: .automatic)
    }
}
