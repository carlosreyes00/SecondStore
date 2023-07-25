//
//  ContentView.swift
//  SecondStore
//
//  Created by Carlos Rafael Reyes Magadán on 2/26/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.id, ascending: true)],
        animation: .default)
    private var coreDataProducts: FetchedResults<Product>
    
    @State var products: [ProductJSON] = []
    
    @State var showItems = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(products, id: \.self) { product in
                    NavigationLink {
                        Text("Detail view of:\n\(product.title!)")
                    } label: {
                        VStack (alignment: .leading) {
                            Text("\(product.id!)")
                            Text("\(product.title!)")
                                .lineLimit(1)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            addItem(product)
                        } label: {
                            Label("Save", systemImage: "plus.circle")
                        }
                        .tint(.accentColor)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        Task {
                            try await products = FakeStoreAPI.getProducts()
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
                ToolbarItem {
                    Button {
                        showItems = true
                    } label: {
                        Image(systemName: "cart")
                    }
                }
            }
            .sheet(isPresented: $showItems) {
                ItemsSaved(coreDataProducts: coreDataProducts)
            }
            Text("Select an item")
        }
    }
    
    private func addItem(_ product: ProductJSON) {
        withAnimation {
            let newItem = Product(context: viewContext)
            newItem.id = Int16(product.id!)
            newItem.title = product.title
            newItem.price = product.price!
            newItem.category = product.category
            newItem.notes = product.description
            newItem.image = product.image
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

struct ItemsSaved: View {
    var coreDataProducts: FetchedResults<Product>
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            List {
                ForEach(coreDataProducts, id: \.id) { product in
                    VStack {
                        VStack (alignment: .leading) {
                            Text("\(product.id)")
                            Text("\(product.title!)")
                                .lineLimit(1)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { coreDataProducts[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
