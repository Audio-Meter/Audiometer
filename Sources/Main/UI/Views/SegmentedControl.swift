//
//  SegmentedControl.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/18/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

fileprivate class SegmentCollectionViewCell: UICollectionViewCell {
    lazy var button: UIButton = {
        let res = UIButton()
        res.isUserInteractionEnabled = false
        res.translatesAutoresizingMaskIntoConstraints = false
        res.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        return res
    }()
    
    lazy var selectedLine: UIView = {
        let res = UIView()
        res.isUserInteractionEnabled = false
        res.translatesAutoresizingMaskIntoConstraints = false
        return res
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        button.setBackgroundImage(UIImage(named: "ringSelected"), for: .selected)
        self.addSubview(button)
        self.addSubview(selectedLine)
        let views = ["button" : button, "selectedLine" : selectedLine]
    
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[button][selectedLine(==5)]|", options: [], metrics:  nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[button]|", options: [], metrics:  nil, views: views))
        self.addConstraint(NSLayoutConstraint(item: selectedLine, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: selectedLine, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))
    }
}

struct SegmentItem {
    let title: String
    let image: UIImage
    let selectedBottomLineColor: UIColor
    let selectedContentColor: UIColor
    let unselectedContentColor: UIColor
    
    init(title: String, image: UIImage, selectedBottomLineColor: UIColor = ColorStyle.red.color, selectedContentColor: UIColor = ColorStyle.lightBlack.color, unselectedContentColor: UIColor = ColorStyle.red.color) {
        self.title = title
        self.image = image
        self.selectedBottomLineColor = selectedBottomLineColor
        self.selectedContentColor = selectedContentColor
        self.unselectedContentColor = unselectedContentColor
    }
}

typealias SegmentedControlDidSectionItemHandler = (_ index: Int) -> Void

class SegmentedControl: UIView {
    private var items: [SegmentItem] = []
    private var lockedItems: IndexSet? {
        didSet {
            collectionView.reloadData()
        }
    }
    public var didSelectSectionHandler: SegmentedControlDidSectionItemHandler?
    var selectedIndex: Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var numberOfVisibleItems: Int = 3 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let res = UICollectionView(frame: .zero, collectionViewLayout: layout)
        res.delegate = self
        res.dataSource = self
        res.backgroundColor = .clear
        res.register(SegmentCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return res
    }()
    
    func lockItems(indexSet: IndexSet) {
        lockedItems = indexSet
    }
    
    func unlockAllItems() {
        lockedItems = nil
    }
    
    func setItems(items: [SegmentItem]) {
        self.items = items
        collectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
}

extension SegmentedControl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / CGFloat(numberOfVisibleItems)
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SegmentedControl: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        didSelectSectionHandler?(indexPath.row)
    }
}

extension SegmentedControl: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let segmentItem = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SegmentCollectionViewCell
        
        cell.isUserInteractionEnabled = true
        cell.alpha = 1
        cell.button.titleLabel?.font = FontStyle.normal.bold().apply()
        cell.button.tintColor = segmentItem.unselectedContentColor
        cell.button.setTitleColor(segmentItem.unselectedContentColor, for: .normal)
        cell.selectedLine.backgroundColor = .clear
        if indexPath.row == selectedIndex {
            cell.selectedLine.backgroundColor = segmentItem.selectedBottomLineColor
            cell.button.tintColor = segmentItem.selectedContentColor
            cell.button.setTitleColor(segmentItem.selectedContentColor, for: .normal)
        }
        cell.button.setTitle(segmentItem.title, for: .normal)
        cell.button.setImage(segmentItem.image, for: .normal)
        
        if lockedItems?.contains(indexPath.row) == true {
            cell.isUserInteractionEnabled = false
            cell.alpha = 0.5
        }
        return cell
    }
}
