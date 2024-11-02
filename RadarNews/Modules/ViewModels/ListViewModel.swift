//
//  ListViewModel.swift
//  RadarNews
//
//  Created by Mahmoud  on 01/11/2024.
//

import Foundation
import Combine

protocol NewsViewModelProtocol: AnyObject {
    var news: [News] { get }
    var searchNews:[News] { get }
    var errorMessage: String? { get }
    var selectedNews: News?{get}
    func getNews(query: String, from: String)
}

class ListViewModel:ObservableObject,NewsViewModelProtocol{
    @Published var news: [News] = []
    @Published var searchNews:[News] = []
    @Published var errorMessage : String?
    @Published var selectedNews: News?
    
    private let remoteService : RemoteService!
    private var cancellables = Set<AnyCancellable>()
    init(remoteService:RemoteService){
        self.remoteService = remoteService
    }
    
    func getNews(query:String, from:String){
        remoteService.fetchNews(query: query, fromDate: from)
            .sink(receiveCompletion: { completion in
                           switch completion {
                           case .failure(let error):
                               self.errorMessage = error.localizedDescription
                               print("Error fetching news: \(error.localizedDescription)")
                           case .finished:
                               break
                           }
                       }, receiveValue: { [weak self] news in
                           self?.news = news
                           self?.searchNews = news
                       })
                       .store(in: &cancellables)

    }
    
    func filterNews(searchText:String){
        if searchText.isEmpty {
            searchNews = news
        }else{
            searchNews = news.filter{
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
