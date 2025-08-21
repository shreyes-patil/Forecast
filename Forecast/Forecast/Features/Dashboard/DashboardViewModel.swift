//
//  DashboardViewModel.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation

final class DashboardViewModel : ObservableObject {
    
//    inputs
    private let accountRepo : AccountRepository
    private let transactionRepo : TransactionRepository
    
//    outputs
    @Published var isLoading : Bool = false
    @Published var errorMessage : String?
    @Published var accounts : [Account] = []
    @Published var transactions : [Transaction] = []
    
    @Published var currentBalance : Decimal = 0
    @Published var monthIncome : Decimal = 0
    @Published var monthSpending : Decimal = 0
    @Published var topCategories : [(category: String, total: Decimal)] = []
    
    init(accountRepo : AccountRepository, transactionRepo : TransactionRepository) {
        self.accountRepo = accountRepo
        self.transactionRepo = transactionRepo
    }
    
    func load(forceRefresh : Bool = false){
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                async let a : [Account] = accountRepo.fetchAccounts()
                async let t: [Transaction] = transactionRepo.fetchTransactions(forceRefresh: forceRefresh)
                let (loadedAccounts,loadedTransactions) = try await (a,t)
                
                self.accounts = loadedAccounts
                self.transactions = loadedTransactions
                
//                calc
                self.currentBalance = loadedAccounts.map(\.currentBalance).reduce(0,+)
                let thisMonth = filterThisMonth(loadedTransactions)
                
                let income = thisMonth.filter{$0.amount > 0}.reduce(Decimal(0)) {$0 + $1.amount}
                let spendRaw = thisMonth.filter({$0.amount < 0}).reduce(Decimal(0)) {$0 + $1.amount}
                self.monthIncome = income
                self.monthSpending = abs(spendRaw)
                
                self.topCategories = self.categoryTotals(thisMonth)
                self.isLoading = false
            } catch {
                self.errorMessage = (error as NSError).localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func filterThisMonth(_ txs: [Transaction]) -> [Transaction] {
        let cal = Calendar.current
        let now = Date()
        guard let start = cal.date(from: cal.dateComponents([.year , .month], from: now)),
              let end = cal.date(byAdding: DateComponents(month:1 , day: 0), to: start)
                
        else{return txs}
        return txs.filter { $0.date >= start && $0.date < end }
    }
    
    private func categoryTotals(_ txs: [Transaction]) -> [(category : String, total : Decimal)] {
        let grouped = Dictionary(grouping: txs, by: { $0.category })
        return grouped
            .map{(key, list) in (key, list.reduce(Decimal(0)) {$0 + $1.amount})}
            .sorted{abs($0.total) > abs($1.total)}
    }
}
