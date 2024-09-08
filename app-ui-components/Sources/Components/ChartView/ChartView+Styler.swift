import Overture
import SnapKit
import UIKit

public extension Styler {
    enum Chart {
        public typealias Modifier = (ChartView) -> ChartView

        public static let color: (UIColor?) -> Modifier = { color in
            concat(
                set(\.plotView.strokeLayer.strokeColor, color?.cgColor),
                set(\.plotView.fillLayer.colors, [
                    color?.cgColor,
                    color?.withAlphaComponent(0.25).cgColor
                ].compactMap { $0 })
            )
        }

        public static let layout: (CGFloat) -> Modifier = { size in
            concat(
                set(\.layoutMargins, UIEdgeInsets(
                    top: 3.0 * size,
                    left: 3.0 * size,
                    bottom: 3.0 * size,
                    right: 3.0 * size
                )),
                set(\.wrapperView.layoutMargins, UIEdgeInsets(all: 0.75 * size)),
                set(\.xLabelsView.labelTemplate.fontSize, size),
                set(\.yGuidesView.guideTemplate.lineWidth, 1.0),
                set(\.yGuidesView.guideTemplate.lineDashPattern, [
                    NSNumber(value: 0.5 * size),
                    NSNumber(value: 0.5 * size)
                ]),
                set(\.yLabelsView.labelTemplate.fontSize, size)
            )
        }

        public static let styleDefault: (CGFloat) -> Modifier = { size in
            concat(
                layout(size),
                color(Styler.Color.labelSecondary),

                set(\.backgroundColor, Styler.Color.backgroundPrimary),

                set(\.xScaleView.strokeLayer.strokeColor, Styler.Color.labelSecondary?.cgColor),
                set(\.xLabelsView.labelTemplate.fontName, Styler.FontName.label),
                set(\.xLabelsView.labelTemplate.textColor, Styler.Color.labelSecondary),

                set(\.yGuidesView.guideTemplate.strokeColor, Styler.Color.labelSecondary?.withAlphaComponent(0.5).cgColor),
                set(\.yLabelsView.labelTemplate.textColor, Styler.Color.labelSecondary),
                set(\.yLabelsView.labelTemplate.fontName, Styler.FontName.label)
            )
        }
    }
}

#if targetEnvironment(simulator)
import SwiftUI

@available(iOS 17, *)
#Preview {
    with(
        ChartView(),
        concat(
            Styler.Chart.styleDefault(Styler.Size.M),
            Styler.Chart.color(Styler.Color.indicatingPositive),
            set(\.data, ChartData(
                yGuides: [
                    0.0: "ya",
                    5.0: "yb",
                    10.0: "yc",
                    15.0: "yd",
                ],
                xGuides: [
                    0.0: "xa",
                    10.0: "xb",
                    20.0: "xf",
                    30.0: "xc",
                    40.0: "xd",
                    50.0: "xe",
                ],
                points: [
                    0.0: 5.0,
                    2.0: 3.5,
                    4.0: 0.5,
                    8.0: 12.0,
                    10.0: 9.0,
                    12.0: 4.6,
                    50.0: 10.0
                ]
            ))
        )
    )
}
#endif
