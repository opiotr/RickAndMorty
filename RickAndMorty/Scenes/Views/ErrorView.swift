//
//  ErrorView.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 20/07/2023.
//

import SwiftUI

struct ErrorView: View {
    let action: () -> Void

    var body: some View {
        VStack {
            Text("Oops! Something went wrong.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .bold()

            Button(action: action) {
                Text("Try again")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(action: {})
    }
}
