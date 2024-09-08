import SnapKit
import UIKit

public class FieldView: CustomView {
    public let stackView = UIStackView()
    public let fieldView = CustomViewWrapper(UITextField())
    public let accessoryStackView = UIStackView()

    public var field: UITextField {
        self.fieldView.wv
    }

    public var text: String? {
        get { self.fieldView.wv.text }
        set { self.fieldView.wv.text = newValue }
    }

    public var placeholder: String? {
        get { self.fieldView.wv.attributedPlaceholder?.string }
        set {
            guard let newValue else {
                self.fieldView.wv.attributedPlaceholder = nil
                return
            }

            self.fieldView.wv.attributedPlaceholder = NSAttributedString(
                string: newValue,
                attributes: [
                    .font: self.fieldView.wv.font,
                    .foregroundColor: self.fieldView.wv.textColor?.withAlphaComponent(0.25)
                ].compactMapValues { $0 }
            )
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

    public var onChange: ((String?) -> Void)?

    public override init() {
        super.init()

        self.addSubviews([
            self.stackView.addArrangedSubviews([
                self.fieldView,
                self.accessoryStackView
            ]),
        ])

        self.stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.fieldView.wv.addTarget(self, action: #selector(self.onChangeAction), for: .editingChanged)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.autohide()
    }

    func autohide() {
        self.accessoryStackView.isHidden = self.accessoryViews.isEmpty
    }

    @objc
    func onChangeAction(_ textField: UITextField) {
        self.onChange?(textField.text)
    }
}
