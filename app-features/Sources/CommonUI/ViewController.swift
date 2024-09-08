import AppUIComponents
import UIKit

open class ViewController<V: UIView>: UIViewController {
    public typealias CustomView = V
    public private(set) lazy var customView: CustomView = self.buildView()

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented!")
    }

    open override func loadView() {
        self.view = self.customView
    }

    open func buildView() -> CustomView {
        fatalError("Not impl emented!")
    }
}
