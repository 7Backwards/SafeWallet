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
            let appManager = AppManager(context: viewContext)
            CardListView(viewModel: CardListViewModel(appManager: appManager))
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
