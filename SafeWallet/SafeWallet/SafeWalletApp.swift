//
//  SafeWalletApp.swift
//  SafeWallet
//
//  Created by Gonçalo on 21/12/2023.
//

import SwiftUI

@main
struct SafeWalletApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CardListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
