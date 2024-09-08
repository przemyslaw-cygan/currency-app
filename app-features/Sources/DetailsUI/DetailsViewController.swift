import CommonUI
import ComposableArchitecture
import ConvertUI
import DetailsFeature
import UIKit

@ViewAction(for: DetailsFeature.self)
public class DetailsViewController: ViewController<DetailsView>, UICollectionViewDelegate {
    @UIBindable public var store: StoreOf<DetailsFeature>

    public init(store: StoreOf<DetailsFeature>) {
        self.store = store
        super.init()
    }

    public override func buildView() -> CustomView {
        let view = DetailsView()
        return view
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.observe { [weak self] in
            guard let self else { return }

            self.customView.titleView.label = self.store.currency?.code
            self.customView.currencyView.image = self.store.currency?.image
            self.customView.currencyView.tint = self.store.currency?.color
            self.customView.currencyView.headText = self.store.currency?.code
            self.customView.currencyView.bodyText = self.store.currency?.name

        }

        self.observe { [weak self] in
            guard let self else { return }

            self.endRefreshingIfNeeded()

            self.customView.chartView.data = DetailsChartDataBuilder.build(
                using: self.store.exchangeRates,
                baseCurrency: self.store.baseCurrency,
                dateRange: self.store.selectedDetailsDateRange
            )

            let selectedRange = self.store.selectedDetailsDateRange
            self.customView.buttonViews = self.store.dateRanges.map { range in
                let view = self.customView.buttonView(range.label, range == selectedRange)
                view.on(.touchUpInside) { [weak self] _ in self?.send(.onSelect(range)) }
                return view
            }
        }

        self.present(item: self.$store.scope(state: \.destination?.alert, action: \.destination.alert)) { store in
            UIAlertController(store: store)
        }

        self.navigationDestination(item: self.$store.scope(state: \.destination?.convert, action: \.destination.convert)) { store in
            ConvertViewController(store: store)
        }

        self.customView.convertButton.on(.touchUpInside) { [weak self] _ in
            self?.send(.onConvertTap)
        }

        self.customView.refreshControl.on(.valueChanged) { [weak self] _ in
            self?.send(.onLoad)
        }

        self.send(.onLoad)
    }

    public func endRefreshingIfNeeded() {
        guard self.store.exchangeRates != nil && self.customView.refreshControl.isRefreshing else { return }
        self.customView.refreshControl.endRefreshing()
    }
}

extension DetailsViewController: NavigationAdaptable {
    public var titleItem: UIView? {
        self.customView.titleView
    }

    public var actionItems: [UIView] {
        [self.customView.convertButton]
    }
}

@available(iOS 17, *)
#Preview {
    DetailsViewController(store: Store(
        initialState: DetailsFeature.State(
            baseCurrencyID: "EUR",
            currencyID: "JPY"
        ),
        reducer: { DetailsFeature() }
    ))
}
