//
//  HeroListPresenter.swift
//  HeroApp
//
//  Created by Carlos Osuna on 18/02/21.
//

import Foundation

protocol HeroListViewDelegate: NSObjectProtocol {
    func setHeroes(_ heroes:[Hero])
    func setEmptyHeroes()
    func showHeroDetail(_ hero:Hero)
}

class HeroListPresenter {
    
    enum ScreenStatus {
        case showing,
        empty
    }
    
    private let heroListService: HeroListService
    weak private var heroListViewDelegate: HeroListViewDelegate?
    
    private var screenStatus: ScreenStatus = .empty
    
    private var lastSearch: String = ""
    
    init(heroListService: HeroListService) {
        self.heroListService = heroListService
    }
    
    // MARK: - Utils
    
    func setViewDelegate(heroListViewDelegate: HeroListViewDelegate?) {
        self.heroListViewDelegate = heroListViewDelegate
    }
    
    
    func getHeroesBySearch(_ text: String) {
        guard text != "", lastSearch != text else { return }
        lastSearch = text
        heroListService.getHeroBy(searchText: text) { [weak self] (response) in
            self?.screenStatus = .showing
            self?.heroListViewDelegate?.setHeroes(response)
        } failure: { (error) in
            self.screenStatus = .empty
            self.heroListViewDelegate?.setEmptyHeroes()
        }
    }
    
    func getBanners() -> [Hero] {
        return heroListService.getBannerInfo()
    }
    
    func getHeroInformationFromBaner(_ hero: Hero) {
        heroListService.getHeroBy(id: hero.id ?? 0) { (response) in
            self.heroListViewDelegate?.showHeroDetail(response)
        } failure: { (error) in
        }
    }

    /*
     Obtiene el estado actual de la vista
     - returns: ScreenStatus
     */
    func getScreenStatus() -> ScreenStatus {
        return screenStatus
    }
}
