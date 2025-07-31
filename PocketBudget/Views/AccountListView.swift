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
    @State private var searchText = ""
    @State private var filter: Filter = .all

    enum Filter: String, CaseIterable, Identifiable {
        case all = "Todas"
        case pending = "Pendentes"
        case paid = "Pagas"
        var id: String { rawValue }
    }

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        _viewModel = StateObject(wrappedValue: AccountListViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Picker("Filtrar", selection: $filter) {
                    ForEach(Filter.allCases) { f in
                        Text(f.rawValue).tag(f)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                TextField("Buscar conta…", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                List {
                    let filtered = viewModel.accounts.filter { account in
                        switch filter {
                        case .all:    break
                        case .pending: guard !account.isPaid else { return false }
                        case .paid:    guard  account.isPaid else { return false }
                        }
                        if searchText.isEmpty { return true }
                        return account.name?
                            .localizedCaseInsensitiveContains(searchText) == true
                    }
                    ForEach(filtered) { account in
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
                .listStyle(.plain)
            }
            .navigationTitle("Contas")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isEditing.toggle() }) {
                        Text(isEditing ? "OK" : "Editar")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAdd = true } label: {
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
