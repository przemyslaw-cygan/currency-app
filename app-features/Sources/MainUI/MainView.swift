import AppUIComponents
import Overture
import SnapKit
import UIKit

public class MainView: CustomView {
    public weak var controller: UINavigationController!

    public let stackView = with(
        UIStackView(),
        concat(
            Styler.elevated(2),
            set(\.spacing, Styler.Size.spacing),
            set(\.alignment, .fill),
            set(\.distribution, .fillEqually)
        )
    )

    public let gradientView = with(
        GradientView(),
        concat(
            set(\.gradientLayer.colors, [
                Styler.Color.backgroundPrimary?.withAlphaComponent(0).cgColor,
                Styler.Color.backgroundPrimary?.withAlphaComponent(1).cgColor,
            ].compactMap { $0 } as [Any]?),
            set(\.gradientLayer.startPoint, CGPoint(x: 0.0, y: 0)),
            set(\.gradientLayer.endPoint, CGPoint(x: 0.0, y: 1))
        )
    )

    public var buttonViews: [ButtonView] = [] {
        willSet { self.buttonViews.forEach { $0.removeFromSuperview() } }
        didSet { self.stackView.addArrangedSubviews(self.buttonViews) }
    }

    public var buttonView: (UIImage?, Bool) -> ButtonView = { icon, selected in
        with(
            ButtonView(),
            concat(
                selected
                    ? Styler.Button.stylePrimary(Styler.Size.L)
                    : Styler.Button.styleDefault(Styler.Size.L),
                set(\.icon, icon)
            )
        )
    }

    public init(with controller: UINavigationController) {
        super.init()

        self.backgroundColor = Styler.Color.backgroundPrimary
        self.controller = controller
        self.controller.setNavigationBarHidden(true, animated: false)

        self.addSubviews([
            self.controller.view,
            self.gradientView,
            self.stackView,
        ])

        self.controller.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.gradientView.snp.makeConstraints {
            $0.top.equalTo(self.stackView.snp.top).offset(-Styler.Size.spacing)
            $0.bottom.left.right.equalToSuperview()
        }

        self.stackView.snp.makeConstraints {
            $0.bottom.left.right.equalTo(self.safeAreaLayoutGuide).inset(Styler.Size.spacing)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.controller?.additionalSafeAreaInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: self.stackView.frame.size.height + 2 * Styler.Size.spacing,
            right: 0)
    }
}
