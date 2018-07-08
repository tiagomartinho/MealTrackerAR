import Foundation
import SceneKit
import ARKit

class RobotHead: SCNReferenceNode, VirtualFaceContent {

    let jawOpenBuffer = RunningBuffer(size: 50)
    let mouthClosedBuffer = RunningBuffer(size: 50)

    private var originalJawY: Float = 0

    private lazy var jawNode = childNode(withName: "jaw", recursively: true)!
    private lazy var eyeLeftNode = childNode(withName: "eyeLeft", recursively: true)!
    private lazy var eyeRightNode = childNode(withName: "eyeRight", recursively: true)!

    private lazy var jawHeight: Float = {
        let (min, max) = jawNode.boundingBox
        return max.y - min.y
    }()
    
    init() {
        guard let url = Bundle.main.url(forResource: "robotHead", withExtension: "scn", subdirectory: "Models.scnassets")
            else { fatalError("missing expected bundle resource") }
        super.init(url: url)!
        self.load()
        originalJawY = jawNode.position.y
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    /// - Tag: BlendShapeAnimation
    var blendShapes: [ARFaceAnchor.BlendShapeLocation: Any] = [:] {
        didSet {
            guard let eyeBlinkLeft = blendShapes[.eyeBlinkLeft] as? Float,
                let eyeBlinkRight = blendShapes[.eyeBlinkRight] as? Float,
                let jawOpen = blendShapes[.jawOpen] as? Float,
                let mouthClose = blendShapes[.mouthClose] as? Float
                else { return }
            eyeLeftNode.scale.z = 1 - eyeBlinkLeft
            eyeRightNode.scale.z = 1 - eyeBlinkRight
            jawNode.position.y = originalJawY - jawHeight * (jawOpen + (1 - mouthClose))
        }
    }
    
    /// - Tag: ARFaceGeometryBlendShapes
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
        blendShapes = faceAnchor.blendShapes
        guard let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float,
        let mouthClose = faceAnchor.blendShapes[.mouthClose] as? Float
        else { return }
        jawOpenBuffer.addSample(Double(jawOpen))
        mouthClosedBuffer.addSample(Double(mouthClose))
        if jawOpenBuffer.isFull() && mouthClosedBuffer.isFull() {
            let jaw = jawOpenBuffer.recentMean()
            let mouth = mouthClosedBuffer.recentMean()
            print("\(jaw),\(mouth)")
        }
    }
}

import Foundation

class RunningBuffer {
    
    var size = 0
    var buffer = [Double]()
    
    init(size: Int) {
        self.size = size
        buffer = [Double](repeating: 0.0, count: self.size)
    }
    
    func addSample(_ sample: Double) {
        buffer.insert(sample, at: 0)
        if buffer.count > size {
            buffer.removeLast()
        }
    }
    
    func reset() {
        buffer.removeAll(keepingCapacity: true)
    }
    
    func isFull() -> Bool {
        return size == buffer.count
    }
    
    func sum() -> Double {
        return buffer.reduce(0.0, +)
    }
    
    func min() -> Double {
        var min = 0.0
        if let bufMin = buffer.min() {
            min = bufMin
        }
        return min
    }
    
    func max() -> Double {
        var max = 0.0
        if let bufMax = buffer.max() {
            max = bufMax
        }
        return max
    }
    
    func recentMean() -> Double {
        let recentCount = size / 2
        var mean = 0.0
        
        if buffer.count >= recentCount {
            let recentBuffer = buffer[0 ..< recentCount]
            mean = recentBuffer.reduce(0.0, +) / Double(recentBuffer.count)
        }
        
        return mean
    }
}

