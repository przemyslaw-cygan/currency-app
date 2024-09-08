import ComposableArchitecture
import CurrenciesFeature
import CurrencyAPI
import CurrencyAPIData
import CurrencyAPIStub
import XCTest

@MainActor
final class CurrenciesFeatureTests: XCTestCase {
    func testFlow_Succes() async throws {

        // MARK: store

        let store = TestStore(initialState: CurrenciesFeature.State()) {
            CurrenciesFeature()
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
                latest: { _ in fatalError() },
                status: { _ in fatalError() }
            )
        }

        // ---


        // MARK: onLoad

        await store.send(\.view.onLoad)

        await store.receive(\.loadItems)

        await store.receive(\.handleItems.success)

        await store.receive(\.updateItems) {
            $0.items = Stubs.sortedCurrencies
            $0.filteredItems = Stubs.sortedCurrencies
        }


        // MARK: onSearch

        await store.send(\.view.onSearch, "CHF")

        await store.receive(\.updateSearchPhrase) {
            $0.searchPhrase = "CHF"
            $0.filteredItems = [Stubs.currencyCHF]
        }
    }

    func testFlow_Failure() async throws {

        // MARK: store

        let store = TestStore(initialState: CurrenciesFeature.State()) {
            CurrenciesFeature()
        } withDependencies: {
            $0.currencyAPIClient.currencies = { _ in
                throw SomeError.error
            }
        }

        // ---


        // MARK: onLoad

        await store.send(\.view.onLoad)

        await store.receive(\.loadItems)

        await store.receive(\.handleItems.failure) {
            $0.destination = .alert(AlertState(title: { TextState("Some Error") }))
        }
    }
}


fileprivate enum Stubs {
    static let currencies = [
        Self.currencyCHF,
        Self.currencyBTC,
        Self.currencyXAU,
        Self.currencyEUR,
        Self.currencyUSD,
    ].reduce(into: [:]) { $0[$1.id] = $1 }


    static let sortedCurrencies = [
        Self.currencyCHF,
        Self.currencyEUR,
        Self.currencyUSD,
        Self.currencyXAU,
        Self.currencyBTC,
    ]

    static let currencyCHF = StubCurrencies.CHF
    static let currencyBTC = StubCurrencies.BTC
    static let currencyXAU = StubCurrencies.XAU
    static let currencyEUR = StubCurrencies.EUR
    static let currencyUSD = StubCurrencies.USD
}

fileprivate enum SomeError: Error, LocalizedError {
    case error
    var errorDescription: String? {
        "Some Error"
    }
}
