//
//  MinicogStep1ViewController.swift
//  Audiometer
//
//  Created by Dogra Tech on 17/03/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit
import AgoraRtmKit

struct CellData {
    var Open = Bool()
    var Tittle = String()
    var SectionData = [String]()
    var SavedPoint = [String]()
}
class SavePoint
{
    var SubTitle : String = ""
    var Point : String = ""
}


class MinicogStep1ViewController: UIViewController,CallDelegate{

    @IBOutlet weak var yestBtn: UIButton!
    
    var SectionNumber : Int = 0
    
    @IBOutlet weak var MiniCogWordList: UITableView!
    
    let cellSpacingHeight: CGFloat = 7

    
      var TableViewData = [CellData]()
      var SelectedDetails = [CellData]()
    @IBOutlet weak var noBtn: UIButton!
    var callObsever:Any?
    var remoteVC:SelectRemoteViewController?
    
    
    @IBOutlet weak var BottmTxtLabel: UILabel!
    
    var MoneyAdded :String = "Mini-Cog™ © S. Borson. All rights reserved. Reprinted with permission of the author solely for clinical and educational purposes. May not be modified or used for commercial, marketing, or research purposes without permission of the author (soob@uw.edu).  *Used with permission."
    
    override func viewDidLoad() {
        super.viewDidLoad()

            self.MiniCogWordList.delegate = self
            self.MiniCogWordList.dataSource = self
             
        TableViewData = [CellData(Open: false, Tittle: "Version 1", SectionData: ["Banana","Sunrise","Chair"],SavedPoint:["0","0","0"]),CellData(Open: false, Tittle: "Version 2", SectionData: ["Leader","Season","Table"],SavedPoint:["0","0","0"]),CellData(Open: false, Tittle: "Version 3", SectionData: ["Village","Kitchen","Baby"],SavedPoint:["0","0","0"]),CellData(Open: false, Tittle: "Version 4", SectionData: ["River","Nation","Finger"],SavedPoint:["0","0","0"]),CellData(Open: false, Tittle: "Version 5", SectionData: ["Captain","Garden","Picture"],SavedPoint:["0","0","0"]),CellData(Open: false, Tittle: "Version 6", SectionData: ["Daughter","Heaven","Mountain"],SavedPoint:["0","0","0"])]
             
       
         self.MiniCogWordList.register(UINib.init(nibName: "MiniCogWordtest", bundle: nil), forCellReuseIdentifier: "cell")
        callObsever = NotificationCenter.default.addObserver(self, selector: #selector(recieveCall), name: NSNotification.Name.receiveCall, object: nil)

    }
    
    deinit {
        if let call = callObsever{
                NotificationCenter.default.removeObserver(call)
            }
        }
        
        @objc func recieveCall(_ notification:Notification){
    //        if self.navigationController?.topViewController == nil{
                remoteVC = SelectRemoteViewController.viewController
            if let channel = notification.object as? AgoraRtmChannel{
                remoteVC?.channel = channel
            }
                DispatchQueue.main.async {
                    self.remoteVC?.showViewForParent(self)
                }
                remoteVC?.callDelegate = self
    //        }
        }
        
        func confirmCallTapped() {
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: Notification.Name.startCall, object: nil)
        }
    
    @IBAction func YesOrNoBtnClicked(_ sender: UIButton) {
      
        if sender.currentTitle == "Y"
        {
            yestBtn.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
            noBtn.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
        }
        else if sender.currentTitle == "N"
        {
            yestBtn.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            noBtn.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
        }
        
    }
    
