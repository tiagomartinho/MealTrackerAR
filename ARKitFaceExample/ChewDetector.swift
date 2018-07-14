protocol ChewDetectorDelegate: class {
    func chewDetected()
}

class ChewDetector {
    
    private var state: ChewDetectorState = .idle
    
    private weak var delegate: ChewDetectorDelegate?
    
    init(delegate: ChewDetectorDelegate) {
        self.delegate = delegate
    }
    
    func input(jawOpen: Double, mouthClosed: Double) {
        let jawSet = 0.05
        let mouthSet = 0.05
        let aboveSet = jawOpen > jawSet && mouthClosed > mouthSet
        let belowSet = jawOpen < jawSet && mouthClosed < mouthSet
        if aboveSet {
            state = .detecting
        }
        if belowSet && state == .detecting {
            state = .idle
            delegate?.chewDetected()
        }
    }
}


enum ChewDetectorState {
    case idle, detecting
}

