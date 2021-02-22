//
//  HeroListService.swift
//  HeroApp
//
//  Created by Carlos Osuna on 18/02/21.
//

import Foundation

class HeroListService {
  
    func getHeroBy(searchText: String, success: @escaping ([Hero]) -> Void, failure: @escaping (Error?) -> Void) {
        let URL = "\(SuperHeroAPI.baseURL)search/\(searchText.removeWhitespace())"
        print(URL)
        SuperHeroAPI().GET(URL, params: nil) { (response) in
            if let data = response as? Dictionary<String, Any>, let results = data["results"] as? Array<Any> {
                let heroes = results.map { return Hero($0 as! Dictionary<String, Any>)}
                success(heroes)
            } else {
                failure(nil)
            }
        } failure: { (error) in
            print(error ?? "")
            failure(error)
        }
    }
    
    /*
     */
    func getHeroBy(id: Int, success: @escaping (Hero) -> Void, failure: @escaping (Error) -> Void) {
        let URL = "\(SuperHeroAPI.baseURL)\(id)"
        print(URL)
        SuperHeroAPI().GET(URL, params: nil) { (response) in
            if let data = response as? Dictionary<String, Any> {
                print(data)
                success(Hero(data))
            }
        } failure: { (error) in
            print(error ?? "")
        }
    }
    
    /**
        Mock Data de heroes para mostrar en banner, regresa listado de heroes
     - returns: [Hero]
     */
    func getBannerInfo() -> [Hero]  {
        return [
            Hero(76, imageURL: "https://www.superherodb.com/pictures2/portraits/10/100/640.jpg"),
            Hero(346, imageURL: "https://www.superherodb.com/pictures2/portraits/10/100/85.jpg"),
            Hero(434, imageURL: "https://www.superherodb.com/pictures2/portraits/10/100/958.jpg"),
            Hero(157, imageURL: "https://www.superherodb.com/pictures2/portraits/10/100/103.jpg"),
            Hero(149, imageURL: "https://www.superherodb.com/pictures2/portraits/10/100/274.jpg"),
            Hero(441, imageURL: "https://www.superherodb.com/pictures2/portraits/10/100/96.jpg")   
        ]
    }
}
