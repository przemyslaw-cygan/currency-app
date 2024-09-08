import UIKit

public extension UIEdgeInsets {
    init(all: CGFloat) {
        self.init(
            top: all,
            left: all,
            bottom: all,
            right: all
        )
    }

    init(horizontal: CGFloat = .zero, vertical: CGFloat = .zero) {
        self.init(
            top: vertical,
            left: horizontal,
            bottom: vertical,
            right: horizontal
        )
    }
}
