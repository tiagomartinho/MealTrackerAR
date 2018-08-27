import UIKit
import ARKit

class RecordMealViewController: UIViewController {
    
    var startStopButton: UIButton!
    var sceneView: ARSCNView!
    var session: ARSession { return sceneView.session }
    var recording = false
    var blendShapes: [[ARFaceAnchor.BlendShapeLocation: NSNumber]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        sceneView = ARSCNView()
        view.addSubview(sceneView)
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        startStopButton = UIButton(type: .system)
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.isEnabled = false
        view.addSubview(startStopButton)
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startStopButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        startStopButton.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
    }
    
    @objc func startRecording() {
        recording = !recording
        let title = recording ? "Stop" : "Start"
        startStopButton.setTitle(title, for: .normal)
        if recording { return }
        var csvText = ""
        let fileName = "Payloads-\(Date()).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)!
        for blendShape in blendShapes {
            let mouthJawShapes = blendShape.filter { (key, _) -> Bool in
                return key.rawValue.contains("jaw") || key.rawValue.contains("mouth")
            }
            for shape in mouthJawShapes {
                csvText.append("\(shape.key.rawValue),\(shape.value)\n")
            }
            let bite = (mouthJawShapes[.jawOpen] as! Float) +
                (mouthJawShapes[.mouthLowerDownLeft] as! Float) +
                (mouthJawShapes[.mouthLowerDownRight] as! Float) +
                (mouthJawShapes[.mouthStretchRight] as! Float) +
                (mouthJawShapes[.mouthStretchLeft] as! Float) +
                1 - (mouthJawShapes[.mouthFrownRight] as! Float) +
                1 - (mouthJawShapes[.mouthFrownLeft] as! Float) +
                1 - (mouthJawShapes[.mouthPucker] as! Float)
            csvText.append("Bite,\(bite)\n")

            let chew = (mouthJawShapes[.jawOpen] as! Float) +
                (mouthJawShapes[.mouthLowerDownLeft] as! Float) +
                (mouthJawShapes[.mouthLowerDownRight] as! Float) +
                (mouthJawShapes[.mouthStretchRight] as! Float) +
                (mouthJawShapes[.mouthStretchLeft] as! Float) +
                (mouthJawShapes[.mouthFrownRight] as! Float) +
                (mouthJawShapes[.mouthFrownLeft] as! Float) +
                (mouthJawShapes[.mouthPucker] as! Float) +
                (mouthJawShapes[.mouthFunnel] as! Float) +
                (mouthJawShapes[.mouthClose] as! Float)

            csvText.append("Chew,\(chew-bite)\n")
        }
        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("\(error)")
        }
        let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
        present(vc, animated: true, completion: nil)
        blendShapes = []
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
        self.startStopButton.isEnabled = false
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension RecordMealViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.startStopButton.isEnabled = false
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        DispatchQueue.main.async {
            self.startStopButton.isEnabled = false
        }
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.startStopButton.isEnabled = false
            self.resetTracking()
        }
    }
}


extension RecordMealViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            self.startStopButton.isEnabled = true
        }
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        if recording {
            self.blendShapes.append(faceAnchor.blendShapes)
        }
    }
}
