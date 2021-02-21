//
//  Hero.swift
//  HeroApp
//
//  Created by Carlos Osuna on 18/02/21.
//

import UIKit

struct Hero {
    var id: Int?
    var name: String?
    var fullName: String?
    var imageURL: String?
    var occupation: String?
    var publisher: String?
    var firstAppearance: String?
    var gender: String?
    var race: String?
    var height: String?
    var weight: String?

    var powerstats: [PowerStat]?
    
    init(_ data: Dictionary<String,Any>) {
        id = Int(data["id"] as? String ?? "0") ?? 0
        name = data["name"] as? String ?? ""
        if let biography = data["biography"] as? Dictionary<String,Any> {
            fullName = biography["full-name"] as? String ?? ""
            publisher = biography["publisher"] as? String ?? ""
            firstAppearance = biography["first-appearance"] as? String ?? ""
        }
        if let image = data["image"] as? Dictionary<String,Any> {
            imageURL = image["url"] as? String ?? ""
        }
        if let work = data["work"] as? Dictionary<String,Any> {
            occupation = work["occupation"] as? String ?? ""
        }
        if let powerstatsData = data["powerstats"] as? Dictionary<String, Any> {
            powerstats = [PowerStat]()
            powerstatsData.forEach {
                let powerStat = PowerStat(name: $0.key, value: Int($0.value as? String ?? "0") ?? 0)
                powerstats?.append(powerStat)
            }
        }
        if let appearance = data["appearance"] as? Dictionary<String, Any> {
            gender = appearance["gender"] as? String ?? ""
            race = appearance["race"] as? String ?? ""
            height = (appearance["height"] as! Array<String>).last ?? "No Available"
            weight = (appearance["weight"] as! Array<String>).last ?? "No Available"
        }
    }
    
    init(_ id: Int, imageURL: String? = "") {
        self.id = id
        self.imageURL = imageURL
    }
}

struct PowerStat {
    var name: String?
    var value: Int?
}
