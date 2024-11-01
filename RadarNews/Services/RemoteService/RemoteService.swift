//
//  RemoteService.swift
//  RadarNews
//
//  Created by Mahmoud  on 01/11/2024.
//

import Foundation
import Combine

protocol RemoteService{
    func fetchNews(query: String, fromDate: String)-> AnyPublisher<[News], Error>
}

class Remote:RemoteService{
    private let apiKey = "eb45cdda738448a18ec014a56e9215e8"
    
    func fetchNews(query: String, fromDate: String) -> AnyPublisher<[News], Error> {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=apple&from=\(fromDate)&sortBy=publishedAt&apiKey=\(apiKey)") else{
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .map{$0.articles}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
}
