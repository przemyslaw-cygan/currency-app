import CommonUI
import ComposableArchitecture
import ConvertUI
import ExchangeRatesUI
import MainFeature
import SettingsUI
import UIKit

@ViewAction(for: MainFeature.self)
public class MainViewController: ViewController<MainView>, UICollectionViewDelegate {
    public var store: StoreOf<MainFeature>

    public let controller = UINavigationController()
    public var availableViewControllers: [MainFeature.Tab: UIViewController] = [:]

    public init(store: StoreOf<MainFeature>) {
        self.store = store
        super.init()
    }

    public override func buildView() -> CustomView {
        let view = MainView(with: self.controller)
        self.addChild(self.controller)
        return view
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.observe { [weak self] in
            guard let self else { return }

            let selectedTab = self.store.selectedTab
            self.customView.buttonViews = self.store.tabs.map { tab in
                let view = self.customView.buttonView(tab.icon, tab == selectedTab)
                view.on(.touchUpInside) { [weak self] _ in self?.send(.onSelect(tab)) }
                return view
            }
        }

        self.observe { [weak self] in
            guard let self else { return }

            let viewController = self.viewController(
                for: self.store.selectedTab,
                using: self.store,
                availableViewControllers: &self.availableViewControllers
            )

            self.controller.setViewControllers([viewController], animated: false)
        }

        self.send(.onLoad)
    }

    public func viewController(
        for tab: MainFeature.Tab,
        using store: StoreOf<MainFeature>,
        availableViewControllers: inout [MainFeature.Tab: UIViewController]
    ) -> UIViewController {
        if let viewController = availableViewControllers[tab] {
            return viewController
        }

        let viewController = switch tab {
        case .exchangeRates:
            ExchangeRatesViewController(store: store.scope(state: \.exchangeRatesTab, action: \.exchangeRatesTab))
        case .convert:
            ConvertViewController(store: store.scope(state: \.convertTab, action: \.convertTab))
        case .settings:
            SettingsViewController(store: store.scope(state: \.settingsTab, action: \.settingsTab))
        }

        let mainViewController = NavigationViewController(viewController)
        availableViewControllers[tab] = mainViewController
        return mainViewController
    }
}

fileprivate extension MainFeature.Tab {
    var icon: UIImage? {
        switch self {
        case .convert:
            UIImage(systemName: "arrow.up.arrow.down")
        case .exchangeRates:
            UIImage(systemName: "chart.line.uptrend.xyaxis")
        case .settings:
            UIImage(systemName: "gear")
        }
    }
}

@available(iOS 17, *)
#Preview {
    MainViewController(store: Store(
        initialState: MainFeature.State(),
        reducer: { MainFeature() }
    ))
}
