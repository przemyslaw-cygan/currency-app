import AppUIComponents
import CommonUI
import Overture
import UIKit

public enum ConvertKeyCellBuilder: CollectionCellBuilder {
    public static let build: () -> ButtonView = { with(
        ButtonView(),
        concat(
            Styler.Button.styleSecondary(Styler.Size.M),
            Styler.circular(),
            set(\.isUserInteractionEnabled, false)
        )
    ) }

    public static let clear: (ButtonView) -> Void = concat(
        mut(\.icon, nil),
        mut(\.label, nil)
    )

    public static let configure: (IndexPath, ConvertCollectionSection.Item) -> (ButtonView) -> Void = { _, model in
        switch model {
        case .number(let value):
            mut(\.label, "\(value)")
        case .zero(let count):
            mut(\.label, String(repeating: "0", count: count))
        case .clear:
            mut(\.icon, UIImage(systemName: "delete.backward"))
        }
    }
}
