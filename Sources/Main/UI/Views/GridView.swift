//
//  GridView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/29/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import FlexLayout

class GridView: UIView {
    let columnCount: Int
    let rowCount: Int

    var columnWidths: [CGFloat]
    var rowHeights: [CGFloat]

    init(columnCount: Int, rowCount: Int, columnWidth: CGFloat = 0, rowHeigth: CGFloat = 0) {
        self.columnCount = columnCount
        self.rowCount = rowCount
        self.columnWidths = Array(repeating: columnWidth, count: columnCount)
        self.rowHeights = Array(repeating: rowHeigth, count: rowCount)

        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: columnWidths.sum(), height: rowHeights.sum())
    }

    var cells: GridRange {
        return GridRange(view: self, minX: 0, minY: 0, maxX: columnCount, maxY: rowCount)
    }

    func place(x: Int, y: Int, view: UIView) {
        let inset = -view.layer.borderWidth / 2
        view.frame = self.frames[x][y].insetBy(dx: inset, dy: inset)
        addSubview(view)
    }

    lazy var frames: [[CGRect]] = {
        var x: CGFloat = 0
        return columnWidths.map { width in
            var y:CGFloat = 0
            let column = rowHeights.map { height->CGRect in
                let frame = CGRect(x: x, y: y, width: width, height: height)
                y += height
                return frame
            }
            x += width
            return column
        }
    }()
}

struct GridRange {
    let view: GridView

    var minX: Int
    var minY: Int

    var maxX: Int
    var maxY: Int

    func range(minX: Int = 0, minY: Int = 0, maxX: Int = 0, maxY: Int = 0) -> GridRange {
        var range = self
        range.minX += minX
        range.minY += minY
        range.maxX += maxX
        range.maxY += maxY
        return range
    }

    func row(_ index: Int) -> GridRange {
        var range = self
        range.minY = index
        range.maxY = index + 1
        return range
    }

    func column(_ index: Int) -> GridRange {
        var range = self
        range.minX = index
        range.maxX = index + 1
        return range
    }

    func bind<T>(_ rows: Rows<T>) -> GridRangeRows<T> {
        return GridRangeRows(range: self, rows: rows, offsetX: minX, offsetY: minY)
    }
}

struct GridRangeRows<Value> {
    var range: GridRange
    var rows: Rows<Value>

    let offsetX: Int
    let offsetY: Int

    func range(minX: Int = 0, minY: Int = 0, maxX: Int = 0, maxY: Int = 0) -> GridRangeRows<Value> {
        var rows = self
        rows.range = range.range(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
        return rows
    }

    func row(_ index: Int) -> GridRangeRows<Value> {
        var rows = self
        rows.range = range.row(index)
        return rows
    }

    func column(_ index: Int) -> GridRangeRows<Value> {
        var rows = self
        rows.range = range.column(index)
        return rows
    }

    func place<T:UIView>(_ transform: @escaping (Value)->T) {
        map(transform).place()
    }

    func map<T>(_ transform: @escaping (Value)->T) -> GridRangeRows<T> {
        let rows: Rows<T> = self.rows.map(transform: transform)
        return GridRangeRows<T>(range: range, rows: rows, offsetX: offsetX, offsetY: offsetY)
    }
}

extension GridRangeRows where Value: UIView {
    func place() {
        for x in range.minX..<range.maxX {
            for y in range.minY..<range.maxY {
                let path = IndexPath(row: y - offsetY, section: x - offsetX)
                let view = rows.item(at: path)
                range.view.place(x: x, y: y, view: view)
            }
        }
    }
}
