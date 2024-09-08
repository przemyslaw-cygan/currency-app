import Foundation

public struct ChartData {
    public let yGuides: [Double: String]
    public let xGuides: [Double: String]
    public let points: [Double: Double]

    public init(
        yGuides: [Double: String],
        xGuides: [Double: String],
        points: [Double: Double]
    ) {
        self.yGuides = yGuides
        self.xGuides = xGuides
        self.points = points
    }

    public func normalized() -> ChartData {
        let xValues = self.points.map(\.key) + self.xGuides.map(\.key)
        let yValues = self.points.map(\.value) + self.yGuides.map(\.key)

        let xMin = xValues.min() ?? 0
        let xMax = xValues.max() ?? 0
        let yMin = yValues.min() ?? 0
        let yMax = yValues.max() ?? 0

        func xValue(_ x: Double) -> Double {
            (x - xMin) / (xMax - xMin)
        }

        func yValue(_ y: Double) -> Double {
            (y - yMin) / (yMax - yMin)
        }

        return ChartData(
            yGuides: Dictionary(uniqueKeysWithValues: self.yGuides.map { (yValue($0.0), $0.1) }),
            xGuides: Dictionary(uniqueKeysWithValues: self.xGuides.map { (xValue($0.0), $0.1) }),
            points: Dictionary(uniqueKeysWithValues: self.points.map { (xValue($0.0), yValue($0.1)) })
        )
    }
}
