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
    @ObservedObject var viewModel = CardListViewModel()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.holderName, ascending: true)],
        animation: .default)
    var cards: FetchedResults<Card>

    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                    .background(Color.white)

                List {
                    ForEach(cards.filter {
                        viewModel.searchText.isEmpty ||
                        $0.holderName.contains(viewModel.searchText) ||
                        $0.cardNumber.contains(viewModel.searchText)
                    }, id: \.self) { card in
                        CardRow(card: card)
                            .padding(.vertical, 10)
                            .listRowInsets(EdgeInsets())
                    }
                    .listRowBackground(Color.white)
                    
                }
                .scrollIndicators(.hidden)
                .listStyle(.plain)
                .padding([.top, .leading, .trailing], 20)
                .scrollContentBackground(.hidden)
                
            }
            .navigationBarTitle("SafeWallet", displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                viewModel.showingAddCardView = true
            }) {
                Image(systemName: "plus.circle")
            })
            .sheet(isPresented: $viewModel.showingAddCardView) {
                AddCardView(viewModel: AddCardViewModel(context: viewContext))
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}

struct CardRow: View {
    var card: Card

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(card.holderName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text(card.cardName)
                        .font(.caption)
                        .foregroundColor(.white)
                }
                Spacer()
                Text(card.cardNumber)
                    .font(.title3)
                    .foregroundColor(.white)
                Spacer()
                HStack {
                    Text("Expires: \(card.expiryDate)")
                        .font(.footnote)
                        .foregroundColor(.white)
                    Spacer()
                    Text("CVC: \(card.cvvCode)")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                }
            }
            .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}



struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
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

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        // Check for existing mock data using a fetch request.
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "holderName != nil")
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let holderNames = [
                    "Alice Smith", "Bob Johnson", "Charlie Brown",
                    "David Wilson", "Emma Harris", "Frank Clark",
                    "Grace Davis", "Henry Miller", "Isabella Taylor", "Jack Anderson"
                ]
                let cardNumbers = [
                    "1234 5678 0000 1111", "1234 5678 1111 2222", "1234 5678 2222 3333",
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

                for i in 0..<holderNames.count {
                    let newCard = Card(context: context)
                    newCard.holderName = holderNames[i]
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

        return CardListView().environment(\.managedObjectContext, context)
    }
}


