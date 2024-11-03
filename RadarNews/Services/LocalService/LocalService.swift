//
//  LocalService.swift
//  RadarNews
//
//  Created by Mahmoud  on 02/11/2024.
//

import Foundation
import CoreData
import UIKit

protocol LocalService{
    func storeNews(news:News)
    func fetchNews()->[News]
}

class NewsStorage: LocalService {
    static let shared = NewsStorage()
    private init(){}
    private var mangedContext: NSManagedObjectContext{
        guard let appDelegate = UIApplication.shared.delegate as?
                AppDelegate else{
            fatalError("could not retrieve app delegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeNews(news: News) {
        let checkarr = fetchNews()
        if checkarr.contains(news){
            print("it'ss already exist as favorite")
        }else{
            guard let newsEntity = NSEntityDescription.entity(forEntityName: "FavNews", in: mangedContext) else{return}
            let newsObject = NSManagedObject(entity: newsEntity, insertInto: mangedContext)
            newsObject.setValue(news.title, forKey: "title")
            newsObject.setValue(news.author, forKey: "author")
            newsObject.setValue(news.description, forKey: "descript")
            newsObject.setValue(news.urlToImage, forKey: "imgUrl")
            do{
                try mangedContext.save()
                print("news saved successfully")
            }catch{
                print("error saving news \(error)")
            }
        }
    }
    func fetchNews() -> [News] {
        var newsArr = [News]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavNews")
        do{
            let result = try mangedContext.fetch(fetchRequest) as![NSManagedObject]
            for newsManged in result {
                let news = News(author: newsManged.value(forKey: "author") as? String, title: newsManged.value(forKey: "title") as! String, description: newsManged.value(forKey: "descript") as? String,urlToImage: newsManged.value(forKey: "imgUrl") as? String)
                newsArr.append(news)
            }
        }catch{
            print("Error fetching movies")
        }
        return newsArr
    }
    
    
}
