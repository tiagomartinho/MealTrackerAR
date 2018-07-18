import Foundation

protocol BiteDetectorDelegate: class {
    func biteDetected()
}

class BiteDetector {

    private var buffer = RunningBuffer(size: 20)
    private let threshold = 7.0
    private let influence = 0.5

    private weak var delegate: BiteDetectorDelegate?
    
    init(delegate: BiteDetectorDelegate) {
        self.delegate = delegate
    }
    
    func input(value: Double) {
        guard buffer.isFull() else { buffer.addSample(value); return }
        let mean = buffer.recentMean()
        let std = buffer.standardDeviation()
        if abs(value - mean) > threshold * std {
            if value > mean {
                delegate?.biteDetected()
            }
            buffer.addSample(influence * value + (1-influence)*buffer.last)
        } else {
            buffer.addSample(value)
        }
    }
}
