//
//  ForecastUseCase.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/21/25.
//

// ForecastUseCase.swift
// Repeats the recent daily pattern instead of a single average.

import Foundation

struct ForecastUseCase {

    /// Projects the balance by repeating the recent daily net pattern.
    /// - Parameters:
    ///   - transactions: historical transactions (negatives = spend, positives = income)
    ///   - startingBalance: latest known balance
    ///   - days: future days to simulate (default 30)
    ///   - windowDays: how many past days to learn the pattern from (default 14)
    func forecast(
        transactions: [Transaction],
        startingBalance: Decimal,
        days: Int = 30,
        windowDays: Int = 14
    ) -> [CashFlowPoint] {

        guard days > 0 else { return [] }

        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let cutoff = cal.date(byAdding: .day, value: -windowDays, to: today) ?? today

        // 1) Build a continuous series of daily net amounts for the last `windowDays`.
        //    Missing days get 0 so the pattern length is exactly `windowDays`.
        let recent = transactions.filter { $0.date >= cutoff && $0.date < today }
        let grouped = Dictionary(grouping: recent) { cal.startOfDay(for: $0.date) }

        var pattern: [Decimal] = []
        var d = cutoff
        while d < today {
            let net = grouped[d]?.reduce(Decimal(0), { $0 + $1.amount }) ?? 0
            pattern.append(net)
            d = cal.date(byAdding: .day, value: 1, to: d) ?? d
        }

        // Fallback: if we have no recent days, use the overall average as a flat pattern.
        if pattern.isEmpty {
            let avg = averageDailyNet(transactions)
            pattern = Array(repeating: avg, count: 7) // 1‑week repeating pattern
        }

        // 2) Simulate forward by cycling through the learned pattern.
        var balance = startingBalance
        var points: [CashFlowPoint] = []
        for i in 0..<days {
            if let futureDate = cal.date(byAdding: .day, value: i, to: today) {
                points.append(CashFlowPoint(date: futureDate, balance: balance))
                let inc = pattern[i % pattern.count]
                balance += inc
            }
        }
        return points
    }

    // Overall average daily net (used only as a fallback)
    private func averageDailyNet(_ txs: [Transaction]) -> Decimal {
        let cal = Calendar.current
        let grouped = Dictionary(grouping: txs) { cal.startOfDay(for: $0.date) }
        guard !grouped.isEmpty else { return 0 }
        let daily = grouped.values.map { $0.reduce(Decimal(0)) { $0 + $1.amount } }
        let total = daily.reduce(Decimal(0), +)
        return total / Decimal(daily.count)
    }
}
