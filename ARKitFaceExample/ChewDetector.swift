import Foundation

protocol ChewDetectorDelegate: class {
    func chewDetected()
}

class ChewDetector {
    
    private var buffer = RunningBuffer(size: 5)
    private let threshold = 5.65
    private let influence = 0.5
    private var state: ChewDetectorState = .idle

    private weak var delegate: ChewDetectorDelegate?

    init(delegate: ChewDetectorDelegate) {
        self.delegate = delegate
    }

    func input(value: Double) {
        guard buffer.isFull() else { buffer.addSample(value); return }
        let mean = buffer.recentMean()
        let std = buffer.standardDeviation()
        if abs(value - mean) > threshold * std {
            if value > mean && state != .detecting {
                delegate?.chewDetected()
            }
            buffer.addSample(influence * value + (1-influence)*buffer.last)
            state = .detecting
        } else {
            buffer.addSample(value)
            state = .idle
        }
    }
}


enum ChewDetectorState {
    case idle, detecting
}

