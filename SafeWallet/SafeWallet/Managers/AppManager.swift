//
//  AppManager.swift
//  SafeWallet
//
//  Created by Gonçalo on 18/01/2024.
//

import Combine
import CoreData

class AppManager: ObservableObject {
    @Published private(set) var store: AppStore
    let actionManager: AppActionManager
    let constants: AppConstants
    let utils: AppUtils
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.store = AppStore(context: context)
        self.actionManager = AppActionManager(context: context)
        self.constants = AppConstants()
        self.utils = AppUtils()
    }
}

class AppConstants {
    
}

class AppUtils {
    
}



