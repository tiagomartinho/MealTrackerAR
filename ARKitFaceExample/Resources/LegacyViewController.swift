import ARKit
import SceneKit
import UIKit

class LegacyViewController: UIViewController, ARSessionDelegate {
    
    let runningBuffer = RunningBuffer(size: 25)
    let runningBufferChew = RunningBuffer(size: 5)

    @IBOutlet weak var meanbufferClabel: UILabel!
    @IBOutlet weak var meanBufferBlabel: UILabel!
    @IBOutlet weak var minBufferCLabel: UILabel!
    @IBOutlet weak var minBufferBlabel: UILabel!
    @IBOutlet weak var maxBufferBlabel: UILabel!
    @IBOutlet weak var maxBufferCLabel: UILabel!
    @IBOutlet weak var maxcLabel: UILabel!
    @IBOutlet weak var maxBLabel: UILabel!
    @IBOutlet weak var chewValueLabel: UILabel!
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
                self.maxBLabel.text = "\(self.max.currency)"
            }
        }
    }
    
    var maxc = 0.0{
        didSet {
            DispatchQueue.main.async {
                self.maxcLabel.text = "\(self.maxc.currency)"
            }
        }
    }
    
    @IBOutlet weak var cj: UITextField!
    @IBOutlet weak var bitesCountLabel: UILabel!
    @IBOutlet weak var chewCountLabel: UILabel!
    
    @IBAction func set(_ sender: Any) {
        runningBufferChew.reset()
        runningBuffer.reset()
        max = 0.0
        maxc = 0.0
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

extension LegacyViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        guard let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float,
            let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as? Float,
            let mouthPucker = faceAnchor.blendShapes[.mouthPucker] as? Float,
            let mouthFrownLeft = faceAnchor.blendShapes[.mouthFrownLeft] as? Float,
            let mouthFrownRight = faceAnchor.blendShapes[.mouthFrownRight] as? Float,
            let mouthLowerDownLeft = faceAnchor.blendShapes[.mouthLowerDownLeft] as? Float,
            let mouthLowerDownRight = faceAnchor.blendShapes[.mouthLowerDownRight] as? Float,
            let mouthStretchRight = faceAnchor.blendShapes[.mouthStretchRight] as? Float,
            let mouthStretchLeft = faceAnchor.blendShapes[.mouthStretchLeft] as? Float
            else { return }
        let bite = Double(jawOpen + mouthLowerDownLeft + mouthLowerDownRight + mouthStretchRight + mouthStretchLeft)
        runningBuffer.addSample(bite)
        runningBufferChew.addSample(bite + Double(mouthPucker + mouthFrownLeft + mouthFrownRight))
        if !runningBuffer.isFull() { return }
        let sum = runningBuffer.sum()
        let sumc = runningBufferChew.sum()
        biteDetector.input(value: sum)
        chewDetector.input(value: runningBufferChew.recentMean())
        if sum > max {
            max = sum
        }
        if sumc > maxc {
            maxc = sumc
        }
        DispatchQueue.main.async {
            self.jawOpen.text = "\(sum.currency)"
            self.chewValueLabel.text = "\(sumc.currency)"
            self.meanBufferBlabel.text = "\(self.runningBuffer.recentMean().currency)"
            self.meanbufferClabel.text = "\(self.runningBufferChew.recentMean().currency)"
            self.maxBufferBlabel.text = "\(self.runningBuffer.max().currency)"
            self.maxBufferCLabel.text = "\(self.runningBufferChew.max().currency)"
            self.minBufferBlabel.text = "\(self.runningBuffer.min().currency)"
            self.minBufferCLabel.text = "\(self.runningBufferChew.min().currency)"
        }
    }
}

extension LegacyViewController: BiteDetectorDelegate, ChewDetectorDelegate {
    func biteDetected() {
//        chewDetector.reset()
        bitesCount += 1
    }

    func chewDetected() {
        chewCount += 1
    }
}

extension Double {
    var currency: String {
        return String(format: "%.1f", abs(self))
    }
}
