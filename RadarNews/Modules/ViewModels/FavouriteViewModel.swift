//
//  FavouriteViewModel.swift
//  RadarNews
//
//  Created by Mahmoud  on 02/11/2024.
//

import Foundation

protocol favourite{
    func getFavourit()
    var favArr : [News]{get}
}

class FavouriteViewModel:favourite{
    var favArr : [News] = []
    let local : LocalService!
    init() {
        local = NewsStorage.shared
    }
    func getFavourit(){
        favArr = local.fetchNews()
    }
}
