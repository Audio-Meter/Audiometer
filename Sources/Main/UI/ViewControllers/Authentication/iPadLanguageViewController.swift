//
//  iPadLanguageViewController.swift
//  Audiometer
//
//  Created by Arun Jangid on 27/05/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit
import AgoraRtmKit

class iPadLanguageViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, CallDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var datasource = LanguageCollectionViewDatasource()
    
    var selectedIndexPath:IndexPath = IndexPath(row: 0, section: 0)
    var callObsever:Any?
    var remoteVC:SelectRemoteViewController?
    
    class var viewController:iPadLanguageViewController{
        return UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "iPadLanguageViewController") as! iPadLanguageViewController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = datasource
        collectionView.delegate = self
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        callObsever = NotificationCenter.default.addObserver(self, selector: #selector(recieveCall), name: NSNotification.Name.receiveCall, object: nil)
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prev = selectedIndexPath
        guard prev.row != indexPath.row  else {
            return
        }        
        datasource.selectedIndexpath = indexPath
        self.collectionView.reloadItems(at: [prev, indexPath])
        selectedIndexPath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220, height: 220)
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
            self.dismiss(animated: true, completion: nil)

            NotificationCenter.default.post(name: Notification.Name.startCall, object: nil)
        }
}

