import UIKit

public protocol CollectionSection: Hashable {
    associatedtype Item: Hashable
    var items: [Item] { get }
}

public typealias CollectionSnapshot<Section: CollectionSection> = NSDiffableDataSourceSnapshot<Section, Section.Item>
public typealias CollectionSource<Section: CollectionSection> = UICollectionViewDiffableDataSource<Section, Section.Item>

public extension NSDiffableDataSourceSnapshot
where SectionIdentifierType: CollectionSection, ItemIdentifierType == SectionIdentifierType.Item {
    init(with sections: [SectionIdentifierType]) {
        self.init()
        self.appendSections(sections)
        sections.forEach { self.appendItems($0.items, toSection: $0) }
    }
}
