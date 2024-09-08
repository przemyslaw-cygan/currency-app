import AppUIComponents
import Overture
import SnapKit
import UIKit

public class NavigationView: CustomView {
    public weak var controller: UINavigationController!

    public let stackView = with(
        UIStackView(),
        concat(
            Styler.elevated(2),
            set(\.spacing, 2 * Styler.Size.spacing),
            set(\.alignment, .center)
        )
    )

    public let backItemView = with(
        ButtonView(),
        concat(
            Styler.Button.styleDefault(Styler.Size.L),
            set(\.icon, UIImage(systemName: "arrow.left"))
        )
    )

    public let closeItemView = with(
        ButtonView(),
        concat(
            Styler.Button.styleDefault(Styler.Size.L),
            set(\.icon, UIImage(systemName: "xmark"))
        )
    )

    public let titleItemWrapperView = UIView()

    public let actionItemsStackView = with(
        UIStackView(),
        concat(
            set(\.spacing, Styler.Size.spacing),
            set(\.alignment, .fill)
        )
    )

    public var titleItem: UIView? {
        willSet { self.titleItem?.removeFromSuperview() }
        didSet {
            guard let titleItem = self.titleItem else { return }
            self.titleItemWrapperView.addSubview(titleItem)
            titleItem.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }

    public var actionItems: [UIView] = [] {
        willSet { self.actionItems.forEach { $0.removeFromSuperview() } }
        didSet { self.actionItemsStackView.addArrangedSubviews(actionItems) }
    }

    public let gradientView = with(
        GradientView(),
        concat(
            set(\.backgroundColor, Styler.Color.backgroundPrimary?.withAlphaComponent(0.25)),
            set(\.gradientLayer.colors, [
                Styler.Color.backgroundPrimary?.withAlphaComponent(1).cgColor,
                Styler.Color.backgroundPrimary?.withAlphaComponent(0).cgColor,
            ].compactMap { $0 } as [Any]?),
            set(\.gradientLayer.startPoint, CGPoint(x: 0.0, y: 0)),
            set(\.gradientLayer.endPoint, CGPoint(x: 0.0, y: 1))
        )
    )

    public init(with controller: UINavigationController) {
        super.init()

        self.backgroundColor = Styler.Color.backgroundPrimary
        self.controller = controller
        self.controller.setNavigationBarHidden(true, animated: false)

        self.addSubviews([
            self.controller.view,
            self.gradientView,
            self.stackView.addArrangedSubviews([
                self.backItemView,
                self.closeItemView,
                self.titleItemWrapperView,
                UIView(),
                self.actionItemsStackView,
            ]),
        ])

        self.controller.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.gradientView.snp.makeConstraints {
            $0.bottom.equalTo(self.stackView.snp.bottom).offset(Styler.Size.spacing)
            $0.top.left.right.equalToSuperview()
        }

        self.stackView.snp.makeConstraints {
            $0.top.left.right.equalTo(self.safeAreaLayoutGuide).inset(Styler.Size.spacing)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.controller?.additionalSafeAreaInsets = UIEdgeInsets(
            top: self.stackView.frame.size.height + 2 * Styler.Size.spacing,
            left: 0,
            bottom: 0,
            right: 0
        )
    }
}
