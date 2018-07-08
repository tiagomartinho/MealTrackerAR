import Foundation
import SceneKit
import ARKit

class RobotHead: SCNNode {

    let jawOpenBuffer = RunningBuffer(size: 50)
    let mouthClosedBuffer = RunningBuffer(size: 50)
    
    /// - Tag: ARFaceGeometryBlendShapes
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
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
