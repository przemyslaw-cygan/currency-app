import AppUIComponents
import CommonUI
import CurrencyAPIData
import ExchangeRatesFeature
import Overture
import UIKit

enum ExchangeRatesItemCellBuilder: CollectionCellBuilder {
    static let build: () -> CardView = { with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.elevated(1)
        )
    ) }

    static let clear: (CardView) -> Void = concat(
        mut(\.image, nil),
        mut(\.tint, nil),
        mut(\.headText, nil),
        mut(\.bodyText, nil),
        mut(\.accessoryViews, [])
    )

    static let configure: (IndexPath, ExchangeRatesItem) -> (CardView) -> Void = { _, model in
        let value = model.baseCurrency.format(.current, model.exchangeRate.value, extended: true)

        let exchangeButton = with(
            ButtonView(),
            concat(
                Styler.Button.styleSecondary(Styler.Size.S),
                set(\.label, value),
                set(\.isUserInteractionEnabled, false)
            )
        )

        return concat(
            mut(\.image, model.currency.image),
            mut(\.tint, model.currency.color),
            mut(\.headText, model.currency.code),
            mut(\.bodyText, model.currency.name),
            mut(\.accessoryViews, [exchangeButton])
        )
    }
}
