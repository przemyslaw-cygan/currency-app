import Overture
import SnapKit
import UIKit

public extension Styler {
    enum Button {
        public typealias Modifier = (ButtonView) -> ButtonView

        public static let layout: (CGFloat) -> Modifier = { size in
            concat(
                set(\.stackView.alignment, .center),
                set(\.stackView.layoutMargins, UIEdgeInsets(all: 0.75 * size)),
                set(\.stackView.isLayoutMarginsRelativeArrangement, true),

                set(\.iconView.wv.clipsToBounds, true),
                set(\.iconView.wv.contentMode, .scaleAspectFit),

                set(\.labelView.layoutMargins, UIEdgeInsets(horizontal: 0.75 * size)),
                set(\.labelView.wv.fontSize, size),
                set(\.labelView.wv.textAlignment, .center),

                {
                    $0.snp.remakeConstraints { $0.height.equalTo(3.0 * size).priority(900.0) }
                    $0.iconView.snp.remakeConstraints { $0.height.width.equalTo(1.5 * size).priority(900.0) }
                    $0.labelView.snp.remakeConstraints { $0.height.equalTo(1.5 * size).priority(900.0) }
                    return $0
                },

                Styler.circular()
            )
        }

        public static let styleDefault: (CGFloat) -> Modifier = { size in
            concat(
                layout(size),
                set(\.backgroundColor, Styler.Color.backgroundPrimary),
                set(\.iconView.wv.tintColor, Styler.Color.accentBackground),
                set(\.labelView.wv.fontName, Styler.FontName.button),
                set(\.labelView.wv.textColor, Styler.Color.accentBackground)
            )
        }

        public static let stylePrimary: (CGFloat) -> Modifier = { size in
            concat(
                layout(size),
                set(\.backgroundColor, Styler.Color.accentBackground),
                set(\.iconView.wv.tintColor, Styler.Color.accentForeground),
                set(\.labelView.wv.fontName, Styler.FontName.button),
                set(\.labelView.wv.textColor, Styler.Color.accentForeground)
            )
        }

        public static let styleSecondary: (CGFloat) -> Modifier = { size in
            concat(
                layout(size),
                set(\.backgroundColor, Styler.Color.backgroundSecondary),
                set(\.iconView.wv.tintColor, Styler.Color.labelPrimary),
                set(\.labelView.wv.fontName, Styler.FontName.button),
                set(\.labelView.wv.textColor, Styler.Color.labelPrimary)
            )
        }
    }
}

#if targetEnvironment(simulator)
import SwiftUI

@available(iOS 17, *)
#Preview("Small") {
    with(
        ButtonView(),
        concat(
            Styler.Button.styleDefault(Styler.Size.S),
            Styler.circular(true),
            Styler.elevated(1),

            set(\.icon, UIImage(systemName: "scribble")),
            set(\.label, "Lorem ipsum")
        )
    )
}

@available(iOS 17, *)
#Preview("Medium") {
    with(
        ButtonView(),
        concat(
            Styler.Button.stylePrimary(Styler.Size.M),
            Styler.circular(true),
            Styler.elevated(1),

            set(\.icon, UIImage(systemName: "scribble")),
            set(\.label, "Lorem ipsum")
        )
    )
}

@available(iOS 17, *)
#Preview("Large") {
    with(
        ButtonView(),
        concat(
            Styler.Button.styleSecondary(Styler.Size.S),
            Styler.circular(true),
            Styler.elevated(1),

            set(\.icon, UIImage(systemName: "scribble")),
            set(\.label, "Lorem ipsum")
        )
    )
}

@available(iOS 17, *)
#Preview("Long") {
    with(
        ButtonView(),
        concat(
            Styler.Button.stylePrimary(Styler.Size.M),
            Styler.elevated(1),

            set(\.icon, UIImage(systemName: "scribble")),
            set(\.label, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque rhoncus lacus quis quam ornare, a porttitor erat condimentum.")
        )
    )
}

@available(iOS 17, *)
#Preview("Image Only") {
    with(
        ButtonView(),
        concat(
            Styler.Button.stylePrimary(Styler.Size.M),
            Styler.elevated(1),

            set(\.icon, UIImage(systemName: "scribble"))
        )
    )
}

@available(iOS 17, *)
#Preview("Text Only") {
    with(
        ButtonView(),
        concat(
            Styler.Button.stylePrimary(Styler.Size.M),
            Styler.elevated(1),

            set(\.label, "Lorem ipsum")
        )
    )
}

@available(iOS 17, *)
#Preview("Empty") {
    with(
        ButtonView(),
        concat(
            Styler.Button.stylePrimary(Styler.Size.M),
            Styler.elevated(1)
        )
    )
}
#endif
