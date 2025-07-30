//
//  AddAccountView.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 29/07/25.
//

// AddAccountView.swift

import SwiftUI

struct AddAccountView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: AccountListViewModel

    @State private var name = ""
    @State private var amountText = ""
    @State private var dueDate = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalhes da Conta")) {
                    TextField("Nome", text: $name)

                    TextField("Valor (ex: 120.50)", text: $amountText)
                        .keyboardType(.decimalPad)

                    DatePicker("Vencimento", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Nova Conta")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        let cleaned = amountText.replacingOccurrences(of: ",", with: ".")
                        if let amt = Double(cleaned) {
                            viewModel.addAccount(name: name, amount: amt, dueDate: dueDate)
                            isPresented = false
                        }
                    }
                    .disabled(name.isEmpty || amountText.isEmpty)
                }
            }
        }
    }
}
