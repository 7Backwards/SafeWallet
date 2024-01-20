//
//  AddCardViewModel.swift
//  SafeWallet
//
//  Created by Gonçalo on 23/12/2023.
//

import Foundation
import CoreData
import SwiftUI

class AddCardViewModel: ObservableObject {
    @Published var selectedColor: Color?
    @Published var appManager: AppManager
    
    init(appManager: AppManager) {
        self.appManager = appManager
    }
    
    func addCard(cardName: String, cardNumber: String, expiryDate: String, cvvCode: String, cardColor: String) {
        guard !cardName.isEmpty, !cardNumber.isEmpty, !expiryDate.isEmpty, !cvvCode.isEmpty, !cardColor.isEmpty else { return }

        appManager.actionManager.doAction(action: .addCard(cardName: cardName, cardNumber: cardNumber, expiryDate: expiryDate, cvvCode: cvvCode, cardColor: cardColor))
    }
}

