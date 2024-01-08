//
//  CardView.swift
//  SafeWallet
//
//  Created by Gonçalo on 08/01/2024.
//

import SwiftUI

struct CardView: View {
    var card: Card
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            CardDetailsView(card: card, isUnlocked: .constant(true))
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
                    // Perform remove action
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
        .navigationBarTitle(card.cardName, displayMode: .inline)
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
        
        return CardView(card: mockCard)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
