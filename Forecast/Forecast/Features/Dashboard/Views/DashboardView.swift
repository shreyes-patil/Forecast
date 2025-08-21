//
//  DashboardView.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/21/25.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject private var vm : DashboardViewModel
    
    init(viewModel: DashboardViewModel){
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        NavigationView{
            Group{
                if vm.isLoading{
                    ProgressView(LocalizedStringKey("loading.generic"))
                        .frame(maxWidth: .infinity , maxHeight : .infinity)
                }
                else if let error = vm.errorMessage{
                    VStack(spacing: 12) {
                        Text(error)
                            .multilineTextAlignment(.center)
                        
                        Button(LocalizedStringKey("action.retry")){
                            vm.load(forceRefresh: true)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity , maxHeight : .infinity)
                }
                else{
                    ScrollView{
                        VStack(spacing:16){
                            balanceCard
                            monthSummaryCard
                            categorySummaryCard
                            transactionsSection
                            
                        }
                        .padding(.horizontal,16)
                        .padding(.vertical,12)
                        
                    }
                    .refreshable {
                        vm.load(forceRefresh: true)
                    }}
            }
            .navigationTitle(LocalizedStringKey("dashboard.title"))
        }
        .onAppear {
            vm.load()
        }
    }
    
    
    //            Sections
    
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(LocalizedStringKey("summary.current_balance"))
                .font(.caption)
                .foregroundColor(.secondary)
            Text(currency(vm.currentBalance))
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .accessibilityLabel(LocalizedStringKey("ally.current_balance"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private var monthSummaryCard: some View {
        HStack(spacing: 12){
            summaryPill(
                titleKey: "summary.income_month",
                amount : vm.monthIncome,
                isPositive : true
            )
            summaryPill(
                titleKey: "summary.spending_month",
                amount : vm.monthSpending,
                isPositive : false
            )
        }
    }
    
    private func summaryPill(titleKey: LocalizedStringKey, amount: Decimal, isPositive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6){
            Text(titleKey)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(currency(amount))
                .font(.headline)
                .accessibilityLabel(
                    Text(titleKey) + Text(": ") + Text(currency(amount))
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.secondary.opacity(0.15))
        )
    }

    
    private var categorySummaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey("summary.top_categories"))
                .font(.caption)
                .foregroundColor(.secondary)
            
            let top = Array(vm.topCategories.prefix(3))
            ForEach(Array(vm.topCategories.prefix(3).enumerated()), id: \.offset) { _, item in
                HStack {
                    Text(item.category)
                    Spacer()
                    Text(currency(abs(item.total)))
                        .foregroundColor(item.total < 0 ? .red : .green)
                        .font(.subheadline.monospacedDigit())
                        .accessibilityLabel(
                            Text(item.category) + Text(": ") + Text(currency(abs(item.total)))
                        )
                }
                .padding(.vertical, 4)
            }



        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
    
    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 8){
            HStack{
                Text(LocalizedStringKey("section.recent_transactions"))
                    .font(.headline)
                Spacer()
                
                Button(LocalizedStringKey("action.see_all")){
                    //                    laterrr
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            VStack(spacing: 0){
                ForEach(Array(vm.transactions.prefix(10)).indices, id: \.self){i in
                    let t = vm.transactions[i]
                    TransactionRow(t: t, currency: currency)
                    if i < min(9, vm.transactions.count - 1 ){
                        Divider().padding(.leading, 12)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemBackground))
            )
        }
    }
    
    private func currency(_ d : Decimal) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = .current
        return nf.string(from : d as NSDecimalNumber) ?? "\(d)"
    }
    
    private struct TransactionRow: View {
        let t: Transaction
        let currency: (Decimal) -> String
        
        var body: some View {
            HStack(spacing: 12) {
                Circle().frame(width: 8, height: 8)
                    .foregroundStyle(t.amount < 0 ? .red : .green)
                    .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(t.merchant) // keep raw merchant name
                        .font(.subheadline)
                    Text(t.category)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(amountText)
                    .font(.subheadline.monospacedDigit())
                    .foregroundColor(t.amount < 0 ? .red : .green)
                    .accessibilityLabel(accessibilityAmountLabel)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        
        private var amountText: AttributedString {
            // Show sign and localized currency
            let absValue: Decimal = t.amount < 0 ? -t.amount : t.amount
            let text = (t.amount < 0 ? "− " : "+ ") + currency(absValue)
            return AttributedString(text)
        }

        private var accessibilityAmountLabel: Text {
            let absValue: Decimal = t.amount < 0 ? -t.amount : t.amount
            let labelKey = t.amount < 0 ? "a11y.transaction.debit" : "a11y.transaction.credit"
            return Text(LocalizedStringKey(labelKey)) + Text(": ") + Text(currency(absValue))
        
        }
    }}


//#Preview {
//    DashboardView()
//}
