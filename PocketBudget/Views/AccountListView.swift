//
//  AccountListView.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 29/07/25.
//

import SwiftUI
import CoreData

struct AccountListView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: AccountListViewModel
    @State private var showingAdd = false
    @State private var editingAccount: Account?
    @State private var isEditing = false

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
                        Text(String(format: "R$ %.2f", account.amount))
                        Button {
                            viewModel.togglePaid(account)
                        } label: {
                            Image(systemName:
                                account.isPaid
                                ? "checkmark.circle.fill"
                                : "circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())

                        if isEditing {
                            Button {
                                editingAccount = account
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .buttonStyle(BorderlessButtonStyle())

                            Button(role: .destructive) {
                                viewModel.delete(account)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Contas")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isEditing.toggle() }) {
                        Text(isEditing ? "OK" : "Editar")
                    }
                }
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
            .sheet(item: $editingAccount) { account in
                EditAccountView(
                    isPresented: Binding(
                        get: { editingAccount != nil },
                        set: { if !$0 { editingAccount = nil } }
                    ),
                    viewModel: viewModel,
                    account: account
                )
                .environment(\.managedObjectContext, context)
            }
        }
    }
}
