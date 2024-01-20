//
//  ColorCarouselView.swift
//  SafeWallet
//
//  Created by Gonçalo on 20/01/2024.
//

import SwiftUI

struct ColorCarouselView: View {
    @Binding var cardColor: String
    @StateObject var viewModel: ColorCarouselViewModel
    private let colorCircleSize: CGFloat = 40
    
    let colors: [String] = ["red", "orange" , "purple", "systemBackground", "gray","green"]

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(colors, id: \.self) { colorName in
                        let color = Color(wordName: colorName)?.opacity(viewModel.getCardBackgroundOpacity()) ?? .clear
                        Circle()
                            .fill(color)
                            .frame(width: colorCircleSize, height: colorCircleSize)
                            .overlay(
                                Circle()
                                    .stroke(Color.clear)
                            )
                            .scaleEffect(cardColor == colorName ? 1.2 : 1.0)
                            .shadow(color: Color(uiColor: .inverseSystemBackground), radius: 0)
                            .onTapGesture {
                                withAnimation {
                                    self.cardColor = colorName
                                }
                            }
                    }
                }
                .frame(width: geometry.size.width)
                .frame(height: colorCircleSize * 1.4)
            }
        }
        .frame(height: colorCircleSize * 1.4)
    }
}
