import Foundation

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
        let defaults = UserDefaults.standard
        let jawSet = defaults.double(forKey: "cj")
        let mouthSet = defaults.double(forKey: "cm")
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

