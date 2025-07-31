//
//  AccountListViewModel.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 29/07/25.
//

import Foundation
import CoreData

class AccountListViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchAccounts()
    }

    func fetchAccounts() {
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Account.dueDate, ascending: true)
        ]
        do {
            accounts = try context.fetch(request)
        } catch {
            print("Erro ao buscar contas:", error)
        }
    }

    func addAccount(name: String, amount: Double, dueDate: Date) {
        let newAcc = Account(context: context)
        newAcc.id = UUID()
        newAcc.name = name
        newAcc.amount = amount
        newAcc.dueDate = dueDate
        newAcc.isPaid = false
        save()
    }

    func togglePaid(_ account: Account) {
        account.isPaid.toggle()
        save()
    }

    func delete(_ account: Account) {
        context.delete(account)
        save()
    }

    private func save() {
        do {
            try context.save()
            fetchAccounts()
        } catch {
            print("Erro ao salvar contexto:", error)
        }
    }
    func updateAccount(_ account: Account, name: String, amount: Double, dueDate: Date) {
            account.name = name
            account.amount = amount
            account.dueDate = dueDate
            save()
    }
}
