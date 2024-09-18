//
//  ContentView.swift
//  PrintedData
//
//  Created by Gwendal Benard on 05/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isPressedButton2 = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    headerView
                    Spacer()
                    CustomTimePickerView()
                    Spacer()
                    oldPrintsButton
                }
                .padding()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Your Print")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
            
            NavigationLink(destination: AddingNewprint()) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
    
    private var oldPrintsButton: some View {
        NavigationLink(destination: OldsData()) {
            Text("Anciens Prints")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(15)
                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
        }
        .scaleEffect(isPressedButton2 ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressedButton2)
        .onTapGesture {
            isPressedButton2 = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isPressedButton2 = false
            }
        }
    }
}



#Preview{
    ContentView()
}



