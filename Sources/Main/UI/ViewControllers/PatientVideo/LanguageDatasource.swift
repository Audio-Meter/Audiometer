//
//  LanguageDatasource.swift
//  Audiometer
//
//  Created by Arun Jangid on 29/04/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit

enum LanguageSelect{
    case english
    case italiano
    
    var data:(icon:UIImage?, text:String){
        switch self {
        case .english: return (UIImage(named: "English"),"English")
        case .italiano: return (UIImage(named: "italian"),"Italiano")
        }
    }
    
    static let allItems:[LanguageSelect] = [.english, .italiano]
}

class LanguageDatasource:NSObject, UITableViewDataSource{
    
    var rowType = LanguageSelect.allItems
    var selectedIndexpath = IndexPath(row: 0, section: 0)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as! LanguageTableViewCell
        let row = rowType[indexPath.row]
        if indexPath == selectedIndexpath{
            cell.isSelected = true
        }else{
            cell.isSelected = false
        }
        cell.configure(row)
        
        return cell
    }
    
    
}

class LanguageCollectionViewDatasource:NSObject,UICollectionViewDataSource{
    var rowType = LanguageSelect.allItems
    var selectedIndexpath = IndexPath(row: 0, section: 0)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LanguageCollectionViewCell", for: indexPath) as! LanguageCollectionViewCell
        let row = rowType[indexPath.row]
        if indexPath == selectedIndexpath{
            cell.isSelected = true
        }else{
            cell.isSelected = false
        }
        cell.configure(row)
        return cell
    }
    
    
    
    
}
