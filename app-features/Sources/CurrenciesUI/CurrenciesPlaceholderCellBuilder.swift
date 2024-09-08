import AppUIComponents
import CommonUI
import Overture
import UIKit

public enum CurrenciesPlaceholderCellBuilder: CollectionCellBuilder {
    public static let build: () -> CardView = { with(
        CardView(),
        concat(
            Styler.Card.styleDefault(Styler.Size.M),
            Styler.elevated(1)
        )
    ) }

    public static let clear: (CardView) -> Void = {
        $0.layer.removeAnimation(forKey: Self.animationKey)
    }

    public static let configure: (IndexPath, ()) -> (CardView) -> Void = { indexPath, _ in {
        let delay: CFTimeInterval = 0.25 * Double(indexPath.row)
        $0.layer.add(Self.animation(delay), forKey: Self.animationKey)
    } }

    static let animationKey = "PlaceholderCell-Animation"
    static let animation: (CFTimeInterval) -> CAAnimation = { delay in
        with(
            CABasicAnimation(keyPath: "opacity"),
            concat(
                set(\.duration, 1),
                set(\.repeatCount, .greatestFiniteMagnitude),
                set(\.autoreverses, true),
                set(\.fromValue, 0),
                set(\.toValue, 1),
                set(\.beginTime, CACurrentMediaTime() + delay)
            )
        )
    }
}
