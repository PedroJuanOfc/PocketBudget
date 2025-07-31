//
//  EditAccountView.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 31/07/25.
//

import SwiftUI

struct EditAccountView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: AccountListViewModel
    let account: Account

    @State private var name: String
    @State private var amountText: String
    @State private var dueDate: Date

    init(isPresented: Binding<Bool>, viewModel: AccountListViewModel, account: Account) {
        self._isPresented = isPresented
        self.viewModel = viewModel
        self.account = account
        _name = State(initialValue: account.name ?? "")
        _amountText = State(initialValue: String(format: "%.2f", account.amount))
        _dueDate = State(initialValue: account.dueDate ?? Date())
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Editar Conta")) {
                    TextField("Nome", text: $name)
                    TextField("Valor (ex: 120.00)", text: $amountText)
                        .keyboardType(.decimalPad)
                    DatePicker("Vencimento", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Editar Conta")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        let cleaned = amountText.replacingOccurrences(of: ",", with: ".")
                        if let amt = Double(cleaned) {
                            viewModel.updateAccount(account, name: name, amount: amt, dueDate: dueDate)
                            isPresented = false
                        }
                    }
                    .disabled(name.isEmpty || amountText.isEmpty)
                }
            }
        }
    }
}
