import Foundation

protocol ChewDetectorDelegate: class {
    func chewDetected()
}

class ChewDetector {
    
    func reset() {
        min = 2.0
        max = 0.0
    }
    
    private var min = 2.0
    private var max = 0.0

    private var state: ChewDetectorState = .idle
    
    private weak var delegate: ChewDetectorDelegate?
    
    init(delegate: ChewDetectorDelegate) {
        self.delegate = delegate
    }
    
    func input(value: Double) {
        if value > max {
            max = value
        }
        if value < min {
            min = value
        }
        let jawSet = (max - min) * 0.5 + min
        let aboveSet = value > jawSet
        let belowSet = value < jawSet
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

