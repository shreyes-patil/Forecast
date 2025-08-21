//
//  MainTabView.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/21/25.
//

import SwiftUI

struct MainTabView: View {
    let accountRepo: AccountRepository
    let transactionRepo: TransactionRepository
    let chatAdapter: ChatAdapter
    
    
    var body: some View {
        TabView{
            NavigationStack{
                DashboardView (
                    viewModel: DashboardViewModel(
                        accountRepo: accountRepo,
                        transactionRepo: transactionRepo
                    )
                )
                .navigationTitle(LocalizedStringKey("dashboard.title"))
            }
            .tabItem{
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationStack{
                Text("AIChat")
                    .navigationTitle(Text("AIChat"))
            }
            .tabItem{
                Label("AI Chat", systemImage: "sparkles")
            }
            
            NavigationStack{
                Form{
                    Section("Data"){
                        Text("Connect Bank")
                        Text("Clear local data")
                    }
                    Section("About"){
                        Text("Version 0.1")
                    }
                }
                .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

