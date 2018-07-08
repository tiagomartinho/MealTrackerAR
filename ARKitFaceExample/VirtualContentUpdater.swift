import SceneKit
import ARKit

class VirtualContentUpdater: NSObject, ARSCNViewDelegate {
    
    let jawOpenBuffer = RunningBuffer(size: 50)
    let mouthClosedBuffer = RunningBuffer(size: 50)
    
    private let serialQueue = DispatchQueue(label: "com.example.apple-samplecode.ARKitFaceExample.serialSceneKitQueue")
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
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
