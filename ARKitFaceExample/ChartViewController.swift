import UIKit
import Charts
import ARKit

class ChartViewController: UIViewController {
    
    var blendShapes: [[ARFaceAnchor.BlendShapeLocation: NSNumber]] = []
    var movements = [Int]()
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func export() {
        var csvText = ""
        let fileName = "Payloads-\(Date()).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)!
        csvText.append("jawOpen,mouthLowerDown_R,mouthLowerDown_L,mouthStretch_R,mouthStretch_L,mouthPucker,mouthFrown_R,mouthFrown_L,mouthClose,mouthFunnel,mouthUpperUp_L,mouthUpperUp_R,jawForward,mouthShrugLower,mouthShrugUpper,jawRight,jawLeft,mouthDimple_L,mouthDimple_R,mouthRollLower,mouthRollUpper,mouthLeft,mouthRight,mouthSmile_L,mouthSmile_R,mouthPress_L,mouthPress_R,movement\n")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.roundingMode = .up
        for (index, blendShape) in blendShapes.enumerated() {
            let shapes = ["jawOpen","mouthLowerDown_R","mouthLowerDown_L","mouthStretch_R","mouthStretch_L","mouthPucker","mouthFrown_R","mouthFrown_L","mouthClose","mouthFunnel","mouthUpperUp_L","mouthUpperUp_R","jawForward","mouthShrugLower","mouthShrugUpper","jawRight","jawLeft","mouthDimple_L","mouthDimple_R","mouthRollLower","mouthRollUpper","mouthLeft","mouthRight","mouthSmile_L","mouthSmile_R","mouthPress_L","mouthPress_R"]
            let mouthJawShapes: [ARFaceAnchor.BlendShapeLocation] = shapes.map {
                ARFaceAnchor.BlendShapeLocation(rawValue: $0)
            }
            
            for shape in mouthJawShapes {
                let value = 10000 * Double(truncating: blendShape[shape]!)
                let rounded = Double(Int(value)) / 10000
                csvText.append("\(rounded),")
            }
            csvText.append("\(movements[index])\n")
        }
        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("\(error)")
        }
        let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    func addNavigationButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(export))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationButtons()
        
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
        
        var shapes = blendShapes.reduce([:]) { (result, blendShape) -> [ARFaceAnchor.BlendShapeLocation: [NSNumber]] in
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
        
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthShrugLower")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthShrugUpper")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "jawRight")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "jawLeft")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthDimple_L")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthDimple_R")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthRollLower")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthRollUpper")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthLeft")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthRight")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthSmile_L")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthSmile_R")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthPress_L")] = nil
        shapes[ARFaceAnchor.BlendShapeLocation(rawValue: "mouthPress_R")] = nil
        
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
