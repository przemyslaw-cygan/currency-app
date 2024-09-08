import Common
import ComposableArchitecture
import CurrenciesFeature
import CurrencyAPI
import CurrencyAPIData
import Foundation

@Reducer
public struct ConvertFeature: Sendable {
    @Dependency(\.currencyAPIClient) var currencyAPIClient
    @Dependency(\.locale) var locale

    @ObservableState
    public struct State: Equatable {
        public var baseCurrencyID: Currency.ID
        public var currencyID: Currency.ID
        public var value: Int

        public var baseCurrency: Currency?
        public var currency: Currency?

        public var baseCurrencyValue: Double?
        public var currencyValue: Double?

        public var currencies: [Currency.ID: Currency]?
        public var exchangeRates: [Currency.ID: ExchangeRate]?

        @Presents public var destination: Destination.State?

        public init(
            baseCurrencyID: Currency.ID,
            currencyID: Currency.ID,
            value: Int = 0,
            baseCurrency: Currency? = nil,
            baseCurrencyValue: Double? = nil,
            currency: Currency? = nil,
            currencyValue: Double? = nil,
            currencies: [Currency.ID : Currency]? = nil,
            exchangeRates: [Currency.ID : ExchangeRate]? = nil,
            destination: Destination.State? = nil
        ) {
            self.baseCurrencyID = baseCurrencyID
            self.currencyID = currencyID
            self.value = value
            self.baseCurrency = baseCurrency
            self.baseCurrencyValue = baseCurrencyValue
            self.currency = currency
            self.currencyValue = currencyValue
            self.currencies = currencies
            self.exchangeRates = exchangeRates
            self.destination = destination
        }
    }

    public enum Action: ViewAction, Sendable {
        case loadCurrencies
        case loadExchangeRates
        case handleCurrencies(Result<CurrenciesResponse, Error>)
        case handleExchangeRates(Result<LatestResponse, Error>)

        case updateBaseCurrency(Currency.ID)
        case updateCurrency(Currency.ID)
        case updateValue(Int)

        case view(View)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum View: Sendable {
            case onLoad
            case onValueChange(Int)
            case onSwapTapped
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
        case exchangeRates
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

            case .loadExchangeRates:
                return .concatenate(
                    .cancel(id: Cancellable.exchangeRates),
                    .run { [
                        baseCurrencyID = state.baseCurrencyID
                    ] send in
                        await send(.handleExchangeRates(
                            Result {
                                try await self.currencyAPIClient.latest(LatestRequest(baseCurrency: baseCurrencyID))
                            }
                        ))
                    }.cancellable(id: Cancellable.exchangeRates)
                )

            case .handleCurrencies(.success(let response)):
                state.currencies = response.data
                return .concatenate(
                    .run { [id = state.currencyID] in await $0(.updateCurrency(id)) },
                    .run { [id = state.baseCurrencyID] in await $0(.updateBaseCurrency(id)) }
                )

            case .handleExchangeRates(.success(let response)):
                state.exchangeRates = response.data
                return .run { [value = state.value] in await $0(.updateValue(value)) }

            case .handleCurrencies(.failure(let error)),
                 .handleExchangeRates(.failure(let error)):
                state.destination = .alert(AlertState { TextState(error.localizedDescription) })
                return .none

            case .updateBaseCurrency(let id):
                state.baseCurrencyID = id
                state.baseCurrency = state.currencies?[id]
                return .run { await $0(.loadExchangeRates) }

            case .updateCurrency(let id):
                state.currencyID = id
                state.currency = state.currencies?[id]
                return .none

            case .updateValue(let value):
                state.value = value

                guard
                    let exchangeRates = state.exchangeRates,
                    let baseCurrency = state.baseCurrency,
                    let rate = exchangeRates[state.currencyID]?.value
                else {
                    state.currencyValue = nil
                    state.baseCurrencyValue = nil
                    return .none
                }

                let exponent = Double(baseCurrency.decimalDigits)
                state.currencyValue =  Double(value) * pow(10, -exponent) * rate
                state.baseCurrencyValue = Double(value) * pow(10, -exponent)
                return .none

            case .view(.onLoad):
                return .run { await $0(.loadCurrencies) }

            case .view(.onValueChange(let value)):
                return .run { await $0(.updateValue(value)) }

            case .view(.onSwapTapped):
                return .concatenate(
                    .run { [id = state.baseCurrencyID] in await $0(.updateCurrency(id)) },
                    .run { [id = state.currencyID] in await $0(.updateBaseCurrency(id)) }
                )

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
                return .concatenate(
                    .run { await $0(.updateCurrency(id)) },
                    .run { [value = state.value] in await $0(.updateValue(value)) }
                )

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    public init() { }
}
