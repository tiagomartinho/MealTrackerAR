protocol BiteDetectorDelegate: class {
    func biteDetected()
}

class BiteDetector {
    
    private var state: BiteDetectorState = .idle
    
    private weak var delegate: BiteDetectorDelegate?
    
    init(delegate: BiteDetectorDelegate) {
        self.delegate = delegate
    }
    
    func input(jawOpen: Double, mouthClosed: Double) {
        let aboveSet = jawOpen > 0.5 && mouthClosed > 0.2
        let belowSet = jawOpen < 0.5 && mouthClosed < 0.2
        if aboveSet {
            state = .detecting
        }
        if belowSet && state == .detecting {
            state = .idle
            delegate?.biteDetected()
        }
    }
}


enum BiteDetectorState {
    case idle, detecting
}

