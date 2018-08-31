import UIKit
import Charts
import ARKit

class ChartViewController: UIViewController {
    
    var blendShapes: [[ARFaceAnchor.BlendShapeLocation: NSNumber]] = []
    var movements = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let chartView = LineChartView()
        let data = LineChartData()

        var lineChartEntry = [ChartDataEntry]()
        for (index, value) in movements.enumerated() {
            lineChartEntry.append(ChartDataEntry(x: Double(index), y: Double(value)))
        }
        let dataSet = LineChartDataSet(values: lineChartEntry, label: "movements")
        data.addDataSet(dataSet)
        
        var otherlineChartEntry = [ChartDataEntry]()
        for (index, blendShape) in blendShapes.enumerated() {
            if let value = blendShape[.jawOpen] {
                otherlineChartEntry.append(ChartDataEntry(x: Double(index), y: Double(truncating: value)))
            }
        }
        data.addDataSet(LineChartDataSet(values: otherlineChartEntry, label: "jawOpen"))
        
        chartView.data = data
        view = chartView
    }
}
