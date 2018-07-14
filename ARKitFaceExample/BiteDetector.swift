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
        let jawSet = 0.4
        let mouthSet = 0.15
        let aboveSet = jawOpen > jawSet && mouthClosed > mouthSet
        let belowSet = jawOpen < jawSet && mouthClosed < mouthSet
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