    @IBAction func NextBtnClicked(_ sender: Any) {
       
        let navigation = self.storyboard?.instantiateViewController(withIdentifier: "MiniCogSecondStepViewController") as! MiniCogSecondStepViewController
        
        navigation.FirstStepCompiltionDetails = [TableViewData[SectionNumber]]
    self.navigationController?.pushViewController(navigation, animated: true)
        
    }
    
}
    extension MinicogStep1ViewController : UITableViewDelegate,UITableViewDataSource
    {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           if TableViewData[section].Open == true
           {
               return TableViewData[section].SectionData.count+1
           }
           else
           {
               return 1
           }
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           if indexPath.row == 0
           {
            
              let cell = self.MiniCogWordList.dequeueReusableCell(withIdentifier: "cell") as! MiniCogWordtest
               cell.Nametype.text = TableViewData[indexPath.section].Tittle
             cell.BtnSelcted.isUserInteractionEnabled = false
            
            if TableViewData[indexPath.section].Open == true
            {
                 cell.BtnSelcted.setImage(UIImage(named: "UpArrwo.png"), for: .normal)
            }
            else
            {
                 cell.BtnSelcted.setImage(UIImage(named: "DownArrowNew.png"), for: .normal)
            }
           
            cell.BtnHeight.constant = 15
            cell.BtnWidth.constant = 15
            cell.BtnSelcted.tintColor = UIColor.black
            cell.contentView.layer.borderColor = #colorLiteral(red: 0.3585316837, green: 0.5989317298, blue: 0.7581381202, alpha: 1)

              cell.Nametype.textAlignment = .center
               return cell
           }
           else
           {
            let cell = self.MiniCogWordList.dequeueReusableCell(withIdentifier: "cell") as! MiniCogWordtest
            cell.BtnSelcted.isUserInteractionEnabled = true
            cell.BtnHeight.constant = 30
            cell.BtnWidth.constant = 30
            cell.BtnSelcted.tintColor = #colorLiteral(red: 0.3585316837, green: 0.5989317298, blue: 0.7581381202, alpha: 1)
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.BtnSelcted.setImage(UIImage(named: "ChecBoxFortest.png"), for: .normal)
            cell.Nametype.text = TableViewData[indexPath.section].SectionData[indexPath.row - 1 ]
            cell.BtnSelcted.tag = indexPath.row
            cell.BtnSelcted.addTarget(self, action: #selector(clickOnAudio), for: .touchUpInside)
            cell.Nametype.textAlignment = .left
            return cell
           }
       }
        
        @objc func clickOnAudio(Sender:UIButton)
        {
            let myIndexPath = IndexPath(row: Sender.tag, section: SectionNumber)

            var cell = MiniCogWordList.cellForRow(at: myIndexPath) as! MiniCogWordtest
           
            if cell.BtnSelcted.currentImage == UIImage(named: "ClickedBtn.png")
            {
               cell.BtnSelcted.setImage(UIImage(named: "ChecBoxFortest.png"), for: .normal)
                
                TableViewData[SectionNumber].SavedPoint[Sender.tag-1] = "0"
               
            }
            else
            {
                
          cell.BtnSelcted.setImage(UIImage(named: "ClickedBtn.png"), for: .normal)
                TableViewData[SectionNumber].SavedPoint[Sender.tag-1] = "1"
            }
            NSLog("the Changed Details = \(TableViewData[SectionNumber].SavedPoint)")
        }
        
       func numberOfSections(in tableView: UITableView) -> Int {
           return TableViewData.count
       }
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
         {
           
           if TableViewData[indexPath.section].Open == true
           {
           
            if indexPath.row == 0
            {
            TableViewData[indexPath.section].Open = false
            let section = IndexSet.init(integer: indexPath.section)
            var cell = tableView.cellForRow(at: indexPath) as! MiniCogWordtest
            
            NSLog("Clicked Version is = \(indexPath.row)")
            
            NSLog("Clicked Version is = \(TableViewData[indexPath.section].Tittle)")
            NSLog("Clciekd Sub Version is = \(TableViewData[indexPath.section].SectionData[indexPath.row])")
            
           MiniCogWordList.reloadSections(section, with: .none)
            }
           }
           else
           {
           
            
            NSLog("Clicked Version is = \(indexPath.row)")
                       
            NSLog("Clicked Version is = \(TableViewData[indexPath.section].Tittle)")
            
            NSLog("Clciekd Sub Version is = \(TableViewData[indexPath.section].SectionData[indexPath.row])")
            
            TableViewData[SectionNumber].Open = false
            let Oldsection = IndexSet.init(integer: SectionNumber)
            MiniCogWordList.reloadSections(Oldsection, with: .none)
            
            TableViewData[indexPath.section].Open = true
            let section = IndexSet.init(integer: indexPath.section)
            SectionNumber = indexPath.section
            
            MiniCogWordList.reloadSections(section, with: .none)
           }
        
           }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return TableViewData[indexPath.section].Open && indexPath.row > 0 ? 50 :60
        }
        // Set the spacing between sections
           func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
               return cellSpacingHeight
           }
        // Make the background color show through
           func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
               let headerView = UIView()
               headerView.backgroundColor = UIColor.clear
               return headerView
           }
}
