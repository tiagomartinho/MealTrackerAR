import UIKit
import ARKit
import CoreML

class LegacyModelViewController: UIViewController {
    
    var sceneView: ARSCNView!
    var session: ARSession { return sceneView.session }
    
    let model = bites()
    
    var movementLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        sceneView = ARSCNView()
        view.addSubview(sceneView)
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        movementLabel = UILabel()
        view.addSubview(movementLabel)
        movementLabel.translatesAutoresizingMaskIntoConstraints = false
        movementLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        movementLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }
    
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension LegacyModelViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        resetTracking()
    }
}


extension LegacyModelViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        guard let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float, let mouthLowerDown_R = faceAnchor.blendShapes[.mouthLowerDownRight] as? Float, let mouthLowerDown_L = faceAnchor.blendShapes[.mouthLowerDownLeft] as? Float, let mouthStretch_R = faceAnchor.blendShapes[.mouthStretchRight] as? Float, let mouthStretch_L = faceAnchor.blendShapes[.mouthStretchLeft] as? Float, let mouthPucker = faceAnchor.blendShapes[.mouthPucker] as? Float, let mouthFrown_R = faceAnchor.blendShapes[.mouthFrownRight] as? Float, let mouthFrown_L = faceAnchor.blendShapes[.mouthFrownLeft] as? Float, let mouthClose = faceAnchor.blendShapes[.mouthClose] as? Float, let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as? Float, let mouthUpperUp_L = faceAnchor.blendShapes[.mouthUpperUpLeft] as? Float, let mouthUpperUp_R = faceAnchor.blendShapes[.mouthUpperUpRight] as? Float, let jawForward = faceAnchor.blendShapes[.jawForward] as? Float, let mouthShrugLower = faceAnchor.blendShapes[.mouthShrugLower] as? Float, let mouthShrugUpper = faceAnchor.blendShapes[.mouthShrugUpper] as? Float, let jawRight = faceAnchor.blendShapes[.jawRight] as? Float, let jawLeft = faceAnchor.blendShapes[.jawLeft] as? Float, let mouthDimple_L = faceAnchor.blendShapes[.mouthDimpleLeft] as? Float, let mouthDimple_R = faceAnchor.blendShapes[.mouthDimpleRight] as? Float, let mouthRollLower = faceAnchor.blendShapes[.mouthRollLower] as? Float, let mouthRollUpper = faceAnchor.blendShapes[.mouthRollUpper] as? Float, let mouthLeft = faceAnchor.blendShapes[.mouthLeft] as? Float, let mouthRight = faceAnchor.blendShapes[.mouthRight] as? Float, let mouthSmile_L = faceAnchor.blendShapes[.mouthSmileLeft] as? Float, let mouthSmile_R = faceAnchor.blendShapes[.mouthSmileRight] as? Float, let mouthPress_L = faceAnchor.blendShapes[.mouthPressLeft] as? Float, let mouthPress_R = faceAnchor.blendShapes[.mouthPressRight] as? Float else {
            return
        }
        
        let input = bitesInput(jawOpen: Double(jawOpen), mouthLowerDown_R: Double(mouthLowerDown_R), mouthLowerDown_L: Double(mouthLowerDown_L), mouthStretch_R: Double(mouthStretch_R), mouthStretch_L: Double(mouthStretch_L), mouthPucker: Double(mouthPucker), mouthFrown_R: Double(mouthFrown_R), mouthFrown_L: Double(mouthFrown_L), mouthClose: Double(mouthClose), mouthFunnel: Double(mouthFunnel), mouthUpperUp_L: Double(mouthUpperUp_L), mouthUpperUp_R: Double(mouthUpperUp_R), jawForward: Double(jawForward), mouthShrugLower: Double(mouthShrugLower), mouthShrugUpper: Double(mouthShrugUpper), jawRight: Double(jawRight), jawLeft: Double(jawLeft), mouthDimple_L: Double(mouthDimple_L), mouthDimple_R: Double(mouthDimple_R), mouthRollLower: Double(mouthRollLower), mouthRollUpper: Double(mouthRollUpper), mouthLeft: Double(mouthLeft), mouthRight: Double(mouthRight), mouthSmile_L: Double(mouthSmile_L), mouthSmile_R: Double(mouthSmile_R), mouthPress_L: Double(mouthPress_L), mouthPress_R: Double(mouthPress_R))
        guard let output = try? model.prediction(input: input) else {
            return
        }
        
        DispatchQueue.main.async {
            self.movementLabel.text = "\(output.movement)"
            print("\(output.movement)")
        }
    }
}
