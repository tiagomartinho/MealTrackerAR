import XCTest

class BiteDetectorTest: XCTestCase {
    
    func testStartDetectingBiteWhenValueGoesAboveThreshold() {
        let delegate = SpyBiteDetectorDelegate()
        let detector = BiteDetector(delegate: delegate)
        detector.input(jawOpen: 0.5, mouthClosed: 0.2)
        XCTAssertFalse(delegate.biteDetectedCalled)
        detector.input(jawOpen: 0.75, mouthClosed: 0.35)
        XCTAssertFalse(delegate.biteDetectedCalled)
        detector.input(jawOpen: 0.4, mouthClosed: 0.1)
        XCTAssert(delegate.biteDetectedCalled)
    }
    
    class SpyBiteDetectorDelegate: BiteDetectorDelegate {
        
        var biteDetectedCalled = false
        
        func biteDetected() {
            biteDetectedCalled = true
        }
    }
}
