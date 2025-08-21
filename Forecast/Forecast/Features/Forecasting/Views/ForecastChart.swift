//
//  ForecastChart.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/21/25.
//

import SwiftUI
import Charts

struct ForecastChart: View {
    let points: [CashFlowPoint]

    var body: some View {
        let ys = points.map { ($0.balance as NSDecimalNumber).doubleValue }
        let minY = (ys.min() ?? 0)
        let maxY = (ys.max() ?? 0)
        // pad the domain so the line isn't glued to the edges
        let padding = max((maxY - minY) * 0.1, 1000) // Increased padding for better visibility

        Chart(points, id: \.date) { p in
            AreaMark(
                x: .value("Date", p.date),
                yStart: .value("Min", minY - padding),
                yEnd: .value("Balance", decToDbl(p.balance))
            )
            .interpolationMethod(.monotone)
            .foregroundStyle(.blue.opacity(0.15))

            LineMark(
                x: .value("Date", p.date),
                y: .value("Balance", decToDbl(p.balance))
            )
            .interpolationMethod(.monotone)
            .lineStyle(.init(lineWidth: 3))
            .foregroundStyle(.blue)
        }
        .chartYAxis {
            AxisMarks(preset: .aligned, position: .trailing) { value in
                if let d = value.as(Double.self) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        Text(currency(d))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 7)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
            }
        }
        .chartYScale(domain: (minY - padding)...(maxY + padding))
        .frame(height: 200)
        .padding(.trailing, 8) // Add padding for Y-axis labels
        .accessibilityLabel(Text("Forecast chart"))
    }

    private func decToDbl(_ d: Decimal) -> Double {
        (d as NSDecimalNumber).doubleValue
    }

    private func currency(_ v: Double) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = .current
        nf.maximumFractionDigits = 0 // Remove cents for cleaner labels
        nf.currencySymbol = "$" // Ensure consistent symbol
        return nf.string(from: NSNumber(value: v)) ?? "$\(Int(v))"
    }
}
