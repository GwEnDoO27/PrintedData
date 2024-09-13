//
//  ContentView.swift
//  PrintedData
//
//  Created by Gwendal Benard on 05/09/2024.
//

import SwiftUI

struct ContentView: View {
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
                        .background(Color.blue)
                        .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                }
                .padding()
                Spacer()
                        
                // Deuxième groupe de navigation pour les données
                ZStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    NavigationLink("Données", destination: OldsData())
                        .padding()
                        .font(.title)
                        .background(Color.green)
                        .foregroundColor(.white)
                    .clipShape(Capsule())
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



