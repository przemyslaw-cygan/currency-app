import Common
import ComposableArchitecture
import CurrenciesFeature
import CurrencyAPI
import CurrencyAPIData
import Foundation

@Reducer
public struct SettingsFeature: Sendable {
    @Dependency(\.currencyAPIClient) public var currencyAPIClient

    @ObservableState
    public struct State: Equatable {
        @Shared(.baseCurrencyID) public var baseCurrencyID: Currency.ID = .defaultBaseCurrencyID
        @Shared(.currencyID) public var currencyID: Currency.ID = .defaultCurrencyID

        public var baseCurrency: Currency?
        public var currency: Currency?

        public var currencies: [Currency.ID: Currency]?

        @Presents public var destination: Destination.State?

        public init(
            baseCurrency: Currency? = nil,
            currency: Currency? = nil,
            currencies: [Currency.ID : Currency]? = nil,
            destination: Destination.State? = nil
        ) {
            self.baseCurrency = baseCurrency
            self.currency = currency
            self.currencies = currencies
            self.destination = destination
        }
    }

    public enum Action: ViewAction, Sendable {
        case loadCurrencies
        case handleCurrencies(Result<CurrenciesResponse, Error>)

        case updateBaseCurrency(Currency.ID)
        case updateCurrency(Currency.ID)

        case view(View)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum View: Sendable {
            case onLoad
            case onBaseCurrencyTapped
            case onCurrencyTapped
        }
    }

    @Reducer(state: .equatable, action: .sendable)
    public enum Destination {
        case alert(AlertState<AlertAction>)
        case baseCurrency(CurrenciesFeature)
        case currency(CurrenciesFeature)
    }

    public enum AlertAction: Equatable, Sendable {}

    enum Cancellable: Hashable {
        case currencies
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadCurrencies:
                return .concatenate(
                    .cancel(id: Cancellable.currencies),
                    .run { send in
                        await send(.handleCurrencies(
                            Result {
                                try await self.currencyAPIClient.currencies(CurrenciesRequest())
                            }
                        ))
                    }.cancellable(id: Cancellable.currencies)
                )

            case .handleCurrencies(.success(let response)):
                state.currencies = response.data
                return .merge(
                    .run { [id = state.currencyID] in await $0(.updateCurrency(id)) },
                    .run { [id = state.baseCurrencyID] in await $0(.updateBaseCurrency(id)) }
                )

            case .handleCurrencies(.failure(let error)):
                state.destination = .alert(AlertState { TextState(error.localizedDescription) })
                return .none

            case .updateBaseCurrency(let id):
                state.baseCurrencyID = id
                state.baseCurrency = state.currencies?[id]
                return .none

            case .updateCurrency(let id):
                state.currencyID = id
                state.currency = state.currencies?[id]
                return .none

            case .view(.onLoad):
                return .run { await $0(.loadCurrencies) }

            case .view(.onBaseCurrencyTapped):
                state.destination = .baseCurrency(CurrenciesFeature.State())
                return .none

            case .view(.onCurrencyTapped):
                state.destination = .currency(CurrenciesFeature.State())
                return .none

            case .destination(.presented(.baseCurrency(.view(.onSelect(let id))))):
                state.destination = nil
                return .run { await $0(.updateBaseCurrency(id)) }

            case .destination(.presented(.currency(.view(.onSelect(let id))))):
                state.destination = nil
                return .run { await $0(.updateCurrency(id)) }

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    public init() { }
}
