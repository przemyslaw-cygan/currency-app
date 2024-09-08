import Overture
import SnapKit
import UIKit

public extension Styler {
    enum Text {
        public typealias Modifier = (HeaderView) -> HeaderView

        public static let layout: (CGFloat) -> Modifier = { size in
            concat(
                set(\.labelView.layoutMargins, UIEdgeInsets(vertical: 0.5 * size)),
                set(\.labelView.wv.fontSize, 1.25 * size),
                {
                    $0.snp.remakeConstraints { $0.height.equalTo(3.0 * size).priority(900.0) }
                    return $0
                }
            )
        }

        public static let stylePrimary: (CGFloat) -> Modifier = { size in
            concat(
                layout(size),
                set(\.labelView.wv.fontName, Styler.FontName.label),
                set(\.labelView.wv.textColor, Styler.Color.labelPrimary)
            )
        }

        public static let styleSecondary: (CGFloat) -> Modifier = { size in
            concat(
                layout(size),
                set(\.labelView.wv.fontName, Styler.FontName.label),
                set(\.labelView.wv.textColor, Styler.Color.labelSecondary)
            )
        }
    }
}
