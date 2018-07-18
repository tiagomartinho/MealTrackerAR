import Foundation

class RunningBuffer {
    
    private var size = 0
    private var buffer = [Double]()
    
    init(size: Int) {
        self.size = size
        buffer = [Double](repeating: 0.0, count: self.size)
    }

    var last: Double {
        return buffer.last ?? 0.0
    }

    func addSample(_ sample: Double) {
        buffer.insert(sample, at: 0)
        if buffer.count > size {
            buffer.removeLast()
        }
    }
    
    func reset() {
        buffer.removeAll(keepingCapacity: true)
    }
    
    func isFull() -> Bool {
        return size == buffer.count
    }
    
    func sum() -> Double {
        return buffer.reduce(0.0, +)
    }
    
    func min() -> Double {
        var min = 0.0
        if let bufMin = buffer.min() {
            min = bufMin
        }
        return min
    }
    
    func max() -> Double {
        var max = 0.0
        if let bufMax = buffer.max() {
            max = bufMax
        }
        return max
    }
    
    func recentMean() -> Double {
        return sum() / Double(buffer.count)
    }

    func standardDeviation() -> Double {
        let mean = recentMean()
        let sumSquared = buffer.reduce(0.0) { $0 + pow($1 - mean, 2) }
        return sqrt(sumSquared / Double(buffer.count))
    }
}

