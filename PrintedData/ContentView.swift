//
//  ContentView.swift
//  PrintedData
//
//  Created by Gwendal Benard on 05/09/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            NavigationView {
                VStack {
                    Text("Bienvenue dans l'application")
                        .font(.largeTitle)
                        .padding()
                    
                    NavigationLink(destination: AddingNewprint()) {
                        Text("Accéder au Formulaire")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .navigationTitle("Your Prints")
            }
        }

}


