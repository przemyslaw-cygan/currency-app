import ComposableArchitecture
import ConvertFeature
import CurrenciesFeature
import CurrencyAPI
import CurrencyAPIData
import CurrencyAPIStub
import XCTest

@MainActor
final class ConvertFeatureTests: XCTestCase {
    func testFlow_Succes() async throws {

        // MARK: store

        let store = TestStore(initialState: ConvertFeature.State(
            baseCurrencyID: Stubs.currencyCHF.id,
            currencyID: Stubs.currencyBTC.id,
            value: 0
        )) {
            ConvertFeature()
        } withDependencies: {
            $0.currencyAPIClient = Client(
                convert: { _ in fatalError() },
                currencies:  { _ in
                    CurrenciesResponse(
                        data: Stubs.currencies
                    )
                },
                historical: { _ in fatalError() },
                historicalRange: { _ in fatalError() },
                latest: { request in
                    LatestResponse(
                        meta: ResponseMeta(lastUpdatedAt: Date(timeIntervalSince1970: 0)),
                        data: Stubs.exchangeRates(request.baseCurrency)
                    )
                },
                status: { _ in fatalError() }
            )
        }

        // ---


        // MARK: onLoad

        await store.send(\.view.onLoad)

        await store.receive(\.loadCurrencies)

        await store.receive(\.handleCurrencies.success) {
            $0.currencies = Stubs.currencies
        }

        await store.receive(\.updateCurrency) {
            $0.currency = Stubs.currencyBTC
        }

        await store.receive(\.updateBaseCurrency) {
            $0.baseCurrency = Stubs.currencyCHF
        }

        await store.receive(\.loadExchangeRates)

        await store.receive(\.handleExchangeRates.success) {
            $0.exchangeRates = Stubs.exchangeRatesCHF
        }

        await store.receive(\.updateValue) {
            $0.baseCurrencyValue = 0
            $0.currencyValue = 0
        }


        // MARK: onValueChange

        await store.send(\.view.onValueChange, 123)

        await store.receive(\.updateValue) {
            $0.value = 123
            $0.baseCurrencyValue = 1.23
            $0.currencyValue = 12300
        }


        // MARK: onSwapTapped

        await store.send(\.view.onSwapTapped)

        await store.receive(\.updateCurrency) {
            $0.currencyID = Stubs.currencyCHF.id
            $0.currency = Stubs.currencyCHF
        }

        await store.receive(\.updateBaseCurrency) {
            $0.baseCurrencyID = Stubs.currencyBTC.id
            $0.baseCurrency = Stubs.currencyBTC
        }

        await store.receive(\.loadExchangeRates)

        await store.receive(\.handleExchangeRates.success) {
            $0.exchangeRates = Stubs.exchangeRatesBTC
        }

        await store.receive(\.updateValue) {
            $0.baseCurrencyValue = 0.00000123
            $0.currencyValue = 0.00000000123
        }


        // MARK: onCurrencyTapped

        await store.send(\.view.onCurrencyTapped) {
            $0.destination = .currency(CurrenciesFeature.State())
        }

        await store.send(\.destination.currency.view.onSelect, Stubs.currencyXAU.id) {
            $0.destination = nil
        }

        await store.receive(\.updateCurrency) {
            $0.currencyID = Stubs.currencyXAU.id
            $0.currency = Stubs.currencyXAU
        }

        await store.receive(\.updateValue) {
            $0.currencyValue = 0.00000000246
        }


        // MARK: onBaseCurrencyTapped

        await store.send(\.view.onBaseCurrencyTapped) {
            $0.destination = .baseCurrency(CurrenciesFeature.State())
        }

        await store.send(\.destination.baseCurrency.view.onSelect, Stubs.currencyCHF.id) {
            $0.destination = nil
        }

        await store.receive(\.updateBaseCurrency) {
            $0.baseCurrencyID = Stubs.currencyCHF.id
            $0.baseCurrency = Stubs.currencyCHF
        }

        await store.receive(\.loadExchangeRates)

        await store.receive(\.handleExchangeRates.success) {
            $0.exchangeRates = Stubs.exchangeRatesCHF
        }

        await store.receive(\.updateValue) {
            $0.baseCurrencyValue = 1.23
            $0.currencyValue = 246
        }


        // MARK: onValueChange

        await store.send(\.view.onValueChange, 2200)

        await store.receive(\.updateValue) {
            $0.value = 2200
            $0.baseCurrencyValue = 22
            $0.currencyValue = 4400
        }
    }

    func testFlow_Failure() async throws {

        // MARK: store

        let store = TestStore(initialState: ConvertFeature.State(
            baseCurrencyID: Stubs.currencyCHF.id,
            currencyID: Stubs.currencyBTC.id,
            value: 0
        )) {
            ConvertFeature()
        } withDependencies: {
            $0.currencyAPIClient.currencies = { _ in
                throw SomeError.error
            }
        }

        // ---


        // MARK: onLoad

        await store.send(\.view.onLoad)

        await store.receive(\.loadCurrencies)

        await store.receive(\.handleCurrencies.failure) {
            $0.destination = .alert(AlertState(title: { TextState("Some Error") }))
        }
    }
}


fileprivate enum Stubs {
    static let currencies = [
        Self.currencyCHF,
        Self.currencyBTC,
        Self.currencyXAU,
    ].reduce(into: [:]) { $0[$1.id] = $1 }

    static let exchangeRates: (Currency.ID?) -> [Currency.ID: ExchangeRate] = { id in
        switch id {
        case Self.currencyCHF.id:
            Stubs.exchangeRatesCHF

        case Self.currencyBTC.id:
            Stubs.exchangeRatesBTC

        case Self.currencyXAU.id:
            Stubs.exchangeRatesXAU

        default:
            fatalError()
        }
    }

    static let currencyCHF = StubCurrencies.CHF
    static let currencyBTC = StubCurrencies.BTC
    static let currencyXAU = StubCurrencies.XAU

    static let exchangeRatesCHF = [
        ExchangeRate(code: Self.currencyCHF.id, value: 1),
        ExchangeRate(code: Self.currencyBTC.id, value: 10000),
        ExchangeRate(code: Self.currencyXAU.id, value: 200),
    ].reduce(into: [:]) { $0[$1.id] = $1 }

    static let exchangeRatesBTC = [
        ExchangeRate(code: Self.currencyCHF.id, value: 0.001),
        ExchangeRate(code: Self.currencyBTC.id, value: 1),
        ExchangeRate(code: Self.currencyXAU.id, value: 0.002),
    ].reduce(into: [:]) { $0[$1.id] = $1 }

    static let exchangeRatesXAU = [
        ExchangeRate(code: Self.currencyCHF.id, value: 0.005),
        ExchangeRate(code: Self.currencyBTC.id, value: 200),
        ExchangeRate(code: Self.currencyXAU.id, value: 1),
    ].reduce(into: [:]) { $0[$1.id] = $1 }
}

fileprivate enum SomeError: Error, LocalizedError {
    case error
    var errorDescription: String? {
        "Some Error"
    }
}
