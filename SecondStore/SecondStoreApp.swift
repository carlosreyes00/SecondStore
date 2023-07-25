//
//  SecondStoreApp.swift
//  SecondStore
//
//  Created by Carlos Rafael Reyes Magadán on 2/26/23.
//

import SwiftUI

@main
struct SecondStoreApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
