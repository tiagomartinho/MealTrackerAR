import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController, ARSessionDelegate {
    
    let runningBuffer = RunningBuffer(size: 25)
    let runningBuffer10 = RunningBuffer(size: 10)
    let runningBuffer5 = RunningBuffer(size: 5)

    @IBOutlet weak var biteSP: UITextField!
    @IBOutlet weak var jawOpen: UILabel!
    var chewCount = 0  {
        didSet {
            DispatchQueue.main.async {
                self.chewCountLabel.text = "\(self.chewCount)"
            }
        }
    }
    var bitesCount = 0{
        didSet {
            DispatchQueue.main.async {
                self.bitesCountLabel.text = "\(self.bitesCount)"
            }
        }
    }
    
    var max = 0.0{
        didSet {
            DispatchQueue.main.async {
                self.maxLabel.text = "\(self.max.currency)"
            }
        }
    }
    
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var cj: UITextField!
    @IBOutlet weak var bitesCountLabel: UILabel!
    @IBOutlet weak var chewCountLabel: UILabel!
    
    @IBAction func set(_ sender: Any) {
        max = 0.0
        chewCount = 0
        bitesCount = 0
        biteDetector = BiteDetector(delegate: self)
        chewDetector = ChewDetector(delegate: self)
        let defaults = UserDefaults.standard
        defaults.set(Double(cj.text!), forKey: "cj")
        defaults.set(Double(biteSP.text!), forKey: "biteSP")
        DispatchQueue.main.async {
            self.resignFirstResponder()
            self.view.endEditing(true)
        }
    }

    lazy var biteDetector: BiteDetector = { BiteDetector(delegate: self) }()
    lazy var chewDetector: ChewDetector = { ChewDetector(delegate: self) }()

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var blurView: UIVisualEffectView!

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
        blurView.isHidden = false
        statusViewController.showMessage("""
        SESSION INTERRUPTED
        The session will be reset after the interruption has ended.
        """, autoHide: false)
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        blurView.isHidden = true
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
        blurView.isHidden = false
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.blurView.isHidden = true
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        guard let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float,
            let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as? Float,
            let mouthClose = faceAnchor.blendShapes[.mouthClose] as? Float,
            let jawForward = faceAnchor.blendShapes[.jawForward] as? Float,
            let mouthPucker = faceAnchor.blendShapes[.mouthPucker] as? Float
            else { return }
        let value2 = Double(jawOpen + mouthFunnel + mouthClose + jawForward + mouthPucker)
        runningBuffer.addSample(value2)
        if !runningBuffer.isFull() { return }
        let sum = runningBuffer.sum()
        biteDetector.input(value: sum)
        chewDetector.input(jawOpen: Double(jawOpen), mouthClose: Double(mouthClose))
        if sum > max {
            max = sum
        }
        DispatchQueue.main.async {
            self.jawOpen.text = "\(sum.currency)"
        }
        print("\(jawOpen),\(mouthClose)")
    }
}

extension ViewController: BiteDetectorDelegate, ChewDetectorDelegate {
    func biteDetected() {
        bitesCount += 1
    }

    func chewDetected() {
        chewCount += 1
    }
}

extension Double {
    var currency: String {
        return String(format: "%.2f", abs(self))
    }
}
