import Common
import ComposableArchitecture
import ConvertFeature
import CurrencyAPIData
import ExchangeRatesFeature
import Foundation
import SettingsFeature

@Reducer
public struct MainFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        @Shared(.baseCurrencyID) public var baseCurrencyID: Currency.ID = .defaultBaseCurrencyID
        @Shared(.currencyID) public var currencyID: Currency.ID = .defaultCurrencyID

        public var exchangeRatesTab: ExchangeRatesFeature.State!
        public var convertTab: ConvertFeature.State!
        public var settingsTab: SettingsFeature.State!

        public var tabs: [Tab]
        public var selectedTab: Tab

        public init(
            tabs: [Tab] = [.exchangeRates, .convert, .settings],
            selectedTab: Tab = .exchangeRates
        ) {
            self.tabs = tabs
            self.selectedTab = selectedTab

            self.exchangeRatesTab = ExchangeRatesFeature.State(baseCurrencyID: self.baseCurrencyID)
            self.convertTab = ConvertFeature.State(baseCurrencyID: self.baseCurrencyID, currencyID: self.currencyID)
            self.settingsTab = SettingsFeature.State()
        }
    }

    public enum Action: ViewAction, Sendable {
        case exchangeRatesTab(ExchangeRatesFeature.Action)
        case convertTab(ConvertFeature.Action)
        case settingsTab(SettingsFeature.Action)
        case view(ViewAction)
        case updateBaseCurrencyID(Currency.ID)
        case updateCurrencyID(Currency.ID)

        @CasePathable
        public enum ViewAction: Sendable {
            case onLoad
            case onSelect(Tab)
        }
    }

    public enum Tab: Hashable, Sendable {
        case exchangeRates
        case convert
        case settings
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .exchangeRatesTab:
                return .none

            case .convertTab:
                return .none

            case .settingsTab:
                return .none

            case .updateBaseCurrencyID(let id):
                return .merge(
                    .run { await $0(.exchangeRatesTab(.updateBaseCurrency(id))) },
                    .run { await $0(.convertTab(.updateBaseCurrency(id))) }
                )

            case .updateCurrencyID(let id):
                return .run { await $0(.convertTab(.updateCurrency(id))) }

            case .view(.onLoad):
                return .merge(
                    .publisher { state.$baseCurrencyID.publisher.map { .updateBaseCurrencyID($0) } },
                    .publisher { state.$currencyID.publisher.map { .updateCurrencyID($0) } }
                )

            case .view(.onSelect(let tab)):
                state.selectedTab = tab
                return .none
            }
        }
        Scope(state: \.exchangeRatesTab, action: \.exchangeRatesTab) { ExchangeRatesFeature() }
        Scope(state: \.convertTab, action: \.convertTab) { ConvertFeature() }
        Scope(state: \.settingsTab, action: \.settingsTab) { SettingsFeature() }
    }

    public init() { }
}
