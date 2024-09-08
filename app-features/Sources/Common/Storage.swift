import ComposableArchitecture
import CurrencyAPIData
import Foundation

public extension PersistenceReaderKey where Self == AppStorageKey<Currency.ID> {
    static var baseCurrencyID: Self {
        .appStorage("baseCurrencyID")
    }

    static var currencyID: Self {
        .appStorage("currencyID")
    }
}
