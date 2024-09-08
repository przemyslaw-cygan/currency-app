import SnapKit
import UIKit

public class ChartView: CustomView {
    public let wrapperView = UIView()
    public let plotView = PlotView()
    public let xScaleView = ScaleView(position: .bottom)
    public let xLabelsView = LabelsView(position: .bottom)
    public let yGuidesView = GuidesView(axis: .Y)
    public let yLabelsView = LabelsView(position: .right)

    public var data: ChartData {
        didSet { self.updateData() }
    }

    public init(data: ChartData = .init(yGuides: [:], xGuides: [:], points: [:])) {
        self.data = data
        super.init()

        self.addSubviews([
            self.xLabelsView,
            self.yLabelsView,
            self.wrapperView.addSubviews([
                self.yGuidesView,
                self.plotView,
                self.xScaleView,
            ]),
        ])

        self.wrapperView.snp.makeConstraints {
            $0.edges.equalTo(self.layoutMarginsGuide)
        }

        self.plotView.snp.makeConstraints {
            $0.edges.equalTo(self.wrapperView.layoutMarginsGuide)
        }

        self.yGuidesView.snp.makeConstraints {
            $0.edges.equalTo(self.plotView)
        }

        self.xScaleView.snp.makeConstraints {
            $0.top.equalTo(self.plotView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.right.equalTo(self.plotView)
        }

        self.xLabelsView.snp.makeConstraints {
            $0.top.equalTo(self.wrapperView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.right.equalTo(self.plotView)
        }

        self.yLabelsView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.plotView)
            $0.left.equalTo(self.wrapperView.snp.right)
            $0.right.equalToSuperview()
        }

        self.updateData()
    }

    func updateData() {
        let normalized = self.data.normalized()

        self.yGuidesView.data = normalized.yGuides.map(\.key)
        self.xScaleView.data = normalized.xGuides.map(\.key)
        self.xLabelsView.data = normalized.xGuides
        self.yLabelsView.data = normalized.yGuides
        self.plotView.data = normalized.points
    }
}
