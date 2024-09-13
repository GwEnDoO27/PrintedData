//
//  ContentView.swift
//  PrintedData
//
//  Created by Gwendal Benard on 05/09/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPressedButton1 = false
    @State private var isPressedButton2 = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Premier groupe de navigation pour les impressions
                HStack {
                    Text("Your print")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Spacer()
                    NavigationLink("+", destination: AddingNewprint())
                        .padding()
                        .font(.title)
                        .background(isPressedButton1 ? Color.blue.opacity(0.6) : Color.blue)
                        .foregroundColor(.white)
                    .clipShape(Circle())
                    .scaleEffect(isPressedButton1 ? 0.95 : 1.0) // Réduction de la taille lors de l'appui
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPressedButton1.toggle() // Gérer l'effet d'appui visuel
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isPressedButton1.toggle() // Revenir à l'état normal après l'animation
                        }
                    }
                    
                }
                .padding()
                Spacer()
                
                CustomTimePickerView()
                
                Spacer()
                        
                // Deuxième groupe de navigation pour les données
                ZStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    NavigationLink("Anciens Prints", destination: OldsData())
                        .padding()
                        .font(.title)
                        .background(isPressedButton2 ? Color.green.opacity(0.6) : Color.green)
                        .foregroundColor(.white)
                    .clipShape(Capsule())
                    .scaleEffect(isPressedButton2 ? 0.95 : 1.0)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPressedButton2.toggle() // Gérer l'effet d'appui visuel
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isPressedButton2.toggle() // Revenir à l'état normal après l'animation
                        }
                    }
                    Spacer()
                    
                }
                .padding()
                
            }
        }
    }
}




#Preview{
    ContentView()
}



