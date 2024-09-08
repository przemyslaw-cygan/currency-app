import AppUIComponents
import Overture
import SnapKit
import UIKit

public class DetailsView: CustomView {
    public let refreshControl = UIRefreshControl()

    public let titleView = with(
        HeaderView(),
        concat(
            Styler.Text.stylePrimary(Styler.Size.L),
            set(\.label, "Details")
        )
    )

    public let convertButton = with(
        ButtonView(),
        concat(
            Styler.Button.styleSecondary(Styler.Size.L),
            set(\.label, "Convert")
        )
    )

    public lazy var scrollView = with(
        UIScrollView(),
        concat(
            set(\.refreshControl, Optional(self.refreshControl)),
            set(\.showsVerticalScrollIndicator, false),
            set(\.showsHorizontalScrollIndicator, false)
        )
    )

    public let stackView = with(
        UIStackView(),
        concat(
            set(\.axis, .vertical),
            set(\.layoutMargins, UIEdgeInsets(all: Styler.Size.spacing)),
            set(\.spacing, 2 * Styler.Size.spacing),
            set(\.isLayoutMarginsRelativeArrangement, true)
        )
    )

    public lazy var currencyView = with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.rounded(Styler.Size.M),
            Styler.elevated(1)
        )
    )

    public let buttonsStackView = with(
        UIStackView(),
        concat(
            set(\.distribution, .fillEqually),
            set(\.spacing, Styler.Size.spacing),
            set(\.layoutMargins, UIEdgeInsets(all: Styler.Size.spacing)),
            Styler.elevated(1)
        )
    )

    public var buttonViews: [ButtonView] = [] {
        willSet { self.buttonViews.forEach { $0.removeFromSuperview() } }
        didSet { self.buttonsStackView.addArrangedSubviews(self.buttonViews) }
    }

    public var buttonView: (String?, Bool) -> ButtonView = { label, selected in
        with(
            ButtonView(),
            concat(
                selected
                    ? Styler.Button.stylePrimary(Styler.Size.M)
                    : Styler.Button.styleDefault(Styler.Size.M),
                set(\.label, label)
            )
       )
    }

    public let chartView = with(
        ChartView(),
        concat(
            Styler.Chart.styleDefault(Styler.Size.M),
            Styler.Chart.color(Styler.Color.accentBackground),
            Styler.rounded(Styler.Size.M),
            Styler.elevated(1)
        )
    )

    public override init() {
        super.init()
        self.backgroundColor = Styler.Color.backgroundPrimary

        self.addSubviews([
            self.scrollView.addSubviews([
                self.stackView.addArrangedSubviews([
                    self.currencyView,
                    self.buttonsStackView,
                    self.chartView,
                ]),
            ]),
        ])

        self.scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        self.chartView.snp.makeConstraints {
            $0.height.equalTo(self.chartView.snp.width)
        }
    }
}
