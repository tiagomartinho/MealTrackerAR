import SceneKit
import ARKit

class VirtualContentUpdater: NSObject, ARSCNViewDelegate {
    
    var virtualFaceNode: RobotHead? {
        didSet {
            setupFaceNodeContent()
        }
    }

    private var faceNode: SCNNode?
    
    private let serialQueue = DispatchQueue(label: "com.example.apple-samplecode.ARKitFaceExample.serialSceneKitQueue")
    
    /// - Tag: FaceContentSetup
    private func setupFaceNodeContent() {
        guard let node = faceNode else { return }
    
        for child in node.childNodes {
            child.removeFromParentNode()
        }
        
        if let content = virtualFaceNode {
            node.addChildNode(content)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        faceNode = node
        serialQueue.async {
            self.setupFaceNodeContent()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        virtualFaceNode?.update(withFaceAnchor: faceAnchor)
    }
}
