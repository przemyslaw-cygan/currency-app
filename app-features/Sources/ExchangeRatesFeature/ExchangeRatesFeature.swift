import Common
import ComposableArchitecture
import CurrencyAPI
import CurrencyAPIData
import DetailsFeature
import Foundation

@Reducer
public struct ExchangeRatesFeature: Sendable {
    @Dependency(\.currencyAPIClient) public var currencyAPIClient

    @ObservableState
    public struct State: Equatable {
        public var baseCurrencyID: Currency.ID
        public var searchPhrase: String?

        public var items: [ExchangeRatesItem]?
        public var filteredItems: [ExchangeRatesItem]?

        public var currencies: [Currency.ID: Currency]?
        public var exchangeRates: [Currency.ID: ExchangeRate]?

        @Presents public var destination: Destination.State?

        public init(
            baseCurrencyID: Currency.ID,
            searchPhrase: String? = nil,
            items: [ExchangeRatesItem]? = nil,
            filteredItems: [ExchangeRatesItem]? = nil,
            currencies: [Currency.ID : Currency]? = nil,
            exchangeRates: [Currency.ID : ExchangeRate]? = nil,
            destination: Destination.State? = nil
        ) {
            self.baseCurrencyID = baseCurrencyID
            self.searchPhrase = searchPhrase
            self.items = items
            self.filteredItems = filteredItems
            self.currencies = currencies
            self.exchangeRates = exchangeRates
            self.destination = destination
        }
    }

    public enum Action: ViewAction, Sendable {
        case loadItems
        case handleItems(Result<[ExchangeRatesItem], Error>)

        case updateBaseCurrency(Currency.ID)
        case updateItems([ExchangeRatesItem]?)
        case updateSearchPhrase(String?)

        case view(View)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum View: Equatable, Sendable {
            case onLoad
            case onSearch(String?)
            case onSelect(Currency.ID)
        }
    }

    @Reducer(state: .equatable, action: .sendable)
    public enum Destination {
        case alert(AlertState<AlertAction>)
        case details(DetailsFeature)
    }

    public enum AlertAction: Equatable, Sendable {}

    enum Cancellable: Hashable {
        case currencies
        case exchangeRates
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadItems:
                return .concatenate(
                    .cancel(id: Cancellable.currencies),
                    .run { [
                        baseCurrencyID = state.baseCurrencyID
                    ] send in
                        await send(.handleItems(
                            Result {
                                let currencies = try await self.currencyAPIClient.currencies(CurrenciesRequest()).data
                                let exchangeRates = try await self.currencyAPIClient.latest(LatestRequest(baseCurrency: baseCurrencyID)).data

                                return currencies.values.compactMap {
                                    guard
                                        let exchangeRate = exchangeRates[$0.id],
                                        let baseCurrency = currencies[baseCurrencyID]
                                    else { return nil }
                                    return ExchangeRatesItem(
                                        baseCurrency: baseCurrency,
                                        currency: $0,
                                        exchangeRate: exchangeRate.inverted
                                    )
                                }
                            }
                        ))
                    }.cancellable(id: Cancellable.currencies)
                )

            case .handleItems(.success(let items)):
                return .run { await $0(.updateItems(items)) }

            case .handleItems(.failure(let error)):
                state.destination = .alert(AlertState { TextState(error.localizedDescription) })
                return .none

            case .updateBaseCurrency(let id):
                state.baseCurrencyID = id
                return .run { await $0(.loadItems) }

            case .updateItems(let items):
                state.items = items?.sorted(by: { $0.currency.order < $1.currency.order })
                state.filteredItems = state.items?.filter {
                    $0.currency.id != state.baseCurrencyID
                    && $0.currency.match(state.searchPhrase)
                }
                return .none

            case .updateSearchPhrase(let searchPhrase):
                state.filteredItems = state.items?.filter {
                    $0.currency.id != state.baseCurrencyID
                    && $0.currency.match(searchPhrase)
                }
                state.searchPhrase = searchPhrase
                return .none

            case .view(.onLoad):
                return .run { await $0(.loadItems) }

            case .view(.onSearch(let searchPhrase)):
                return .run { await $0(.updateSearchPhrase(searchPhrase)) }

            case .view(.onSelect(let id)):
                state.destination = .details(DetailsFeature.State(
                    baseCurrencyID: state.baseCurrencyID,
                    currencyID: id
                ))
                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    public init() { }
}

fileprivate extension ExchangeRate {
    var inverted: Self {
        ExchangeRate(code: self.id, value: 1 / self.value)
    }
}
