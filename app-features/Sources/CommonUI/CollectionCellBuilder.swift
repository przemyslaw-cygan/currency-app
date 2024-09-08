import UIKit

public protocol CollectionCellBuilder {
    associatedtype CellView: UIView
    associatedtype CellModel

    typealias Cell = CollectionCell<Self>

    static var build: () -> CellView { get }
    static var clear: (CellView) -> Void { get }
    static var configure: (IndexPath, CellModel) -> (CellView) -> Void { get }
}

public extension CollectionCellBuilder {
    static var cellRegistration: UICollectionView.CellRegistration<Cell, CellModel> {
        UICollectionView.CellRegistration.init { cell, indexPath, model in cell.configure(at: indexPath, with: model) }
    }
}
