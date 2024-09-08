import UIKit

public extension UIStackView {
    @discardableResult
    func addArrangedSubviews(_ views: [UIView]) -> Self {
        views.forEach { self.addArrangedSubview($0) }
        return self
    }

    @discardableResult
    func removeAllArrangedSubviews() -> Self {
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
        return self
    }
}
