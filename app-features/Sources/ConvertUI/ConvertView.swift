import AppUIComponents
import Overture
import SnapKit
import UIKit

public class ConvertView: CustomView {
    public let numpadHeight: CGFloat = 280
    public let refreshControl = UIRefreshControl()

    public let titleView = with(
        HeaderView(),
        concat(
            Styler.Text.stylePrimary(Styler.Size.L),
            set(\.label, "Convert")
        )
    )

    public lazy var contentWrapperView = with(
        UIScrollView(),
        concat(
            set(\.refreshControl, Optional(self.refreshControl)),
            set(\.showsVerticalScrollIndicator, false),
            set(\.showsHorizontalScrollIndicator, false)
        )
    )

    public let baseCurrencyInputView = with(
        FieldView(),
        concat(
            Styler.Field.styleDefault(Styler.Size.L),
            Styler.elevated(1),
            set(\.fieldView.wv.isEnabled, false),
            set(\.fieldView.wv.textAlignment, .right)
        )
    )

    public let baseCurrencySymbolView = with(
        ButtonView(),
        Styler.Button.styleSecondary(Styler.Size.L)
    )

    public let currencyInputView = with(
        FieldView(),
        concat(
            Styler.Field.styleDefault(Styler.Size.L),
            Styler.elevated(1),
            set(\.fieldView.wv.isEnabled, false),
            set(\.fieldView.wv.textAlignment, .right)
        )
    )

    public let currencySymbolView = with(
        ButtonView(),
        Styler.Button.styleSecondary(Styler.Size.L)
    )

    public let swapButton = with(
        ButtonView(),
        concat(
            Styler.Button.stylePrimary(Styler.Size.M),
            Styler.elevated(1),
            set(\.icon, UIImage(systemName: "arrow.up.arrow.down"))
        )
    )

    public let collectionWrapperView = with(
        UIView(),
        concat(
            Styler.elevated(3),
            set(\.backgroundColor, Styler.Color.backgroundPrimary)
        )
    )

    public let collectionLayout: UICollectionViewLayout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
        let size = layoutEnvironment.container.contentSize
        let spacing = Styler.Size.spacing

        let itemWidth: CGFloat = (size.width - 4 * spacing ) / 3
        let itemHeight: CGFloat = (size.height - 5 * spacing) / 4

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(itemHeight)
        )

        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(3 * itemWidth + 2 * spacing),
            heightDimension: .absolute(itemHeight)
        )

        let groupLayout = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [itemLayout, itemLayout, itemLayout]
        )

        groupLayout.interItemSpacing = .fixed(spacing)

        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        sectionLayout.interGroupSpacing = spacing
        sectionLayout.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )

        return sectionLayout
    }

    public lazy var collectionView = with(
        UICollectionView(
            frame: .zero,
            collectionViewLayout: self.collectionLayout
        ),
        concat(
            set(\.backgroundColor, .clear),
            set(\.showsVerticalScrollIndicator, false),
            set(\.showsHorizontalScrollIndicator, false),
            set(\.isScrollEnabled, false)
        )
    )

    public override init() {
        super.init()

        self.backgroundColor = Styler.Color.backgroundPrimary
        self.baseCurrencyInputView.accessoryViews = [self.baseCurrencySymbolView]
        self.currencyInputView.accessoryViews = [self.currencySymbolView]

        self.addSubviews([
            self.contentWrapperView.addSubviews([
                self.baseCurrencyInputView,
                self.swapButton,
                self.currencyInputView,
            ]),
            self.collectionWrapperView.addSubviews([
                self.collectionView,
            ]),
        ])

        self.contentWrapperView.snp.makeConstraints {
            $0.top.left.right.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.collectionWrapperView.snp.top)
        }

        self.collectionWrapperView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-self.numpadHeight)
            $0.bottom.left.right.equalToSuperview()
        }

        self.collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }

        self.baseCurrencyInputView.snp.makeConstraints {
            $0.centerX.equalTo(self.swapButton)
            $0.bottom.equalTo(self.swapButton.snp.top).offset(-2 * Styler.Size.spacing)
            $0.width.equalTo(self.numpadHeight).priority(900)
            $0.width.lessThanOrEqualToSuperview().inset(2 * Styler.Size.spacing)
        }

        self.swapButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        self.currencyInputView.snp.makeConstraints {
            $0.centerX.equalTo(self.swapButton)
            $0.top.equalTo(self.swapButton.snp.bottom).offset(2 * Styler.Size.spacing)
            $0.width.equalTo(self.numpadHeight).priority(900)
            $0.width.lessThanOrEqualToSuperview().inset(2 * Styler.Size.spacing)
        }
    }
}
