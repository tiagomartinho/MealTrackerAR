import XCTest
@testable import ARKitFaceExample

class ChewDetectorTest: XCTestCase {
    
    func testDoNotDetectBite() {
        let delegate = SpyChewDetectorDelegate()
        let detector = ChewDetector(delegate: delegate)
        detector.input(jawOpen: 0.5, mouthClosed: 0.2)
        XCTAssertFalse(delegate.chewDetectedCalled)
        detector.input(jawOpen: 0.75, mouthClosed: 0.35)
        XCTAssertFalse(delegate.chewDetectedCalled)
        detector.input(jawOpen: 0.4, mouthClosed: 0.1)
        XCTAssertFalse(delegate.chewDetectedCalled)
    }
    
    func testDetectChew() {
        let delegate = SpyChewDetectorDelegate()
        let detector = ChewDetector(delegate: delegate)
        detector.input(jawOpen: 0.1, mouthClosed: 0.03)
        XCTAssertFalse(delegate.chewDetectedCalled)
        detector.input(jawOpen: 0.2, mouthClosed: 0.15)
        XCTAssertFalse(delegate.chewDetectedCalled)
        detector.input(jawOpen: 0.1, mouthClosed: 0.03)
        XCTAssert(delegate.chewDetectedCalled)
    }
    
    class SpyChewDetectorDelegate: ChewDetectorDelegate {
        
        var chewDetectedCalled = false
        
        func chewDetected() {
            chewDetectedCalled = true
        }
    }
}
