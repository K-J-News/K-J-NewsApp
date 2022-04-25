//
//  APICaller.swift
//  K & J News
//
//  Created by Karan on 4/10/22.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=71105b4a980545dfa03385349ddad2a4")
        static let searchUrlString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=71105b4a980545dfa03385349ddad2a4&q="
    }
    
    private init () {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func getUserTopStories(lang: String, country: String, completion: @escaping (Result<[Article], Error>) -> Void){
        guard !lang.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        guard !country.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        
        let urlString = ("https://newsapi.org/v2/top-headlines?apiKey=cf4487e5702f48a1bbcd43901c508fcb&language=\(lang)&country\(country)")
        guard let url = URL(string: urlString) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void){
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

//Models

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable{
 let name: String
}
