import CommonUI
import ExchangeRatesFeature
import Foundation

struct ExchangeRatesCollectionSection: CollectionSection {
    enum Item: Hashable {
        case item(ExchangeRatesItem)
        case placeholder(Int)
    }

    var items: [Item]
}

extension ExchangeRatesCollectionSection {
    static func snapshot(for data: [ExchangeRatesItem]?) -> CollectionSnapshot<ExchangeRatesCollectionSection> {
        CollectionSnapshot(with: [
            ExchangeRatesCollectionSection(
                items: data?.map(Item.item) ?? (0...2).map(Item.placeholder)
            )
        ])
    }
}
