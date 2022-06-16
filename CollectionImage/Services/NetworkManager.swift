//
//  Networking.swift
//  CollectionImage
//
//  Created by Назар Ткаченко on 05.05.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    let linkURL = "https://api.unsplash.com/photos/random/?count=30&client_id=M6TAvy5WJO62ZTi2rMVe22y1mY5o-ZjvDUNpFDFM82M"
    
    func fetchCollection(url: String) async throws -> [ImageElement] {
        guard let url = URL(string: url)
        else {
            throw NetworkError.invalidURL
        }
        let (data,_) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let collection = try? decoder.decode([ImageElement].self, from: data) else {
            throw NetworkError.decodingError
        }
        return collection
    }
    func fetchResult(url: String) async throws -> ImageResult {
        guard let url = URL(string: url)
        else {
            throw NetworkError.invalidURL
        }
        let (data,_) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let collection = try? decoder.decode(ImageResult.self, from: data) else {
            throw NetworkError.decodingError
        }
        return collection
    }
    
    func fetchImage(from url: URL) async throws -> Data {
        let (data,_) = try await URLSession.shared.data(from: url)
        return data
    }
    
    //MARK: - URL
    func request(searchTerm: String) -> String {
        
        let parameters = self.prepareParameters(searchTerm: searchTerm)
        let url = self.url(parameters: parameters)
        let request = URLRequest(url: url)
        guard var webUrl = request.url?.absoluteString else { return "error request"}
        webUrl = "\(webUrl)" + "&client_id=M6TAvy5WJO62ZTi2rMVe22y1mY5o-ZjvDUNpFDFM82M"
        return webUrl
    }
    
    private func prepareParameters(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["per_page"] = String(30)
        return parameters
    }
    
    private func url(parameters: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = parameters.map{ URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
}
