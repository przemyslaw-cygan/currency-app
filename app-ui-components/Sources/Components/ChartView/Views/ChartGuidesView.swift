import SnapKit
import UIKit

public extension ChartView {
    class GuidesView: CustomView {
        public let wrapperLayer = CAShapeLayer()
        public let guideTemplate = CAShapeLayer()

        public var guidesLayers: [CAShapeLayer] = []

        public var axis: ChartAxis {
            didSet { self.updateData() }
        }

        public var data: [Double] {
            didSet { self.updateData() }
        }

        public init(
            axis: ChartAxis,
            data: [Double] = []
        ) {
            self.axis = axis
            self.data = data
            super.init()
            self.layer.addSublayer(self.wrapperLayer)
            self.updateData()
        }

        public override func layoutSubviews() {
            super.layoutSubviews()
            let scale = (
                sx: self.bounds.width / self.wrapperLayer.frame.width,
                sy: self.bounds.height / self.wrapperLayer.frame.height
            )

            self.wrapperLayer.frame = self.bounds
            self.guidesLayers.forEach {
                $0.frame = self.wrapperLayer.bounds
                $0.path = Self.scalePath(scale.sx, scale.sy)($0.path)
            }
        }

        public func refresh() {
            self.updateData()
        }

        func updateData() {
            if self.wrapperLayer.bounds.size == .zero {
                self.wrapperLayer.bounds.size = CGSize(value: 100)
            }

            self.guidesLayers.forEach { $0.removeFromSuperlayer() }

            self.guidesLayers = self.data
                .map(Self.makePoints(self.axis, self.wrapperLayer.bounds.size))
                .map(Self.makePath)
                .map { path in
                    let layer: CAShapeLayer = self.guideTemplate.copyLayer()
                    layer.frame = self.wrapperLayer.bounds
                    layer.path = path
                    return layer
                }

            self.guidesLayers.forEach { self.wrapperLayer.addSublayer($0) }
        }

        static let makePoints: (ChartAxis, CGSize) -> (Double) -> [CGPoint] = { axis, size in { value in
            switch axis {
            case .X:
                return [
                    CGPoint(x: value * size.width, y: 0),
                    CGPoint(x: value * size.width, y: size.height)
                ]
            case .Y:
                let value = 1 - value
                return [
                    CGPoint(x: 0, y: value * size.height),
                    CGPoint(x: size.width, y: value * size.height)
                ]
            }
        }}

        static let makePath: ([CGPoint]) -> CGPath? = { points in
            guard points.count > 1 else { return nil }
            let path = UIBezierPath()
            path.move(to: points.first!)
            points.dropFirst().forEach(path.addLine(to:))
            return path.cgPath
        }

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
        ChartView.GuidesView(axis: .Y),
        concat(
            set(\.guideTemplate.strokeColor, Optional(UIColor.red.cgColor)),
            set(\.guideTemplate.lineWidth, 10),
            set(\.data, [
                0.05,
                0.1,
                0.5,
                1
            ])
        )
    )
}
#endif
