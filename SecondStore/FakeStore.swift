//
//  FakeStore.swift
//  SecondStore
//
//  Created by Carlos Rafael Reyes Magadán on 2/26/23.
//

import Foundation

let urlProduct = "https://fakestoreapi.com/products/"
let urlProducts = "https://fakestoreapi.com/products"

enum NetworkError: Error {
    case invalidCode
    case invalidURL
}

enum FakeStoreAPI {
    static func getProduct(idProduct: Int) async throws -> [ProductJSON] {
        do {
            let product = try await loadSingleJSON(from: urlProduct + String(idProduct), for: ProductJSON.self)
            return [product]
        } catch {
            print("Error getting latest launches: \(error)")
        }
        return []
    }
    
    static func getProducts() async throws -> [ProductJSON] {
        do {
            let products = try await loadArrayJSON(from: urlProducts, for: ProductJSON.self)
            return products
        } catch {
            print("Error getting latest launches: \(error)")
        }
        return []
    }
    
    private static func loadSingleJSON<T: Codable>(from urlString: String, for type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidCode
        }
        let jsonObjects: T = try JSONDecoder().decode(T.self, from: data)
        return jsonObjects
    }
    
    private static func loadArrayJSON<T: Codable>(from urlString: String, for type: T.Type) async throws -> [T] {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidCode
        }
        let jsonObjects: [T] = try JSONDecoder().decode([T].self, from: data)
        return jsonObjects
    }
}

