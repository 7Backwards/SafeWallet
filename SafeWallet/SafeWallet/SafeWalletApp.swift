//
//  SafeWalletApp.swift
//  SafeWallet
//
//  Created by Gonçalo on 21/12/2023.
//

import SwiftUI

@main
struct SafeWalletApp: App {
    let viewContext = PersistenceController.shared.container.viewContext

    var body: some Scene {
        WindowGroup {
            CardListView(viewModel: CardListViewModel())
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
