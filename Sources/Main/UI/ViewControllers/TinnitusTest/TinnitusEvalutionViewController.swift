//
//  TinnitusEvalutionViewController.swift
//  Audiometer
//
//  Created by Dogra Tech on 03/03/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit
import Charts
import AgoraRtmKit

class TinnitusEvalutionViewController: UIViewController, CallDelegate {

    @IBOutlet weak var EvaluationChart: BarChartView!
    var callObsever:Any?
    var remoteVC:SelectRemoteViewController?
    let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira","Auba", "Xhaka", "Torreira","test"]
    let goals = [10,20,30,40,50,60,70,80,90,100]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        EvaluationChart.animate(yAxisDuration: 1.0)
        EvaluationChart.pinchZoomEnabled = false
        EvaluationChart.drawBarShadowEnabled = false
        EvaluationChart.drawBordersEnabled = false
        EvaluationChart.doubleTapToZoomEnabled = false
        EvaluationChart.drawGridBackgroundEnabled = true
        
        EvaluationChart.chartDescription?.text = "Bar Chart View"
        
         setChart(dataPoints: players, values: goals.map { Double($0) })
       
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
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: Notification.Name.startCall, object: nil)
            }
    
    @IBAction func SaveBtnClicked(_ sender: Any) {
        
        var Nav = self.storyboard?.instantiateViewController(withIdentifier: "TinnitusEvalutionProgramViewController") as! TinnitusEvalutionProgramViewController
    self.navigationController?.pushViewController(Nav, animated: true)
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
         EvaluationChart.noDataText = "You need to provide data for the chart."
             
             EvaluationChart.chartDescription?.text = "" //hiding description label - This is optional - and It is required for swift4 and belows lower verions

             var dataEntries: [BarChartDataEntry] = []
             
             for i in 0..<dataPoints.count {
                 let dataEntry = BarChartDataEntry(x: Double(i), y: values[i]) // // here we set the X and Y status in a data chart entry
                 dataEntries.append(dataEntry) // // here we add it to the data set
             }

             
             
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")
             
            //  chartDataSet.valueTextColor = UIColor.blue //change color of vlaues - defult is black
             
             //changin color of bars - default color is blue/sky-blue
              // chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
             
         
             
            let chartData = BarChartData(dataSet: chartDataSet)
             EvaluationChart.data = chartData //finally - it adds the chart data to the chart and causes an update
             
             //MARK: Bar chart customization
             EvaluationChart.xAxis.enabled = true //show x axis
             EvaluationChart.leftAxis.enabled = true //show/hide left axix (Y axis)
             EvaluationChart.rightAxis.enabled = false //show/hide right axis (Y axis)
             EvaluationChart.animate(xAxisDuration: 1.5) //show animation
             EvaluationChart.drawGridBackgroundEnabled = true //show or hide background color
             //set in storyboard = #F3F4F8 or UIColor(red: 0.243, green: 0.244, blue: 0.248, alpha: 1)
             
             EvaluationChart.xAxis.drawGridLinesEnabled = true //it will show/hide grid background (Verticles lines - Y - form x axix)
             EvaluationChart.xAxis.drawAxisLineEnabled = true //show x axis line
             EvaluationChart.xAxis.labelPosition = .bottom // values/labels of x axis - position
             EvaluationChart.xAxis.drawLabelsEnabled = true //show/hide values/labels in x axis
             
             //right and left axis - optional/not required
             // chartViewOutlet.leftAxis.drawAxisLineEnabled = true //show lines of left x axis
             EvaluationChart.leftAxis.drawGridLinesEnabled = true //hide/show x axis grid lines - horizontal lines ( X axis - from Y)
             //  chartViewOutlet.rightAxis.drawAxisLineEnabled = false
             // chartViewOutlet.rightAxis.drawGridLinesEnabled = false
             
             EvaluationChart.legend.enabled = true //show/hide legend - below graph
         
             //MARL:show animation
             EvaluationChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
             
             
             //MARK: Set limits
             /*
               //for more details info about limits please check examples of line-charts
             */
             //limits - set limit on left x axis
            /* let ll = ChartLimitLine(limit: 10.0, label: "Target")
             //barChartViewOutlet.leftAxis.addLimitLine(ll)  //this is dealult line show
             //to customize limit line - write below code
             ll.lineWidth = 1.5
             ll.lineColor = UIColor.red
             ll.lineDashLengths = [4, 4]
             ll.labelPosition = .topRight
             ll.valueFont = .systemFont(ofSize: 10)
             EvaluationChart.leftAxis.addLimitLine(ll)*/
             
           //  Optional stuff
             EvaluationChart.xAxis.gridLineDashLengths = [4, 4] // verticle line - dash lines
             EvaluationChart.xAxis.gridLineDashPhase = 0
             
             EvaluationChart.leftAxis.gridLineDashLengths = [4, 4] //horizontal lines - y
     }
}
@IBDesignable
class CustomSlider: UISlider {

@IBInspectable var trackHeight: CGFloat = 6

override func trackRect(forBounds bounds: CGRect) -> CGRect {
    var rect = super.trackRect(forBounds: bounds)
    rect.size.height = trackHeight
    rect.origin.y -= trackHeight / 2
    return rect
  }
}
