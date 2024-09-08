import UIKit

open class CustomView: UIView {
    public var isCircular: Bool = false {
        didSet { self.layoutSubviews() }
    }

    public init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented!")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.isCircular {
            self.layer.cornerRadius = 0.5 * self.frame.size.height
        }
    }
}
