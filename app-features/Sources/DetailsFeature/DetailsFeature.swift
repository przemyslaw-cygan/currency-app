import Common
import ComposableArchitecture
import ConvertFeature
import CurrencyAPI
import CurrencyAPIData
import Foundation

@Reducer
public struct DetailsFeature: Sendable {
    @Dependency(\.currencyAPIClient) public var currencyAPIClient
    @Dependency(\.date.now) public var date

    @ObservableState
    public struct State: Equatable {
        public let baseCurrencyID: Currency.ID
        public let currencyID: Currency.ID

        public var dateRanges: [DetailsDateRange]
        public var selectedDetailsDateRange: DetailsDateRange

        public var baseCurrency: Currency?
        public var currency: Currency?

        public var currencies: [Currency.ID: Currency]?
        public var exchangeRates: [Date: ExchangeRate]?

        @Presents public var destination: Destination.State?

        public init(
            baseCurrencyID: Currency.ID,
            currencyID: Currency.ID,
            dateRanges: [DetailsDateRange] = [.week, .month, .year],
            selectedDetailsDateRange: DetailsDateRange = .week,
            baseCurrency: Currency? = nil,
            currency: Currency? = nil,
            currencies: [Currency.ID : Currency]? = nil,
            exchangeRates: [Date : ExchangeRate]? = nil,
            destination: Destination.State? = nil
        ) {
            self.baseCurrencyID = baseCurrencyID
            self.currencyID = currencyID
            self.dateRanges = dateRanges
            self.selectedDetailsDateRange = selectedDetailsDateRange
            self.baseCurrency = baseCurrency
            self.currency = currency
            self.currencies = currencies
            self.exchangeRates = exchangeRates
            self.destination = destination
        }
    }

    public enum Action: ViewAction, Sendable {
        case loadCurrencies
        case loadHistoricalRange
        case handleCurrencies(Result<CurrenciesResponse, Error>)
        case handleHistoricalRange(Result<HistoricalRangeResponse, Error>)

        case view(View)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum View: Sendable {
            case onLoad
            case onConvertTap
            case onSelect(DetailsDateRange)
        }
    }

    @Reducer(state: .equatable, action: .sendable)
    public enum Destination {
        case alert(AlertState<AlertAction>)
        case convert(ConvertFeature)
    }

    public enum AlertAction: Equatable, Sendable {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadCurrencies:
                state.currencies = nil
                return .run { send in
                    await send(.handleCurrencies(
                        Result {
                            try await self.currencyAPIClient.currencies(CurrenciesRequest())
                        }
                    ))
                }

            case .loadHistoricalRange:
                state.exchangeRates = nil
                return .run { [
                    date = self.date.endOfPreviousDay,
                    dateRange = state.selectedDetailsDateRange,
                    baseCurrencyID = state.baseCurrencyID,
                    currencyID = state.currencyID
                ] send in
                    await send(.handleHistoricalRange(
                        Result {
                            let range = try dateRange.dates(for: date)
                            return try await self.currencyAPIClient.historicalRange(HistoricalRangeRequest(
                                dateStart: range.start,
                                dateEnd: range.end,
                                baseCurrency: baseCurrencyID,
                                currencies: [currencyID]
                            ))
                        }
                    ))
                }

            case .handleCurrencies(.success(let response)):
                state.currencies = response.data
                state.baseCurrency = state.currencies?[state.baseCurrencyID]
                state.currency = state.currencies?[state.currencyID]
                return .none

            case .handleHistoricalRange(.success(let response)):
                state.exchangeRates = response.data.reduce(into: [:]) {
                    $0[$1.datetime] = $1.currencies[state.currencyID]?.inverted
                }
                return .none

            case .handleCurrencies(.failure(let error)),
                 .handleHistoricalRange(.failure(let error)):
                state.destination = .alert(AlertState { TextState(error.localizedDescription) })
                return .none

            case .view(.onLoad):
                return .concatenate(
                    .run { await $0(.loadCurrencies) },
                    .run { await $0(.loadHistoricalRange) }
                )

            case .view(.onConvertTap):
                state.destination = .convert(ConvertFeature.State(
                    baseCurrencyID: state.baseCurrencyID,
                    currencyID: state.currencyID
                ))
                return .none

            case .view(.onSelect(let dateRange)):
                state.selectedDetailsDateRange = dateRange
                return .run { await $0(.loadHistoricalRange) }

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
