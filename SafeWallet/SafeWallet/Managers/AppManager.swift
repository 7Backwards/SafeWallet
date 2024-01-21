//
//  AppManager.swift
//  SafeWallet
//
//  Created by Gonçalo on 18/01/2024.
//

import Combine
import CoreData

class AppManager: ObservableObject {
    let actionManager: AppActionManager
    @Published private(set) var constants: AppConstants
    let utils: AppUtils
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.actionManager = AppActionManager(context: context)
        self.constants = AppConstants()
        self.utils = AppUtils()
    }
}

