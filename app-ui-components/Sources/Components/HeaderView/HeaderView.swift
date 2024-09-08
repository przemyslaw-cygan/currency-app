import SnapKit
import UIKit

public class HeaderView: CustomView {
    public let labelView = CustomViewWrapper(UILabel())

    public var label: String? {
        get { self.labelView.wv.text }
        set { self.labelView.wv.text = newValue }
    }

    public override init() {
        super.init()

        self.addSubviews([
            self.labelView,
        ])

        self.labelView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
