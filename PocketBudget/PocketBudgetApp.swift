//
//  PocketBudgetApp.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 29/07/25.
//

import SwiftUI
import CoreData

@main
struct PocketBudgetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabView {
                AccountListView()
                    .tabItem {
                        Label("Contas", systemImage: "list.bullet")
                    }

                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
            }
            .environment(\.managedObjectContext,
                         persistenceController.container.viewContext)
        }
    }
}
