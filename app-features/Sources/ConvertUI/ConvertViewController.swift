import CommonUI
import ComposableArchitecture
import ConvertFeature
import CurrenciesFeature
import CurrenciesUI
import UIKit

@ViewAction(for: ConvertFeature.self)
public class ConvertViewController: ViewController<ConvertView>, UICollectionViewDelegate {
    @UIBindable public var store: StoreOf<ConvertFeature>

    public lazy var collectionSource = {
        let cellRegistration = ConvertKeyCellBuilder.cellRegistration

        return CollectionSource<ConvertCollectionSection>(
            collectionView: self.customView.collectionView,
            cellProvider: { collectionView, indexPath, model in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
            }
        )
    }()

    public init(store: StoreOf<ConvertFeature>) {
        self.store = store
        super.init()
    }

    public override func buildView() -> CustomView {
        let view = ConvertView()
        view.collectionView.delegate = self
        return view
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.observe { [weak self] in
            guard let self else { return }

            self.endRefreshingIfNeeded()

            self.customView.baseCurrencyInputView.text = self.store.baseCurrency?.format(.current, self.store.baseCurrencyValue ?? 0)
            self.customView.baseCurrencySymbolView.label = self.store.baseCurrency?.code
            self.customView.currencyInputView.text = self.store.currency?.format(.current, self.store.currencyValue ?? 0)
            self.customView.currencySymbolView.label = self.store.currency?.code
        }

        self.present(item: self.$store.scope(state: \.destination?.baseCurrency, action: \.destination.baseCurrency)) { store in
            NavigationViewController(CurrenciesViewController(store: store))
        }

        self.present(item: self.$store.scope(state: \.destination?.currency, action: \.destination.currency)) { store in
            NavigationViewController(CurrenciesViewController(store: store))
        }

        self.collectionSource.apply(ConvertCollectionSection.snapshot())

        self.customView.swapButton.on(.touchUpInside) { [weak self] _ in
            self?.send(.onSwapTapped)
        }

        self.customView.baseCurrencySymbolView.on(.touchUpInside) { [weak self] _ in
            self?.send(.onBaseCurrencyTapped)
        }

        self.customView.currencySymbolView.on(.touchUpInside) { [weak self] _ in
            self?.send(.onCurrencyTapped)
        }

        self.customView.refreshControl.on(.valueChanged) { [weak self] _ in
            self?.send(.onLoad)
        }

        self.send(.onLoad)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var value = self.store.value

        switch self.collectionSource.itemIdentifier(for: indexPath) {
        case .number(let number):
            value = value * 10 + number
            self.send(.onValueChange(value))

        case .zero(let count):
            value = value * Int(pow(10, Double(count)))
            self.send(.onValueChange(value))

        case .clear:
            value /= 10
            self.send(.onValueChange(value))

        case .none:
            break
        }
    }

    public func endRefreshingIfNeeded() {
        guard self.store.exchangeRates != nil && self.customView.refreshControl.isRefreshing else { return }
        self.customView.refreshControl.endRefreshing()
    }
}

extension ConvertViewController: NavigationAdaptable {
    public var titleItem: UIView? {
        self.customView.titleView
    }

    public var actionItems: [UIView] {
        []
    }
}

@available(iOS 17, *)
#Preview {
    ConvertViewController(store: Store(
        initialState: ConvertFeature.State(
            baseCurrencyID: "EUR",
            currencyID: "JPY"
        ),
        reducer: { ConvertFeature() }
    ))
}
