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
    
    func input(value: Double) {
        let defaults = UserDefaults.standard
        let jawSet = defaults.double(forKey: "biteSP")
        let aboveSet = value > jawSet
        let belowSet = value < jawSet
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

