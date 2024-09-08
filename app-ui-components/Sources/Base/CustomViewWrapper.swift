import SnapKit
import UIKit

public class CustomViewWrapper<T: UIView>: CustomView {
    public let wv: T

    public init(_ wv: T = T()) {
        self.wv = wv
        super.init()

        self.layoutMargins = .zero
        self.addSubview(self.wv)
        self.wv.snp.makeConstraints {
            $0.edges.equalTo(self.layoutMarginsGuide)
        }
    }
}
