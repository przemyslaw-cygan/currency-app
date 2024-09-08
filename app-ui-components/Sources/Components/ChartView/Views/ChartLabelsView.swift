import SnapKit
import UIKit

public extension ChartView {
    class LabelsView: CustomView {
        public let labelTemplate = UILabel()

        public var labelsViews: [Double: UILabel] = [:]

        public var position: ChartPosition {
            didSet { self.updateData() }
        }

        public var data: [Double: String] {
            didSet { self.updateData() }
        }

        public init(
            position: ChartPosition,
            data: [Double: String] = [:]
        ) {
            self.position = position
            self.data = data
            super.init()
            self.updateData()
        }

        public func refresh() {
            self.updateData()
        }

        func updateData() {
            let constraintMaker = Self.makeConstraints(self.position, self)

            let keysWithValues = self.data.map { value, text in
                let label: UILabel = self.labelTemplate.copyView()
                self.addSubview(label)
                label.text = text
                label.snp.makeConstraints(constraintMaker(value))
                return (value, label)
            }

            self.labelsViews.values.forEach { $0.removeFromSuperview() }
            self.labelsViews = Dictionary(uniqueKeysWithValues: keysWithValues)
        }

        static let makeConstraints: (ChartPosition, UIView) -> (Double) -> (ConstraintMaker) -> Void = { position, superview in { value in {
            switch position {
            case .top:
                $0.bottom.equalToSuperview()
                _ = value.isZero
                ? $0.centerX.equalTo(superview.snp.left)
                : $0.centerX.equalTo(superview.snp.right).multipliedBy(value)
            case .bottom:
                $0.top.equalToSuperview()
                _ = value.isZero
                ? $0.centerX.equalTo(superview.snp.left)
                : $0.centerX.equalTo(superview.snp.right).multipliedBy(value)
            case .left:
                let value = 1 - value
                $0.right.equalToSuperview()
                _ = value.isZero
                ? $0.centerY.equalTo(superview.snp.top)
                : $0.centerY.equalTo(superview.snp.bottom).multipliedBy(value)
            case .right:
                let value = 1 - value
                $0.left.equalToSuperview()
                _ = value.isZero
                ? $0.centerY.equalTo(superview.snp.top)
                : $0.centerY.equalTo(superview.snp.bottom).multipliedBy(value)
            }
        } } }
    }
}

#if targetEnvironment(simulator)
import SwiftUI
import Overture

@available(iOS 17, *)
#Preview {
    with(
        ChartView.LabelsView(position: .top),
        concat(
            set(\.labelTemplate.font, .systemFont(ofSize: 20)),
            set(\.labelTemplate.backgroundColor, .red),
            set(\.labelTemplate.textColor, .white),
            set(\.labelTemplate.textAlignment, .right),
            set(\.data, [
                0: "test 0",
                0.1: "test 1",
                0.5: "test 2",
                1: "test 3",
            ])
        )
    )
}
#endif
