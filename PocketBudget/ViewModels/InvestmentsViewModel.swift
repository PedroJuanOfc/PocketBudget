//
//  InvestmentsViewModel.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 01/08/25.
//

import Foundation
import CoreData

class InvestmentsViewModel: ObservableObject {
    @Published var investments: [Investment] = []
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchInvestments()
    }

    func fetchInvestments() {
        let req: NSFetchRequest<Investment> = Investment.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(keyPath: \Investment.date, ascending: false)]
        do {
            investments = try context.fetch(req)
        } catch {
            print("Erro ao buscar investimentos:", error)
        }
    }

    func addInvestment(name: String, amountInvested: Double, currentValue: Double, date: Date) {
        let inv = Investment(context: context)
        inv.id = UUID()
        inv.name = name
        inv.amountInvested = amountInvested
        inv.currentValue = currentValue
        inv.date = date
        save()
    }

    func delete(_ inv: Investment) {
        context.delete(inv)
        save()
    }

    private func save() {
        do {
            try context.save()
            fetchInvestments()
        } catch {
            print("Erro ao salvar investimento:", error)
        }
    }
}
