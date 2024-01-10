//
//  CardView.swift
//  SafeWallet
//
//  Created by Gonçalo on 08/01/2024.
//

import SwiftUI

struct CardView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: CardViewModel
    
    var body: some View {
        VStack {
            CardDetailsView(card: viewModel.card, isUnlocked: .constant(true))
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            
            Spacer()
            
            HStack(spacing: 30) {
                
                Button(action: {
                    // Perform share action
                }) {
                    Image(systemName: "square.and.arrow.up.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                .buttonStyle(RoundedButtonStyle())
                
                Button(action: {
                    viewModel.shouldShowDeleteConfirmation = true
                }) {
                    Image(systemName: "trash.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                .buttonStyle(RoundedButtonStyle())
            }
            .padding(.horizontal, 20)
        }
        .navigationBarTitle(viewModel.card.cardName, displayMode: .inline)
        .alert(isPresented: $viewModel.shouldShowDeleteConfirmation) {
            Alert(
                title: Text("Delete Card"),
                message: Text("Are you sure you want to delete this card?"),
                primaryButton: .default(Text("Cancel"), action: { viewModel.shouldShowDeleteConfirmation = false }),
                secondaryButton: .destructive(Text("Delete"), action: {
                    withAnimation {
                        viewModel.delete { result in
                            if result {
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                print("Error deleting the card")
                            }
                        }
                    }
                    viewModel.shouldShowDeleteConfirmation = false
                })
            )
        }
        .padding(.bottom, 20)
    }
}

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.primary.opacity(0.5) : Color.primary)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock Card object for the preview
        let mockCard = Card(context: PersistenceController.preview.container.viewContext)
        mockCard.cardName = "Visa"
        mockCard.cardNumber = "4234 5678 9012 3456"
        mockCard.expiryDate = "12/25"
        mockCard.cvvCode = "123"
        
        let cardViewModel = CardViewModel(card: mockCard)
        return CardView(viewModel: cardViewModel)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
