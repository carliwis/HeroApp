//
//  HeroDetailPresenter.swift
//  HeroApp
//
//  Created by Carlos Osuna on 18/02/21.
//

import Foundation

protocol HeroDetailViewDelegate: NSObjectProtocol {
    func setProfileDescription(title: String, name: String, occupation: String,  imageURL:String)
    func setAboutDescription(gender: String, race: String, height: String, weight: String, firstAppearance: String)
}

class HeroDetailPresenter {
    private let heroDetailService: HeroDetailService
    weak private var heroDetailViewDelegate: HeroDetailViewDelegate?
    
    init(heroDetailService: HeroDetailService) {
        self.heroDetailService = heroDetailService
    }
    
    // MARK: - Utils
    
    func setViewDelegate(heroDetailViewDelegate: HeroDetailViewDelegate?) {
        self.heroDetailViewDelegate = heroDetailViewDelegate
    }
    
    func getProfileDescriptionBy(hero: Hero?) {
        guard let hero = hero else { return }
        let name = "\(hero.name ?? "") \(hero.publisher != nil ? "· \(hero.publisher!)" : "")"
        self.heroDetailViewDelegate?.setProfileDescription(title: hero.fullName ?? "", name: name, occupation: hero.occupation ?? "", imageURL: hero.imageURL ?? "")
        
        self.heroDetailViewDelegate?.setAboutDescription(
            gender: hero.gender ?? "",
            race: hero.race ?? "",
            height: hero.height ?? "",
            weight: hero.weight ?? "",
            firstAppearance: hero.firstAppearance ?? "")
    }
    
}
