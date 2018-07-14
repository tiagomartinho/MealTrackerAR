import Foundation

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
        let defaults = UserDefaults.standard
        let jawSet = defaults.double(forKey: "bj")
        let mouthSet = defaults.double(forKey: "bm")
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

