//
//  CardListViewModel.swift
//  SafeWallet
//
//  Created by Gonçalo on 23/12/2023.
//

import Foundation
import CoreData
import SwiftUI

class CardListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var showingAddCardView = false
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func deleteCards(at offsets: IndexSet, from cards: FetchedResults<Card>) {
        withAnimation {
            offsets.map { cards[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Handle the error appropriately
                print("Error when trying to delete card: \(error)")
            }
        }
    }
    
    func authenticate(completion: @escaping (Bool) -> Void) {
        BiometricAuth().authenticateUser { result in
            if let result = try? result.get(), result {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
