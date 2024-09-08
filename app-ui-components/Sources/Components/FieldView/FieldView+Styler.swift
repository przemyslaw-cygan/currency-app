import Overture
import SnapKit
import UIKit

public extension Styler {
    enum Field {
        public typealias Modifier = (FieldView) -> FieldView

        public static let layout: (CGFloat) -> Modifier = { size in
            concat(
                set(\.fieldView.layoutMargins, UIEdgeInsets(
                    top: 0.0,
                    left: 1.5 * size,
                    bottom: 0.0,
                    right: 0.5 * size
                )),
                set(\.fieldView.wv.fontSize, size),
                set(\.accessoryStackView.alignment, .center),
                {
                    $0.snp.remakeConstraints { $0.height.equalTo(3.0 * size).priority(900.0) }
                    $0.fieldView.snp.remakeConstraints { $0.height.equalTo(3.0 * size).priority(900.0) }
                    return $0
                },
                Styler.circular(true)
            )
        }

        public static let styleDefault: (CGFloat) -> Modifier = { size in
            concat(
                layout(size),
                set(\.backgroundColor, Styler.Color.backgroundPrimary),
                set(\.fieldView.wv.fontName, Styler.FontName.field),
                set(\.fieldView.wv.textColor, Styler.Color.labelSecondary)
            )
        }
    }
}

#if targetEnvironment(simulator)
import SwiftUI

@available(iOS 17, *)
#Preview("Default") {
    with(
        FieldView(),
        concat(
            Styler.Field.styleDefault(Styler.Size.M),
            Styler.elevated(1),

            set(\.text, "Lorem ipsum"),
            set(\.accessoryViews, [
                with(
                    ButtonView(),
                    concat(
                        set(\.icon, UIImage(systemName: "scribble")),
                        Styler.Button.stylePrimary(Styler.Size.M)
                    )
                ),
                with(
                    ButtonView(),
                    concat(
                        set(\.icon, UIImage(systemName: "scribble")),
                        Styler.Button.styleDefault(Styler.Size.M)
                    )
                ),
            ])
        )
    )
}

@available(iOS 17, *)
#Preview("Field Only") {
    with(
        FieldView(),
        concat(
            Styler.Field.styleDefault(Styler.Size.M),
            Styler.elevated(1),

            set(\.text, "Lorem ipsum")
        )
    )
}
#endif
