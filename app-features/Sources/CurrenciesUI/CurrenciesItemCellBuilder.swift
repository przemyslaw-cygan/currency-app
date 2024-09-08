import AppUIComponents
import CommonUI
import CurrencyAPIData
import Overture
import UIKit

public enum CurrenciesItemCellBuilder: CollectionCellBuilder {
    public static let build: () -> CardView = { with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.elevated(1)
        )
    ) }

    public static let clear: (CardView) -> Void = concat(
        mut(\.image, nil),
        mut(\.tint, nil),
        mut(\.headText, nil),
        mut(\.bodyText, nil)
    )

    public static let configure: (IndexPath, Currency) -> (CardView) -> Void = { _, model in
        concat(
            mut(\.image, model.image),
            mut(\.tint, model.color),
            mut(\.headText, model.code),
            mut(\.bodyText, model.name)
        )
    }
}
