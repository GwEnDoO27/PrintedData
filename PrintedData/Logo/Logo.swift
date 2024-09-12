//
//  Logo.swift
//  PrintedData
//
//  Created by Gwendal Benard on 06/09/2024.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        ZStack {
            // Outer black circle (main disc)
            Circle()
                .fill(Color.black)
                .frame(width: 200, height: 200)
            
            
            // First Circle
            Group {
                Circle()
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red, Color.orange]), startPoint: .top, endPoint: .bottom),
                        lineWidth: 20
                    )
                    .position(CGPoint(x: 85.0, y: 85.0))
                    .frame(width: 170, height: 170)
                Circle()
                    .stroke(
                        Color.pink,
                        lineWidth: 20
                    )
                    .position(CGPoint(x: 87.0, y: 85.0))
                    .frame(width: 170, height: 170)
                
            }
            
            
            
            //Seconde Circle
            Group {
                Circle()
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red, Color.orange]), startPoint: .top, endPoint: .bottom),
                        lineWidth: 20
                    )
                    .position(CGPoint(x: 90.0, y: 86))
                    .frame(width: 170, height: 170)
                
                Circle()
                    .stroke(
                        Color.pink,
                        lineWidth: 20
                    )
                    .position(CGPoint(x: 93.0, y: 86))
                    .frame(width: 170, height: 170)
            }
            
            //third Circle
            Group {
                Circle()
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red, Color.orange]), startPoint: .top, endPoint: .bottom),
                        lineWidth: 20
                    )
                    .position(CGPoint(x: 96.0, y: 87))
                    .frame(width: 170, height: 170)
                
                Circle()
                    .stroke(
                        Color.pink,
                        lineWidth: 20
                    )
                    .position(CGPoint(x: 99.0, y: 87))
                    .frame(width: 170, height: 170)
            }
            
            
            
            //fourth Circle
            Group {
                Circle()
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red, Color.orange]), startPoint: .top, endPoint: .bottom),
                        lineWidth: 20
                    )
                    .position(CGPoint(x: 101.0, y: 88))
                    .frame(width: 170, height: 170)
                
                Circle()
                    .stroke(
                        Color.pink,
                        lineWidth: 20
                    )
                    .position(CGPoint(x: 104.0, y: 88))
                    .frame(width: 170, height: 170)
                
                
            }
            
            
            Group {
                Circle()
                    .fill(Color.black)
                    .frame(width: 200, height: 200)
                    .position(CGPoint(x: 220.0, y: 390.0))
                // Inner white circle (hole)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .position(CGPoint(x: 220.0, y: 390.0))
            }
            
        }
    }
}




#Preview {
    Logo()
}


