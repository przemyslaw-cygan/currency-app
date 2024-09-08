import UIKit

public extension UIControl {
    func on(_ event: UIControl.Event, _ handler: @escaping UIActionHandler) {
        self.addAction(UIAction(handler: handler), for: event)
    }
}
