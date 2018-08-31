import UIKit
import ARKit
import CoreML

class RecordMealViewController: UIViewController {
    
    var startStopButton: UIButton!
    var sceneView: ARSCNView!
    var session: ARSession { return sceneView.session }
    var recording = false
    var blendShapes: [[ARFaceAnchor.BlendShapeLocation: NSNumber]] = []

    let model = bites()
    
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
        guard let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float, let mouthLowerDown_R = faceAnchor.blendShapes[.mouthLowerDownRight] as? Float, let mouthLowerDown_L = faceAnchor.blendShapes[.mouthLowerDownLeft] as? Float, let mouthStretch_R = faceAnchor.blendShapes[.mouthStretchRight] as? Float, let mouthStretch_L = faceAnchor.blendShapes[.mouthStretchLeft] as? Float, let mouthPucker = faceAnchor.blendShapes[.mouthPucker] as? Float, let mouthFrown_R = faceAnchor.blendShapes[.mouthFrownRight] as? Float, let mouthFrown_L = faceAnchor.blendShapes[.mouthFrownLeft] as? Float, let mouthClose = faceAnchor.blendShapes[.mouthClose] as? Float, let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as? Float, let mouthUpperUp_L = faceAnchor.blendShapes[.mouthUpperUpLeft] as? Float, let mouthUpperUp_R = faceAnchor.blendShapes[.mouthUpperUpRight] as? Float, let jawForward = faceAnchor.blendShapes[.jawForward] as? Float, let mouthShrugLower = faceAnchor.blendShapes[.mouthShrugLower] as? Float, let mouthShrugUpper = faceAnchor.blendShapes[.mouthShrugUpper] as? Float, let jawRight = faceAnchor.blendShapes[.jawRight] as? Float, let jawLeft = faceAnchor.blendShapes[.jawLeft] as? Float, let mouthDimple_L = faceAnchor.blendShapes[.mouthDimpleLeft] as? Float, let mouthDimple_R = faceAnchor.blendShapes[.mouthDimpleRight] as? Float, let mouthRollLower = faceAnchor.blendShapes[.mouthRollLower] as? Float, let mouthRollUpper = faceAnchor.blendShapes[.mouthRollUpper] as? Float, let mouthLeft = faceAnchor.blendShapes[.mouthLeft] as? Float, let mouthRight = faceAnchor.blendShapes[.mouthRight] as? Float, let mouthSmile_L = faceAnchor.blendShapes[.mouthSmileLeft] as? Float, let mouthSmile_R = faceAnchor.blendShapes[.mouthSmileRight] as? Float, let mouthPress_L = faceAnchor.blendShapes[.mouthPressLeft] as? Float, let mouthPress_R = faceAnchor.blendShapes[.mouthPressRight] as? Float else {
             return
        }
        
        let input = bitesInput(jawOpen: Double(jawOpen), mouthLowerDown_R: Double(mouthLowerDown_R), mouthLowerDown_L: Double(mouthLowerDown_L), mouthStretch_R: Double(mouthStretch_R), mouthStretch_L: Double(mouthStretch_L), mouthPucker: Double(mouthPucker), mouthFrown_R: Double(mouthFrown_R), mouthFrown_L: Double(mouthFrown_L), mouthClose: Double(mouthClose), mouthFunnel: Double(mouthFunnel), mouthUpperUp_L: Double(mouthUpperUp_L), mouthUpperUp_R: Double(mouthUpperUp_R), jawForward: Double(jawForward), mouthShrugLower: Double(mouthShrugLower), mouthShrugUpper: Double(mouthShrugUpper), jawRight: Double(jawRight), jawLeft: Double(jawLeft), mouthDimple_L: Double(mouthDimple_L), mouthDimple_R: Double(mouthDimple_R), mouthRollLower: Double(mouthRollLower), mouthRollUpper: Double(mouthRollUpper), mouthLeft: Double(mouthLeft), mouthRight: Double(mouthRight), mouthSmile_L: Double(mouthSmile_L), mouthSmile_R: Double(mouthSmile_R), mouthPress_L: Double(mouthPress_L), mouthPress_R: Double(mouthPress_R))
        guard let output = try? model.prediction(input: input) else {
            print("no output")
            return
        }
//        print("move: \(output.movement) prob: \(output.movementProbability)")
        print(output.movement)
//        guard let marsHabitatPricerOutput = try? model.prediction(solarPanels: solarPanels, greenhouses: greenhouses, size: size) else {
//            fatalError("Unexpected runtime error.")
//        }
        if recording {
            self.blendShapes.append(faceAnchor.blendShapes)
        }
    }
}
