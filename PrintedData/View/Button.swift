//
//  Button.swift
//  PrintedData
//
//  Created by Gwendal Benard on 12/09/2024.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
            Spacer()
        }
        .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
        .font(.system(.title2, design: .rounded).bold())
        .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
        .foregroundColor(.yellow)
        .scaleEffect(configuration.isPressed ? 1.2 : 1)
        .background {
            Capsule()
                .stroke(.yellow, lineWidth: 2)
        }
    }
}



