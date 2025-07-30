//
//  DashboardView.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 30/07/25.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var context

    @FetchRequest(
        entity: Account.entity(),
        sortDescriptors: [])
    private var accounts: FetchedResults<Account>

    private var totalBalance: Double {
        accounts.reduce(0) { $0 + ($1.isPaid ? 0 : $1.amount) }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                VStack {
                    Text("Saldo Total")
                        .font(.headline)
                    Text(String(format: "R$ %.2f", totalBalance))
                        .font(.largeTitle)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4, y: 2)

                HStack(spacing: 16) {
                    QuickCard(title: "Contas", icon: "list.bullet")
                    QuickCard(title: "Investimentos", icon: "chart.line.uptrend.xyaxis")
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("Dashboard")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

struct QuickCard: View {
    let title: String
    let icon: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2, y: 1)
    }
}
