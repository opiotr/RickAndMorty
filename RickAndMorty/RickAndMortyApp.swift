//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
