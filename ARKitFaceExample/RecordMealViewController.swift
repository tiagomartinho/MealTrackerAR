import UIKit
import ARKit

class RecordMealViewController: UIViewController {
    
    var sceneView: ARSCNView!
    var session: ARSession { return sceneView.session }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView()
        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
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

extension RecordMealViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.resetTracking()
        }
    }
}


extension RecordMealViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        guard let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float else { return }
        print("\(jawOpen)")
    }
}
