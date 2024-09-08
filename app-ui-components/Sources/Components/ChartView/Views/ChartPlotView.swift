import SnapKit
import UIKit

public extension ChartView {
    class PlotView: CustomView {
        public let wrapperLayer = CALayer()
        public let strokeLayer = CAShapeLayer()
        public let fillLayer = CAGradientLayer()
        public let fillMaskLayer = CAShapeLayer()

        public var data: [Double: Double] = [:] {
            didSet { self.updateData() }
        }

        public init(data: [Double: Double] = [:]) {
            self.data = data

            super.init()
            self.layer.addSublayer(self.wrapperLayer)
            self.wrapperLayer.addSublayer(self.strokeLayer)
            self.wrapperLayer.addSublayer(self.fillLayer)

            self.strokeLayer.fillColor = UIColor.clear.cgColor
            self.fillLayer.mask = self.fillMaskLayer

            self.updateData()
        }

        public override func layoutSubviews() {
            super.layoutSubviews()
            let scale = (
                sx: self.bounds.width / self.wrapperLayer.bounds.width,
                sy: self.bounds.height / self.wrapperLayer.bounds.height
            )

            self.wrapperLayer.frame = self.bounds
            self.strokeLayer.frame = self.bounds
            self.fillLayer.frame = self.bounds
            self.fillMaskLayer.frame = self.bounds

            self.strokeLayer.path = Self.scalePath(scale.sx, scale.sy)(self.strokeLayer.path)
            self.fillMaskLayer.path = Self.scalePath(scale.sx, scale.sy)(self.fillMaskLayer.path)
        }

        func updateData() {
            if self.wrapperLayer.bounds.size == .zero {
                self.wrapperLayer.bounds.size = CGSize(value: 100)
            }

            let size = self.wrapperLayer.bounds.size
            let values = self.data
                .map { ($0.key, $0.value) }
                .sorted(by: { $0.0 < $1.0 })

            let complementaryValues: [(Double, Double)] = values.isEmpty ? [] : [
                (values.last!.0, 0),
                (values.first!.0, 0),
            ]

            let strokePoints = values.map(Self.makePoint(size))
            let fillPoints = (values + complementaryValues).map(Self.makePoint(size))

            self.strokeLayer.path = Self.makePath(false)(strokePoints)
            self.fillMaskLayer.path = Self.makePath(true)(fillPoints)
        }

        static let makePoint: (CGSize) -> (Double, Double) -> CGPoint = { size in { x, y in
            CGPoint(x: x * size.width, y: (1 - y) * size.height)
        } }

        static let makePath: (Bool) -> ([CGPoint]) -> CGPath? = { closed in { points in
            guard points.count > 1 else { return nil }
            let path = UIBezierPath()
            defer { if closed { path.close() } }
            path.move(to: points.first!)
            points.dropFirst().forEach(path.addLine(to:))
            return path.cgPath
        } }

        static let scalePath: (CGFloat, CGFloat) -> (CGPath?) -> CGPath? = { sx, sy in { path in
            var affineTransform = CGAffineTransformMakeScale(sx, sy)
            return path?.copy(using: &affineTransform)
        } }
    }
}

#if targetEnvironment(simulator)
import SwiftUI
import Overture

@available(iOS 17, *)
#Preview {
    with(
        ChartView.PlotView(),
        concat(
            set(\.strokeLayer.lineWidth, 10),
            set(\.strokeLayer.strokeColor, Optional(UIColor.red.cgColor)),
            set(\.fillLayer.colors, [
                UIColor.red.cgColor,
                UIColor.red.withAlphaComponent(0).cgColor
            ]),
            set(\.data, [
                0: 0.05,
                0.5: 0.91,
                0.9: 0.5,
                1: 1,
            ])
        )
    )
}
#endif
