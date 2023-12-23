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
}
