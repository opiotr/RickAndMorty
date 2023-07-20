//
//  PlaceholderImage.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 19/07/2023.
//

import SwiftUI

struct PlaceholderImage: View {
    var body: some View {
        Image(systemName: "camera.circle.fill")
            .resizable()
    }
}

struct PlaceholderImage_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderImage()
    }
}
