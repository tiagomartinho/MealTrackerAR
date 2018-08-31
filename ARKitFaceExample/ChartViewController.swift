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
        let dataSet = LineChartDataSet(values: lineChartEntry, label: nil)
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
        data.addDataSet(dataSet)
        
        let shapes = blendShapes.reduce([:]) { (result, blendShape) -> [ARFaceAnchor.BlendShapeLocation: [NSNumber]] in
            var shapes = result
            for (key, value) in blendShape {
                if let values = shapes[key] {
                    shapes[key] = values + [value]
                } else {
                    shapes[key] = [value]
                }
            }
            return shapes
        }
        
        let entries: [[ChartDataEntry]] = shapes.compactMap {
            var chartEntry = [ChartDataEntry]()
            for (index, value) in $0.1.enumerated() {
                chartEntry.append(ChartDataEntry(x: Double(index), y: Double(truncating: value)))
            }
            return chartEntry
        }
        for valueChartEntry in entries {
            let dataSet = LineChartDataSet(values: valueChartEntry, label: nil)
            dataSet.drawCircleHoleEnabled = false
            dataSet.drawCirclesEnabled = false
            data.addDataSet(dataSet)
        }
        chartView.data = data
        view = chartView
    }
}
