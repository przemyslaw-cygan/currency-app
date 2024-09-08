import AppUIComponents
import Overture
import SnapKit
import UIKit

public class ExchangeRatesView: CustomView {
    public let refreshControl = UIRefreshControl()

    public let titleView = with(
        HeaderView(),
        concat(
            Styler.Text.stylePrimary(Styler.Size.L),
            set(\.label, "Exchange rates")
        )
    )

    public lazy var searchView = with(
        FieldView(),
        concat(
            Styler.Field.styleDefault(Styler.Size.L),
            set(\.fieldView.wv.clearButtonMode, .always),
            set(\.placeholder, "Search..."),
            set(\.accessoryViews, [self.searchButton]),
            set(\.fieldView.isHidden, true)
        )
    )

    public let searchButton = with(
        ButtonView(),
        concat(
            Styler.Button.styleSecondary(Styler.Size.L),
            set(\.icon, UIImage(systemName: "magnifyingglass"))
        )
    )

    public let collectionLayout: UICollectionViewLayout = UICollectionViewCompositionalLayout { _, _ in
        let spacing = Styler.Size.spacing
        let height = 5 * Styler.Size.S

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(height)
        )

        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(height)
        )

        let groupLayout = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [itemLayout]
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

    public var collectionRefreshControl = UIRefreshControl()

    public lazy var collectionView = with(
        UICollectionView(
            frame: .zero,
            collectionViewLayout: self.collectionLayout
        ),
        concat(
            set(\.backgroundColor, .clear),
            set(\.refreshControl, Optional(self.refreshControl)),
            set(\.showsVerticalScrollIndicator, false),
            set(\.showsHorizontalScrollIndicator, false)
        )
    )

    public override init() {
        super.init()

        self.backgroundColor = Styler.Color.backgroundPrimary

        self.addSubviews([
            self.collectionView,
        ])

        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
