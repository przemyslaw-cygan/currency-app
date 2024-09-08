import CurrencyAPIData
import Foundation

public struct ExchangeRatesItem: Hashable, Equatable, Sendable, Identifiable {
    public var id: String { self.currency.code }

    public let baseCurrency: Currency
    public let currency: Currency
    public let exchangeRate: ExchangeRate

    public init(baseCurrency: Currency, currency: Currency, exchangeRate: ExchangeRate) {
        self.baseCurrency = baseCurrency
        self.currency = currency
        self.exchangeRate = exchangeRate
    }
}
