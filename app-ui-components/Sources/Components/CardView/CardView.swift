import SnapKit
import UIKit

public class CardView: CustomView {
    public let stackView = UIStackView()
    public let imageView = CustomViewWrapper(UIImageView())
    public let contentStackView = UIStackView()
    public let headerLabelView = UILabel()
    public let bodyLabelView = UILabel()
    public let spacerView = UIView()
    public let accessoryStackView = UIStackView()

    public var image: UIImage? {
        get { self.imageView.wv.image }
        set {
            self.imageView.wv.image = newValue
            self.autohide()
        }
    }

    public var tint: UIColor? {
        get { self.imageView.wv.tintColor }
        set { self.imageView.wv.tintColor = newValue }
    }

    public var headText: String? {
        get { self.headerLabelView.text }
        set {
            self.headerLabelView.text = newValue
            self.autohide()
        }
    }

    public var bodyText: String? {
        get { self.bodyLabelView.text }
        set {
            self.bodyLabelView.text = newValue
            self.autohide()
        }
    }

    public var accessoryViews: [UIView] {
        get { self.accessoryStackView.arrangedSubviews }
        set {
            self.accessoryStackView
                .removeAllArrangedSubviews()
                .addArrangedSubviews(newValue)
            self.autohide()
        }
    }

    public override init() {
        super.init()

        self.addSubviews([
            self.stackView.addArrangedSubviews([
                self.imageView,
                self.contentStackView.addArrangedSubviews([
                    self.headerLabelView,
                    self.bodyLabelView,
                ]),
                self.spacerView,
                self.accessoryStackView,
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
        self.imageView.isHidden = self.imageView.wv.image == nil
        self.headerLabelView.isHidden = self.headerLabelView.text == nil
        self.bodyLabelView.isHidden = self.bodyLabelView.text == nil
        self.contentStackView.isHidden = self.headerLabelView.isHidden && self.bodyLabelView.isHidden
        self.spacerView.isHidden = self.accessoryViews.isEmpty
        self.accessoryStackView.isHidden = self.accessoryViews.isEmpty
    }
}
