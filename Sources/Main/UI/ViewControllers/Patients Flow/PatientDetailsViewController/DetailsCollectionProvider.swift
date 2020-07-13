//
//  PatientInfoCollectionViewProvider.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/17/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import ActionSheetPicker_3_0

class DetailsCollectionProvider: NSObject {
    private var collectionView: UICollectionView
    private var items: [DetailItemCellProtocol] = []
    
    init(collectionView: UICollectionView, info: DetailsItemsCellsProtocol) {
        self.collectionView = collectionView
        collectionView.register(TextFieldCollectionViewCell.nib, forCellWithReuseIdentifier: TextFieldCollectionViewCell.reuseIdentifier)
        collectionView.register(SegmentedCollectionViewCell.nib, forCellWithReuseIdentifier: SegmentedCollectionViewCell.reuseIdentifier)
        collectionView.register(DatePickerCollectionViewCell.nib, forCellWithReuseIdentifier: DatePickerCollectionViewCell.reuseIdentifier)
        super.init()
        
        items = info.items()

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension DetailsCollectionProvider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionItem = items[indexPath.row]
        
        if let collectionItem = collectionItem as? DetailsCellStringItem {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCollectionViewCell.reuseIdentifier, for: indexPath) as? TextFieldCollectionViewCell {
                cell.textField.font = FontStyle.normal.apply()
                cell.textField.placeholder = collectionItem.description
                cell.textField.text = collectionItem.variable.value
                cell.textField.rx.text.subscribe(onNext: { text in
                    collectionItem.variable.value = text ?? ""
                }).disposed(by: cell.disposeBag)
                
                collectionItem.variable.asObservable().subscribe(onNext: { [weak cell] text in
                    switch collectionItem.format {
                    case .hyphen(let format):
                        cell?.textField.text = text.formattedNumber(mask: format)
                    default:
                        cell?.textField.text = text
                    }
                }).disposed(by: cell.disposeBag)
                
                switch collectionItem.format {
                case .none:
                    cell.textField.autocapitalizationType = .sentences
                case .wordCap:
                    cell.textField.autocapitalizationType = .words
                case .allCap:
                    cell.textField.autocapitalizationType = .allCharacters
                case .hyphen(_):
                    cell.textField.autocapitalizationType = .allCharacters
                }
                
                return cell
            }
        }
        else if collectionItem is DetailsCellSegmentedItem {
            let patientPageItem = collectionItem as! DetailsCellSegmentedItem
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentedCollectionViewCell.reuseIdentifier, for: indexPath) as? SegmentedCollectionViewCell {
                cell.titleLabel.font = FontStyle.normal.apply()
                cell.titleLabel.text = patientPageItem.description
                cell.segmentedControl.removeAllSegments()
                let titlesCount = patientPageItem.segmentTitles.count
                for index in 0...titlesCount - 1 {
                    let title = patientPageItem.segmentTitles[index]
                    cell.segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
                }
                cell.segmentedControl.selectedSegmentIndex = (patientPageItem.selectedIndex.value == .m ? 0 : 1)
                cell.segmentedControl.rx.selectedSegmentIndex.subscribe(onNext: { index in
                    patientPageItem.selectedIndex.value = (index == 0 ? .m : .f)
                }).disposed(by: cell.disposeBag)
                
                patientPageItem.selectedIndex.asObservable().subscribe(onNext: { [weak cell] value in
                    cell?.segmentedControl.selectedSegmentIndex = (value == .m ? 0 : 1)
                }).disposed(by: cell.disposeBag)
                cell.segmentedControl.layer.cornerRadius = 15
                cell.segmentedControl.layer.borderWidth = 1
                cell.segmentedControl.clipsToBounds = true
                
                cell.segmentedControl.removeBorders()
                return cell
            }
        }
        else if collectionItem is DetailsCellDateItem {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerCollectionViewCell.reuseIdentifier, for: indexPath) as? DatePickerCollectionViewCell {
                cell.textField.font = FontStyle.normal.apply()
                cell.textField.placeholder = collectionItem.description
                cell.textField.text = collectionItem.valueDescription
                
                let datePageItem = collectionItem as! DetailsCellDateItem
                cell.didSelectDateHandler = { selectedDate in
                    datePageItem.variable.value = selectedDate
                }
                datePageItem.variable.asObservable().subscribe(onNext: { [weak cell] date in
                    cell?.textField.text = collectionItem.valueDescription
                }).disposed(by: cell.disposeBag)

               return cell
            }
        }
        
        return UICollectionViewCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

private let indent: CGFloat = 15.0

extension DetailsCollectionProvider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - indent * 3) / 2
        return CGSize(width: width, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: indent, bottom: 0, right: indent)
    }
}
