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

struct News: Codable {
    let author: String?
    let title : String
    let description: String?
    let publishedAt: String
    let urlToImage: String?
}

