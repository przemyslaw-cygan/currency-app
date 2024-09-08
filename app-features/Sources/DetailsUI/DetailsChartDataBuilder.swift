import AppUIComponents
import CurrencyAPIData
import DetailsFeature
import Foundation

public enum DetailsChartDataBuilder {
    static func build(using exchangeRates: [Date: ExchangeRate]?, baseCurrency: Currency?, dateRange: DetailsDateRange?) -> ChartData {
        guard
            let exchangeRates,
            let baseCurrency,
            let dateRange,
            exchangeRates.count > 1
        else {
            return ChartData(yGuides: [:], xGuides: [:], points: [:])
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"

        let xValues = exchangeRates.map(\.key.timeIntervalSince1970)
        let xMin = xValues.min()!
        let xMax = xValues.max()!
        let xStride: Double = switch dateRange {
        case .week:
            60 * 60 * 24 * 2
        case .month:
            60 * 60 * 24 * 7
        case .year:
            60 * 60 * 24 * 90
        }
        let xGuidesValues = stride(from: xMin, to: xMax - xStride, by: xStride) + [xMax]
        let xGuides = xGuidesValues.reduce(into: [:]) {
            $0[$1] = dateFormatter.string(for: Date(timeIntervalSince1970: $1))
        }

        let yValues = exchangeRates.map(\.value.value)
        let yMin = yValues.min()!
        let yMax = yValues.max()!
        let yStride = (yMax - yMin) / 5
        let yGuidesValues = stride(from: yMin, to: yMax - yStride, by: yStride) + [yMax]
        let yGuides = yGuidesValues.reduce(into: [:]) {
            $0[$1] = baseCurrency.format(.current, $1, extended: true) ?? ""
        }

        let points = exchangeRates.reduce(into: [:]) {
            $0[$1.key.timeIntervalSince1970] = $1.value.value
        }

        return ChartData(
            yGuides: yGuides,
            xGuides: xGuides,
            points: points
        )
    }
}
