import Foundation
import ARKit

class StatusViewController: UIViewController {

    @IBOutlet weak var messagePanel: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var restartExperienceButton: UIButton!

    var restartExperienceHandler: () -> Void = {}

    var isRestartExperienceButtonEnabled: Bool {
        get { return restartExperienceButton.isEnabled }
        set { restartExperienceButton.isEnabled = newValue }
    }

    private var messageHideTimer: Timer?
    
	func showMessage(_ text: String, autoHide: Bool = true) {
        messageHideTimer?.invalidate()
        messageLabel.text = text
        showHideMessage(hide: false, animated: true)
        if autoHide {
            let displayDuration: TimeInterval = 6
            messageHideTimer = Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false, block: { [weak self] _ in
                self?.showHideMessage(hide: true, animated: true)
            })
        }
	}
    
	private func showHideMessage(hide: Bool, animated: Bool) {
		guard animated else {
			messageLabel.isHidden = hide
			return
		}
		UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.messageLabel.isHidden = hide
            self.updateMessagePanelVisibility()
        }, completion: nil)
	}
	
	private func updateMessagePanelVisibility() {
		messagePanel.isHidden = messageLabel.isHidden
	}

    @IBAction func restartExperience(_ sender: UIButton) {
        restartExperienceHandler()
    }
}
