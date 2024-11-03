//
//  NewsModel.swift
//  RadarNews
//
//  Created by Mahmoud  on 01/11/2024.
//

import Foundation

struct NewsResponse: Codable {
    let articles: [News]
}

struct News: Codable,Hashable {
    let author: String?
    let title : String
    let description: String?
    let urlToImage: String?
}

