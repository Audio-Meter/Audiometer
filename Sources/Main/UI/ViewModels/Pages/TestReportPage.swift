//
//  TestReportPage.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/29/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

class TestReportPage {
    let audiogram = Audiogram()

    var data1: Rows<String> {
        let values = [10, 20, 30].map { "\($0) db" }.section()
        let rows =  [
            "Unaided Sound Field @ 40 dB (soft speech)",
            "Unaided Sound Field @ 40 dB (average speech)",
            "Model:____________________Aided Sound Field@\n40 db  50 db"
        ].section()
        let columns = ["Test", "PB word list"].sections()
        return columns.append(.rows, rows.append(.sections, values))
    }

    var data2: Rows<String> {
        return [
            "25.5 - Average Total = SNR Loss",
            "SNR Loss:"
        ].section()
    }

    var data4: Rows<String> {
        let values = SectionRows((0..<5).map { _ in
            return (0..<3).map { _ in
                return "0 db"
            }
        })
        let rows =  ["Left", "Right", "Binaural"].section()
        let columns = ["", "SRT", "MCL", "UCL", "PB word list", "dB"].sections()
        return columns.append(.rows, rows.append(.sections, values))
    }
}
