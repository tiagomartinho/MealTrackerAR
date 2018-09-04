import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var bitesCountLabel: UILabel!
    @IBOutlet weak var chewCountLabel: UILabel!

    let model = bites()
    var state = State.idle
    var inBite = false
    
    var chewCount = 0 {
        didSet {
            DispatchQueue.main.async {
                self.chewCountLabel.text = "\(self.chewCount)"
            }
        }
    }

    var bitesCount = 0 {
        didSet {
            DispatchQueue.main.async {
                self.bitesCountLabel.text = "\(self.bitesCount)"
            }
        }
    }

    lazy var statusViewController: StatusViewController = {
        return childViewControllers.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()

    var session: ARSession { return sceneView.session }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
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

    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }

    func sessionWasInterrupted(_ session: ARSession) {
        statusViewController.showMessage("""
        SESSION INTERRUPTED
        The session will be reset after the interruption has ended.
        """, autoHide: false)
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.resetTracking()
        }
    }

    func resetTracking() {
        statusViewController.showMessage("STARTING A NEW SESSION")
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    func restartExperience() {
        statusViewController.isRestartExperienceButtonEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.statusViewController.isRestartExperienceButtonEnabled = true
        }
        resetTracking()
    }

    func displayErrorMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        guard let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float, let mouthLowerDown_R = faceAnchor.blendShapes[.mouthLowerDownRight] as? Float, let mouthLowerDown_L = faceAnchor.blendShapes[.mouthLowerDownLeft] as? Float, let mouthStretch_R = faceAnchor.blendShapes[.mouthStretchRight] as? Float, let mouthStretch_L = faceAnchor.blendShapes[.mouthStretchLeft] as? Float, let mouthPucker = faceAnchor.blendShapes[.mouthPucker] as? Float, let mouthFrown_R = faceAnchor.blendShapes[.mouthFrownRight] as? Float, let mouthFrown_L = faceAnchor.blendShapes[.mouthFrownLeft] as? Float, let mouthClose = faceAnchor.blendShapes[.mouthClose] as? Float, let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as? Float, let mouthUpperUp_L = faceAnchor.blendShapes[.mouthUpperUpLeft] as? Float, let mouthUpperUp_R = faceAnchor.blendShapes[.mouthUpperUpRight] as? Float, let jawForward = faceAnchor.blendShapes[.jawForward] as? Float, let mouthShrugLower = faceAnchor.blendShapes[.mouthShrugLower] as? Float, let mouthShrugUpper = faceAnchor.blendShapes[.mouthShrugUpper] as? Float, let jawRight = faceAnchor.blendShapes[.jawRight] as? Float, let jawLeft = faceAnchor.blendShapes[.jawLeft] as? Float, let mouthDimple_L = faceAnchor.blendShapes[.mouthDimpleLeft] as? Float, let mouthDimple_R = faceAnchor.blendShapes[.mouthDimpleRight] as? Float, let mouthRollLower = faceAnchor.blendShapes[.mouthRollLower] as? Float, let mouthRollUpper = faceAnchor.blendShapes[.mouthRollUpper] as? Float, let mouthLeft = faceAnchor.blendShapes[.mouthLeft] as? Float, let mouthRight = faceAnchor.blendShapes[.mouthRight] as? Float, let mouthSmile_L = faceAnchor.blendShapes[.mouthSmileLeft] as? Float, let mouthSmile_R = faceAnchor.blendShapes[.mouthSmileRight] as? Float, let mouthPress_L = faceAnchor.blendShapes[.mouthPressLeft] as? Float, let mouthPress_R = faceAnchor.blendShapes[.mouthPressRight] as? Float else {
            return
        }
        
        let input = bitesInput(jawOpen: Double(jawOpen), mouthLowerDown_R: Double(mouthLowerDown_R), mouthLowerDown_L: Double(mouthLowerDown_L), mouthStretch_R: Double(mouthStretch_R), mouthStretch_L: Double(mouthStretch_L), mouthPucker: Double(mouthPucker), mouthFrown_R: Double(mouthFrown_R), mouthFrown_L: Double(mouthFrown_L), mouthClose: Double(mouthClose), mouthFunnel: Double(mouthFunnel), mouthUpperUp_L: Double(mouthUpperUp_L), mouthUpperUp_R: Double(mouthUpperUp_R), jawForward: Double(jawForward), mouthShrugLower: Double(mouthShrugLower), mouthShrugUpper: Double(mouthShrugUpper), jawRight: Double(jawRight), jawLeft: Double(jawLeft), mouthDimple_L: Double(mouthDimple_L), mouthDimple_R: Double(mouthDimple_R), mouthRollLower: Double(mouthRollLower), mouthRollUpper: Double(mouthRollUpper), mouthLeft: Double(mouthLeft), mouthRight: Double(mouthRight), mouthSmile_L: Double(mouthSmile_L), mouthSmile_R: Double(mouthSmile_R), mouthPress_L: Double(mouthPress_L), mouthPress_R: Double(mouthPress_R))
        guard let output = try? model.prediction(input: input) else {
            return
        }
        guard let newState = State(rawValue: output.movement) else { return }
        if state != newState && newState == .chew {
            chewCount += 1
            inBite = false
        }
        if state != newState && newState == .bite && !inBite {
            bitesCount += 1
            inBite = true
        }
        state = newState
        print(newState.rawValue)
    }
}

enum State: Int64 {
    case idle = 0, chew = 1, bite = 2
}
