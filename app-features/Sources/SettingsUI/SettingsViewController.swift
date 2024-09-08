import CommonUI
import ComposableArchitecture
import CurrenciesUI
import SettingsFeature
import UIKit

@ViewAction(for: SettingsFeature.self)
public class SettingsViewController: ViewController<SettingsView>, UICollectionViewDelegate {
    @UIBindable public var store: StoreOf<SettingsFeature>

    public init(store: StoreOf<SettingsFeature>) {
        self.store = store
        super.init()
    }

    public override func buildView() -> CustomView {
        let view = SettingsView()
        return view
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.observe { [weak self] in
            guard let self else { return }

            self.endRefreshingIfNeeded()

            self.customView.baseCurrencyView.image = self.store.baseCurrency?.image
            self.customView.baseCurrencyView.tint = self.store.baseCurrency?.color
            self.customView.baseCurrencyView.headText = self.store.baseCurrency?.code
            self.customView.baseCurrencyView.bodyText = self.store.baseCurrency?.name

            self.customView.currencyView.image = self.store.currency?.image
            self.customView.currencyView.tint = self.store.currency?.color
            self.customView.currencyView.headText = self.store.currency?.code
            self.customView.currencyView.bodyText = self.store.currency?.name
        }

        self.present(item: self.$store.scope(state: \.destination?.alert, action: \.destination.alert)) { store in
            UIAlertController(store: store)
        }

        self.present(item: self.$store.scope(state: \.destination?.baseCurrency, action: \.destination.baseCurrency)) { store in
            NavigationViewController(CurrenciesViewController(store: store))
        }

        self.present(item: self.$store.scope(state: \.destination?.currency, action: \.destination.currency)) { store in
            NavigationViewController(CurrenciesViewController(store: store))
        }

        self.customView.baseCurrencyButton.on(.touchUpInside) { [weak self] _ in
            self?.send(.onBaseCurrencyTapped)
        }

        self.customView.currencyButton.on(.touchUpInside) { [weak self] _ in
            self?.send(.onCurrencyTapped)
        }

        self.customView.refreshControl.on(.valueChanged) { [weak self] _ in
            self?.send(.onLoad)
        }

        self.send(.onLoad)
    }

    public func endRefreshingIfNeeded() {
        guard self.store.currencies != nil && self.customView.refreshControl.isRefreshing else { return }
        self.customView.refreshControl.endRefreshing()
    }
}

extension SettingsViewController: NavigationAdaptable {
    public var titleItem: UIView? {
        self.customView.titleView
    }

    public var actionItems: [UIView] {
        []
    }
}

@available(iOS 17, *)
#Preview {
    SettingsViewController(store: Store(
        initialState: SettingsFeature.State(),
        reducer: { SettingsFeature() }
    ))
}
