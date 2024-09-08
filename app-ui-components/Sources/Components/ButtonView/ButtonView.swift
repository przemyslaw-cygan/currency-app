import SnapKit
import UIKit

public class ButtonView: CustomControl {
    public let stackView = UIStackView()
    public let iconView = CustomViewWrapper(UIImageView())
    public let labelView = CustomViewWrapper(UILabel())

    public var icon: UIImage? {
        get { self.iconView.wv.image }
        set {
            self.iconView.wv.image = newValue
            self.autohide()
        }
    }

    public var label: String? {
        get { self.labelView.wv.text }
        set {
            self.labelView.wv.text = newValue
            self.autohide()
        }
    }

    public override init() {
        super.init()

        self.stackView.isUserInteractionEnabled = false
        self.iconView.isUserInteractionEnabled = false
        self.labelView.isUserInteractionEnabled = false

        self.addSubviews([
            self.stackView.addArrangedSubviews([
                self.iconView,
                self.labelView,
            ])
        ])

        self.stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.autohide()
    }

    func autohide() {
        self.iconView.isHidden = self.iconView.wv.image == nil
        self.labelView.isHidden = self.labelView.wv.text == nil
    }
}
