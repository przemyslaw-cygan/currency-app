import CommonUI
import ComposableArchitecture
import DetailsUI
import ExchangeRatesFeature
import UIKit

@ViewAction(for: ExchangeRatesFeature.self)
public class ExchangeRatesViewController: ViewController<ExchangeRatesView>, UICollectionViewDelegate {
    @UIBindable public var store: StoreOf<ExchangeRatesFeature>

    lazy var collectionSource = {
        let itemCellRegistration = ExchangeRatesItemCellBuilder.cellRegistration
        let placeholderCellRegistration = ExchangeRatesPlaceholderCellBuilder.cellRegistration

        return CollectionSource<ExchangeRatesCollectionSection>(
            collectionView: self.customView.collectionView,
            cellProvider: { collectionView, indexPath, model in
                switch model {
                case .item(let currencyExchangeRate):
                    collectionView.dequeueConfiguredReusableCell(using: itemCellRegistration, for: indexPath, item: currencyExchangeRate)
                case .placeholder:
                    collectionView.dequeueConfiguredReusableCell(using: placeholderCellRegistration, for: indexPath, item: ())
                }
            }
        )
    }()

    public init(store: StoreOf<ExchangeRatesFeature>) {
        self.store = store
        super.init()
    }

    public override func buildView() -> CustomView {
        let view = ExchangeRatesView()
        view.collectionView.delegate = self
        return view
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.observe { [weak self] in
            guard let self else { return }

            self.endRefreshingIfNeeded()

            self.customView.searchView.text = self.store.searchPhrase
            self.collectionSource.apply(
                ExchangeRatesCollectionSection.snapshot(for: self.store.filteredItems),
                animatingDifferences: true
            )
        }

        self.present(item: self.$store.scope(state: \.destination?.alert, action: \.destination.alert)) { store in
            UIAlertController(store: store)
        }

        self.navigationDestination(item: self.$store.scope(state: \.destination?.details, action: \.destination.details)) { store in
            DetailsViewController(store: store)
        }

        self.customView.searchButton.on(.touchUpInside) { [weak self] _ in
            guard let searchView = self?.customView.searchView else { return }
            searchView.fieldView.isHidden.toggle()
            _ = searchView.fieldView.isHidden
                ? searchView.field.resignFirstResponder()
                : searchView.field.becomeFirstResponder()
        }

        self.customView.searchView.field.on(.editingChanged) { [weak self] in
            self?.send(.onSearch(($0.sender as? UITextField)?.text))
        }

        self.customView.refreshControl.on(.valueChanged) { [weak self] _ in
            self?.send(.onLoad)
        }

        self.send(.onLoad)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.collectionSource.itemIdentifier(for: indexPath) {
        case .item(let currencyExchangeRate):
            self.send(.onSelect(currencyExchangeRate.id))
        case .placeholder:
            break
        case .none:
            break
        }
    }

    public func endRefreshingIfNeeded() {
        guard self.store.filteredItems != nil && self.customView.refreshControl.isRefreshing else { return }
        self.customView.refreshControl.endRefreshing()
    }
}

extension ExchangeRatesViewController: NavigationAdaptable {
    public var titleItem: UIView? {
        self.customView.titleView
    }

    public var actionItems: [UIView] {
        [self.customView.searchView]
    }
}

@available(iOS 17, *)
#Preview {
    ExchangeRatesViewController(store: Store(
        initialState: ExchangeRatesFeature.State(
            baseCurrencyID: "EUR"
        ),
        reducer: { ExchangeRatesFeature() }
    ))
}
