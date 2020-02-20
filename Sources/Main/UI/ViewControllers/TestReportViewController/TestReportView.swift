//
//  TestReportView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/29/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import FlexLayout

class TestReportView: RootView {
    lazy var grid1: GridView = {
        let grid = GridView(columnCount: 2, rowCount: 4, rowHeigth: 35)
        grid.columnWidths = [350, 100]
        grid.rowHeights[3] = 56
        return grid
    }()

    lazy var grid2: GridView = {
        return GridView(columnCount: 1, rowCount: 2, columnWidth: 450, rowHeigth: 35)
    }()

    lazy var grid4: GridView = {
        let grid = GridView(columnCount: 6, rowCount: 4, columnWidth: 70, rowHeigth: 35)
        grid.columnWidths[0] = 80
        grid.columnWidths[4] = 118
        return grid
    }()

    let audiogram = AudiogramView()
    let notes = UITextView()

    override func layout(flex: Flex) {
        flex.padding(20).direction(.row)
        flex.addItem().direction(.column).width(47%).define { flex in
            flex.addItem(grid1)

            flex.addItem(Styles.labels.h2.apply(text: "QUICK SIN")).margin(32, 12, 16, 0)
            flex.addItem(grid2)

            flex.addItem(Styles.labels.h2.apply(text: "AUDIO KEY")).margin(20, 12, 10, 0)
            let img = UIImageView(image: UIImage(named: "Legend"))
            flex.addItem(img).width(450).aspectRatio(of: img)

            flex.addItem(Styles.labels.h2.apply(text: "NOTES")).margin(20, 12, 10, 0)
            Styles.textView.apply(to: notes)
            flex.addItem(notes).grow(1)
            flex.addItem(Styles.lines.text.hr())
        }
        flex.addItem().direction(.column).width(53%).define { flex in
            flex.addItem(grid4)

            flex.addItem(Styles.labels.h2.apply(text: "AUDIOGRAM")).margin(58, 12, 16, 0)
            flex.addItem(audiogram)
        }
    }

    func bind1(values: Rows<String>) {
        let cells = grid1.cells.bind(values)
        cells.row(0).place(Styles.label(color: .lightBlack).apply ||> textCell)
        cells.range(minY: 1).place(dataCell)
    }

    func bind2(values: Rows<String>) {
        let cells = grid2.cells.bind(values)
        cells.row(0).place(dataCell)
        cells.row(1).place(
            Styles.labels.h5.apply ||> textCell ||> Styles.views.bordered.apply
        )
    }

    func bind4(values: Rows<String>) {
        let cells = grid4.cells.bind(values)
        cells.row(0).range(minX: 1).place(
            Styles.label(color: .lightBlack).apply ||> textCell
        )
        cells.column(0).range(minY: 1).place(
            Styles.label(color: .lightBlack).apply ||> textCell ||> Styles.views.bordered.apply
        )
        cells.range(minX: 1, minY: 1).place(dataCell)
    }

    func dataCell(text: String) -> UIView {
        return text ||> Styles.label(color: .darkGray2).apply ||> textCell ||> Styles.views.bordered.apply
    }

    //
    // TODO: Move below methods into Cells helper
    //

    func textCell(_ label: UILabel) -> UIView {
        return label ||> expand ||> root
    }

    func root(view: UIView) -> UIView {
        let cell = FlexView()
        cell.layout { flex in
            flex.margin(10)
            flex.addItem(view)
        }
        return cell
    }

    func expand(label: UILabel) -> UILabel {
        label.numberOfLines = 0
        label.flex.width(100%).height(100%)
        return label
    }
}
