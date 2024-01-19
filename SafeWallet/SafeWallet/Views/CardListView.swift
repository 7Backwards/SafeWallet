//
//  ContentView.swift
//  SafeWallet
//
//  Created by Gonçalo on 21/12/2023.
//

import SwiftUI
import CoreData

struct CardListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel: CardListViewModel
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                    .background(Color(UIColor.systemBackground))
                
                List {
                    ForEach(viewModel.appManager.store.cards.filter {
                        viewModel.searchText.isEmpty ||
                        $0.cardNumber.contains(viewModel.searchText) || $0.cardName.contains(viewModel.searchText)
                    }, id: \.self) { card in
                        Button {
                            viewModel.authenticate { result in
                                if result {
                                    path.append(card)
                                }
                            }
                        } label: {
                            CardRow(card: card, onDelete: {
                                if let index = viewModel.appManager.store.cards.firstIndex(where: { $0.id == card.id }) {
                                    print("Deleting card at index: \(index)")
                                    viewModel.deleteCards(at: IndexSet(integer: index), from: viewModel.appManager.store.cards) { _ in
                                        self.viewModel.refreshView()
                                    }
                                } else {
                                    print("Failed to find index for card")
                                }
                            })
                            
                            .padding([.horizontal], 5)
                            .padding([.vertical], 10)
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    .listRowBackground(Color(UIColor.systemBackground))
                    .listRowSeparator(.hidden)
                }
                .navigationDestination(for: Card.self, destination: { card in
                    CardView(viewModel: CardViewModel(card: card, appManager: viewModel.appManager))
                        .onDisappear(perform: {
                            viewModel.refreshView()
                        })
                })
                .scrollIndicators(.hidden)
                .listStyle(.plain)
                .padding([.top], 20)
                .scrollContentBackground(.hidden)
            }
            .navigationBarTitle("SafeWallet", displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                viewModel.showingAddCardView = true
            }) {
                Image(systemName: "plus.circle")
            })
            .sheet(isPresented: $viewModel.showingAddCardView) {
                AddCardView(viewModel: AddCardViewModel(appManager: viewModel.appManager))
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.4)])
            }
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
        .padding(.horizontal)
    }
}

struct CardRow: View {
    var card: Card
    var onDelete: () -> Void

    @GestureState private var gestureDragOffset = CGSize.zero
    @State private var dragOffset = CGSize.zero
    @State private var shouldShowDeleteConfirmation = false

    var body: some View {
        ZStack {
            CardDetailsView(card: card, isUnlocked: .constant(false))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .cornerRadius(10)
            .shadow(radius: 5)
            .offset(x: dragOffset.width + gestureDragOffset.width)
            .gesture(
                DragGesture(minimumDistance: 30)
                    .updating($gestureDragOffset, body: { (value, state, _) in
                        let translationX = value.translation.width
                        if translationX < 0, translationX > -70 {
                            state = CGSize(width: translationX, height: 0)
                        }
                    })
                    .onEnded { value in
                        if value.translation.width < 0 {
                            if value.translation.width <= -50 {
                                withAnimation {
                                    dragOffset = .zero
                                    shouldShowDeleteConfirmation = true
                                }
                            }
                        }
                    }
            )

            .alert(isPresented: $shouldShowDeleteConfirmation) {
                Alert(
                    title: Text("Delete Card"),
                    message: Text("Are you sure you want to delete this card?"),
                    primaryButton: .default(Text("Cancel"), action: { shouldShowDeleteConfirmation = false }),
                    secondaryButton: .destructive(Text("Delete"), action: {
                        withAnimation {
                            onDelete()
                        }
                        shouldShowDeleteConfirmation = false
                    })
                )
            }

            // Swipe to delete overlay
            if gestureDragOffset.width < -10 {
                HStack {
                    Spacer()
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding()
                        .frame(width: abs(gestureDragOffset.width))
                }
            }
        }
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let cardNumbers = [
                    "4234 5678 0000 1111", "1234 5678 1111 2222", "1234 5678 2222 3333",
                    "1234 5678 3333 4444", "1234 5678 4444 5555", "1234 5678 5555 6666",
                    "1234 5678 6666 7777", "1234 5678 7777 8888", "1234 5678 8888 9999", "1234 5678 9999 0000"
                ]
                let expiryDates = [
                    "12/25", "11/24", "10/23", "09/22", "08/21",
                    "07/20", "06/19", "05/18", "04/17", "03/16"
                ]
                let cvvCodes = [
                    "123", "234", "345", "456", "567",
                    "678", "789", "890", "901", "012"
                ]
                let cardNames = [
                    "Visa", "MasterCard", "Amex", "Discover", "UnionPay",
                    "JCB", "Maestro", "Visa Electron", "Mir", "Troy"
                ]

                for i in 0..<cardNumbers.count {
                    let newCard = Card(context: context)
                    newCard.cardNumber = cardNumbers[i]
                    newCard.expiryDate = expiryDates[i]
                    newCard.cvvCode = cvvCodes[i]
                    newCard.cardName = cardNames[i]
                }
                try context.save()
            }
        } catch {
            print("Error fetching or saving mock cards: \(error)")
        }

        return CardListView(viewModel: CardListViewModel(appManager: AppManager(context: context)))
            .environment(\.managedObjectContext, context)
    }
}
