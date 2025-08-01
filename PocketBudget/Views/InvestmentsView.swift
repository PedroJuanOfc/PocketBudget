//
//  InvestmentsView.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 01/08/25.
//

import SwiftUI
import CoreData

struct InvestmentsView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: InvestmentsViewModel
    @State private var showingAdd = false

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        _viewModel = StateObject(wrappedValue: InvestmentsViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(Text("Gráfico de patrimônio").foregroundColor(.gray))

                List {
                    ForEach(viewModel.investments) { inv in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(inv.name ?? "")
                                    .font(.headline)
                                Text(inv.date ?? Date(), style: .date)
                                    .font(.subheadline)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Investido: R$ \(inv.amountInvested, specifier: "%.2f")")
                                Text("Atual: R$ \(inv.currentValue, specifier: "%.2f")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete { idx in
                        idx.map { viewModel.investments[$0] }.forEach(viewModel.delete)
                    }
                }
            }
            .navigationTitle("Investimentos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddInvestmentView(isPresented: $showingAdd, viewModel: viewModel)
                    .environment(\.managedObjectContext, context)
            }
        }
    }
}

struct AddInvestmentView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: InvestmentsViewModel

    @State private var name = ""
    @State private var amountText = ""
    @State private var currentValueText = ""
    @State private var date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section("Detalhes") {
                    TextField("Nome do ativo", text: $name)
                    TextField("Valor investido", text: $amountText)
                        .keyboardType(.decimalPad)
                    TextField("Valor atual", text: $currentValueText)
                        .keyboardType(.decimalPad)
                    DatePicker("Data", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Novo Investimento")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        let invested = Double(amountText.replacingOccurrences(of: ",", with: ".")) ?? 0
                        let current  = Double(currentValueText.replacingOccurrences(of: ",", with: ".")) ?? 0
                        viewModel.addInvestment(name: name,
                                                amountInvested: invested,
                                                currentValue: current,
                                                date: date)
                        isPresented = false
                    }
                    .disabled(name.isEmpty || amountText.isEmpty || currentValueText.isEmpty)
                }
            }
        }
    }
}
