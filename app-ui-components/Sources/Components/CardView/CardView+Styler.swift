import Overture
import SnapKit
import UIKit

public extension Styler {
    enum Card {
        public typealias Modifier = (CardView) -> CardView

        public static let layout: (CGFloat) -> Modifier = { size in
            concat(
                set(\.stackView.alignment, .center),
                set(\.stackView.layoutMargins, UIEdgeInsets(all: size)),
                set(\.stackView.isLayoutMarginsRelativeArrangement, true),
                set(\.imageView.wv.contentMode, .scaleAspectFill),
                set(\.contentStackView.axis, .vertical),
                set(\.contentStackView.layoutMargins, UIEdgeInsets(horizontal: size)),
                set(\.contentStackView.spacing, 0.25 * size),
                set(\.contentStackView.isLayoutMarginsRelativeArrangement, true),
                set(\.headerLabelView.fontSize, 1.125 * size),
                set(\.headerLabelView.numberOfLines, 0),
                set(\.bodyLabelView.fontSize, 0.875 * size),
                set(\.bodyLabelView.numberOfLines, 0),
                set(\.accessoryStackView.spacing, 0.25 * size),
                {
                    $0.snp.remakeConstraints { $0.height.greaterThanOrEqualTo(5.0 * size).priority(900.0) }
                    $0.imageView.snp.remakeConstraints { $0.width.height.equalTo(3.0 * size).priority(900.0) }
                    return $0
                },
                Styler.rounded(size)
            )
        }

        public static let styleDefault: (CGFloat) -> Modifier = { size in
            concat(
                layout(size),
                set(\.backgroundColor, Styler.Color.backgroundPrimary),
                set(\.headerLabelView.fontName, Styler.FontName.header),
                set(\.headerLabelView.textColor, Styler.Color.labelPrimary),
                set(\.bodyLabelView.fontName, Styler.FontName.body),
                set(\.bodyLabelView.textColor, Styler.Color.labelPrimary)
            )
        }
    }
}

#if targetEnvironment(simulator)
import SwiftUI

@available(iOS 17, *)
#Preview("Small") {
    with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.S),
            Styler.elevated(1),

            set(\.image, UIImage(systemName: "scribble")),
            set(\.headText, "Lorem ipsum"),
            set(\.bodyText, "Dolor sit amet. Consectetur adipiscing elit.")
        )
    )
}

@available(iOS 17, *)
#Preview("Medium") {
    with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.elevated(1),

            set(\.image, UIImage(systemName: "scribble")),
            set(\.headText, "Lorem ipsum"),
            set(\.bodyText, "Consectetur adipiscing elit. Quisque rhoncus lacus quis quam ornare, a porttitor erat condimentum. Consectetur adipiscing elit. Quisque rhoncus lacus quis quam ornare, a porttitor erat condimentum. Consectetur adipiscing elit. Quisque rhoncus lacus quis quam ornare, a porttitor erat condimentum."),
            set(\.accessoryViews, [
                {
                    let label = UILabel()
                    label.textColor = .white
                    label.backgroundColor = .red
                    label.text = "A"
                    return label
                }(),
                {
                    let label = UILabel()
                    label.textColor = .white
                    label.backgroundColor = .red
                    label.text = "B"
                    return label
                }(),
                {
                    let label = UILabel()
                    label.textColor = .white
                    label.backgroundColor = .red
                    label.text = "C"
                    return label
                }()
            ])
        )
    )
}

@available(iOS 17, *)
#Preview("Large") {
    with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.S),
            Styler.elevated(1),

            set(\.image, UIImage(systemName: "scribble")),
            set(\.headText, "Lorem ipsum"),
            set(\.bodyText, "Dolor sit amet. Consectetur adipiscing elit.")
        )
    )
}

@available(iOS 17, *)
#Preview("Long") {
    with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.elevated(1),

            set(\.image, UIImage(systemName: "scribble")),
            set(\.headText, "Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet."),
            set(\.bodyText, "Consectetur adipiscing elit. Quisque rhoncus lacus quis quam ornare, a porttitor erat condimentum. Consectetur adipiscing elit. Quisque rhoncus lacus quis quam ornare, a porttitor erat condimentum. Consectetur adipiscing elit. Quisque rhoncus lacus quis quam ornare, a porttitor erat condimentum.")
        )
    )
}

@available(iOS 17, *)
#Preview("Image Only") {
    with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.elevated(1),

            set(\.image, UIImage(systemName: "scribble"))
        )
    )
}

@available(iOS 17, *)
#Preview("Text Only") {
    with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.elevated(1),

            set(\.headText, "Lorem ipsum"),
            set(\.bodyText, "Dolor sit amet. Consectetur adipiscing elit.")
        )
    )
}

@available(iOS 17, *)
#Preview("Empty") {
    with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.elevated(1)
        )
    )
}
#endif
