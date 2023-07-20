//
//  StatusView.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 19/07/2023.
//

import SwiftUI

struct StatusView: View {
    let status: Character.Status

    var body: some View {
        Text(status.name)
            .font(.caption)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(status.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension Character.Status {
    var accentColor: Color {
        switch self {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .gray
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(status: .alive)
    }
}
