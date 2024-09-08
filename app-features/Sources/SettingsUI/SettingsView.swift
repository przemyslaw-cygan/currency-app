import AppUIComponents
import Overture
import SnapKit
import UIKit

public class SettingsView: CustomView {
    public let refreshControl = UIRefreshControl()

    public let titleView = with(
        HeaderView(),
        concat(
            Styler.Text.stylePrimary(Styler.Size.L),
            set(\.label, "Settings")
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
            set(\.spacing, Styler.Size.spacing),
            set(\.isLayoutMarginsRelativeArrangement, true)
        )
    )

    public let baseCurrencyLabel = with(
        HeaderView(),
        concat(
            Styler.Text.stylePrimary(Styler.Size.S),
            set(\.label, "Base currency")
        )
    )

    public lazy var baseCurrencyView = with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.elevated(1),
            set(\.accessoryViews, [self.baseCurrencyButton])
        )
    )

    public let baseCurrencyButton = with(
        ButtonView(),
        concat(
            Styler.Button.styleSecondary(Styler.Size.S),
            set(\.label, "Change")
        )
    )

    public let currencyLabel = with(
        HeaderView(),
        concat(
            Styler.Text.stylePrimary(Styler.Size.S),
            set(\.label, "Preferred currency")
        )
    )

    public lazy var currencyView = with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.elevated(1),
            set(\.accessoryViews, [self.currencyButton])
        )
    )

    public let currencyButton = with(
        ButtonView(),
        concat(
            Styler.Button.styleSecondary(Styler.Size.S),
            set(\.label, "Change")
        )
    )

    public override init() {
        super.init()

        self.backgroundColor = Styler.Color.backgroundPrimary

        self.addSubviews([
            self.scrollView.addSubviews([
                self.stackView.addArrangedSubviews([
                    self.baseCurrencyLabel,
                    self.baseCurrencyView,
                    self.currencyLabel,
                    self.currencyView,
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
    }
}
