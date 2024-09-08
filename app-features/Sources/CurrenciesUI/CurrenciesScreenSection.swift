import CommonUI
import CurrencyAPIData
import Foundation

public struct CurrenciesScreenSection: CollectionSection {
    public enum Item: Hashable {
        case item(Currency)
        case placeholder(Int)
    }

    public var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
}

public extension CurrenciesScreenSection {
    static func snapshot(for data: [Currency]?) -> CollectionSnapshot<CurrenciesScreenSection> {
        CollectionSnapshot(with: [
            CurrenciesScreenSection(
                items: data?.map(Item.item) ?? (0...2).map(Item.placeholder)
            )
        ])
    }
}
