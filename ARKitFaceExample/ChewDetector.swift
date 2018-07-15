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
    
    func input(jawOpen: Double, mouthClose: Double) {
        let defaults = UserDefaults.standard
        let jawSet = defaults.double(forKey: "cj")
        let aboveSet = jawOpen > jawSet && mouthClose > jawSet
        let belowSet = jawOpen < jawSet && mouthClose < jawSet
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

