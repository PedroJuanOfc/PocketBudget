//
//  AccountListView.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 29/07/25.
//

// AccountListView.swift

import SwiftUI
import CoreData

struct AccountListView: View {
    @Environment(\.managedObjectContext) private var context

    @StateObject private var viewModel: AccountListViewModel

    @State private var showingAdd = false

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        _viewModel = StateObject(wrappedValue: AccountListViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.accounts) { account in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(account.name ?? "Sem nome")
                                .font(.headline)
                            Text(account.dueDate ?? Date(), style: .date)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text("R$ \(account.amount, specifier: "%.2f")")
                        Button {
                            viewModel.togglePaid(account)
                        } label: {
                            Image(systemName: account.isPaid
                                ? "checkmark.circle.fill"
                                : "circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .onDelete { indexSet in
                    indexSet
                        .map { viewModel.accounts[$0] }
                        .forEach(viewModel.delete)
                }
            }
            .navigationTitle("Contas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddAccountView(isPresented: $showingAdd, viewModel: viewModel)
                    .environment(\.managedObjectContext, context)
            }
        }
    }
}
