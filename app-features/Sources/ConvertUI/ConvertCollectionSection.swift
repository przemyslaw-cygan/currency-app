import CommonUI
import Foundation

public struct ConvertCollectionSection: CollectionSection {
    public enum Item: Hashable {
        case number(Int)
        case zero(Int)
        case clear
    }

    public var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
}

public extension ConvertCollectionSection {
    static func snapshot() -> CollectionSnapshot<ConvertCollectionSection> {
        CollectionSnapshot(with: [
            ConvertCollectionSection(items: [
                .number(7), .number(8), .number(9),
                .number(4), .number(5), .number(6),
                .number(1), .number(2), .number(3),
                .zero(2), .zero(1), .clear,
            ])
        ])
    }
}
