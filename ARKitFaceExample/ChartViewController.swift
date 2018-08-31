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
        dataSet.colors = [UIColor.red]
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
            dataSet.colors = [randomColor]
            data.addDataSet(dataSet)
        }
        chartView.data = data
        view = chartView
    }
    
    var randomColor: UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
