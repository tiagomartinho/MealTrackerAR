import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController, ARSessionDelegate {
    
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
    
    var max3 = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.max3Label.text = "\(self.max3)"
            }
        }
    }
    var max2 = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.max2Label.text = "\(self.max2)"
            }
        }
    }
    var max = 0.0{
        didSet {
            DispatchQueue.main.async {
                self.maxLabel.text = "\(self.max)"
            }
        }
    }
    
    var max3m = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.max3MLabel.text = "\(self.max3m)"
            }
        }
    }
    var max2m = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.max2MLabel.text = "\(self.max2m)"
            }
        }
    }
    var maxm = 0.0{
        didSet {
            DispatchQueue.main.async {
                self.maxMLabel.text = "\(self.maxm)"
            }
        }
    }
    
    @IBOutlet weak var max3MLabel: UILabel!
    @IBOutlet weak var max2MLabel: UILabel!
    @IBOutlet weak var maxMLabel: UILabel!
    @IBOutlet weak var max3Label: UILabel!
    @IBOutlet weak var max2Label: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var bm: UITextField!
    @IBOutlet weak var bj: UITextField!
    @IBOutlet weak var cm: UITextField!
    @IBOutlet weak var cj: UITextField!
    @IBOutlet weak var bitesCountLabel: UILabel!
    @IBOutlet weak var chewCountLabel: UILabel!
    
    @IBAction func set(_ sender: Any) {
        max = 0.0
        max2 = 0.0
        max3 = 0.0
        maxm = 0.0
        max2m = 0.0
        max3m = 0.0
        chewCount = 0
        bitesCount = 0
        biteDetector = BiteDetector(delegate: self)
        chewDetector = ChewDetector(delegate: self)
        let defaults = UserDefaults.standard
        defaults.set(Double(bm.text!), forKey: "bm")
        defaults.set(Double(bj.text!), forKey: "bj")
        defaults.set(Double(cm.text!), forKey: "cm")
        defaults.set(Double(cj.text!), forKey: "cj")
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
            let mouthClose = faceAnchor.blendShapes[.mouthClose] as? Float
            else { return }
            biteDetector.input(jawOpen: Double(jawOpen), mouthClosed: Double(mouthClose))
            chewDetector.input(jawOpen: Double(jawOpen), mouthClosed: Double(mouthClose))
        if Double(jawOpen) > max {
            max = Double(jawOpen)
        }
        if Double(jawOpen) > max2 {
            max2 = Double(jawOpen)
        }
        if Double(jawOpen) > max3 {
            max3 = Double(jawOpen)
        }
        if Double(mouthClose) > maxm {
            maxm = Double(mouthClose)
        }
        if Double(mouthClose) > max2m {
            max2m = Double(mouthClose)
        }
        if Double(mouthClose) > max3m {
            max3m = Double(mouthClose)
        }
//        print("\(jawOpen),\(mouthClose)")
    }
}

extension ViewController: BiteDetectorDelegate, ChewDetectorDelegate {
    func biteDetected() {
        bitesCount += 1
        max2 = 0.0
        max2m = 0.0
    }

    func chewDetected() {
        chewCount += 1
        max3 = 0.0
        max3m = 0.0
    }
}
