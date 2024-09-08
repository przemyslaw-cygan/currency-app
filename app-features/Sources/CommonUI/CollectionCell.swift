import UIKit

public class CollectionCell<B: CollectionCellBuilder>: UICollectionViewCell {
    public let view: B.CellView = B.build()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .clear
        self.contentView.addSubview(self.view)

        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.view.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(at indexPath: IndexPath, with model: B.CellModel) {
        B.configure(indexPath, model)(self.view)
    }

    public override func prepareForReuse() {
        B.clear(self.view)
    }
}
