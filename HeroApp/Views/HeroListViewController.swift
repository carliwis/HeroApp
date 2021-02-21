//
//  HeroListViewController.swift
//  HeroApp
//
//  Created by Carlos Osuna on 18/02/21.
//

import UIKit

private let heroCellIdentifier = "HeroCellIdentifier"
private let defaultIdentifier = "EmptyViewCell"
private let headerIdentifier = "HeroListHeaderView"
private let bannerIdentifier = "BannerViewCell"

class HeroListViewController: UICollectionViewController {
    
    private let SECTION_BANNER = 0
    private let SECTION_HEROES = 1
    
    private let heroListPresenter = HeroListPresenter(heroListService: HeroListService())
    private var searchController = UISearchController(searchResultsController: nil)
    private var heroes: [Hero] = [Hero]()
    
    private var isGrid: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroListPresenter.setViewDelegate(heroListViewDelegate: self)
        
        setupCollectionView()
        setupSearchController()
        setupLayout()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == SECTION_BANNER {
            return 1
        }
        switch heroListPresenter.getScreenStatus() {
        case .empty:
            return 1
        case .showing:
            return heroes.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == SECTION_BANNER {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerIdentifier, for: indexPath) as? BannerViewCell else { return UICollectionViewCell() }
            cell.banners = heroListPresenter.getBanners()
            cell.delegate = self
            return cell
        } else {
            switch heroListPresenter.getScreenStatus() {
            case .empty:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultIdentifier, for: indexPath)
                return cell
            case .showing:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: heroCellIdentifier, for: indexPath) as! HeroCell
                cell.hero = heroes[indexPath.row]
                return cell
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == SECTION_HEROES {
            guard heroListPresenter.getScreenStatus() == .showing else { return }
            self.performSegue(withIdentifier: "toHeroDetail", sender: ["hero":heroes[indexPath.row],"recomendations":self.heroes])
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? HeroListHeaderView else {
            return HeroListHeaderView()
        }
        headerView.delegate = self
        return headerView
    }
    
    // MARK: - Utils
    
    private func setupLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            var itemCount = 1
            var itemHeight: CGFloat = 150
            if sectionIndex == self.SECTION_HEROES {
                itemHeight = self.isGrid ? 210 : 290
                itemCount = self.isGrid ? 2 : 1
            } else if sectionIndex == self.SECTION_BANNER {
                itemHeight = self.view.frame.width * 0.65
            }
            let itemSize = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(itemHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: itemCount)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading:0, bottom: 10, trailing:0)
            
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(sectionIndex == self.SECTION_BANNER ? 0.1 : 44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
            section.boundarySupplementaryItems = [headerItem]

            return section
        })
    }
    
    private func setupCollectionView() {
        let heroCellNib = UINib(nibName: "HeroCell", bundle: nil)
        self.collectionView.register(heroCellNib, forCellWithReuseIdentifier: heroCellIdentifier)
        
        let bannerCellNib = UINib(nibName: "BannerViewCell", bundle: nil)
        self.collectionView.register(bannerCellNib, forCellWithReuseIdentifier: bannerIdentifier)
        
        let emptyCellNib = UINib(nibName: "EmptyViewCell", bundle: nil)
        self.collectionView.register(emptyCellNib, forCellWithReuseIdentifier: defaultIdentifier)
        
        self.collectionView.register(UINib(nibName: "HeroListHeaderView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "HeroListHeaderView")
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar Heroe"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHeroDetail" {
            if let nextViewController = segue.destination as? HeroDetailViewController, let data = sender as? Dictionary<String,Any>,
               let hero = data["hero"] as? Hero, let recomendations = data["recomendations"] as? [Hero] {
                nextViewController.hero = hero
                nextViewController.recomnendations = recomendations
            }
        }
    }
    
}

extension HeroListViewController: HeroListViewDelegate {
    
    func setHeroes(_ heroes: [Hero]) {
        self.heroes = heroes
        self.collectionView.reloadData()
    }
    
    func setEmptyHeroes() {
        self.heroes = [Hero]()
        self.collectionView.reloadData()
    }
    
    
    func showHeroDetail(_ hero:Hero) {
        self.performSegue(withIdentifier: "toHeroDetail", sender:["hero":hero,"recomendations":self.heroes])
    }
}

extension HeroListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        heroListPresenter.getHeroesBySearch(searchController.searchBar.text ?? "")
    }
}

extension HeroListViewController: HeroListHeaderViewDelegate {
    
    func handleLayoutForm(isGrid: Bool) {
        guard self.isGrid != isGrid else { return}
        print("change")
        self.isGrid = isGrid
        self.collectionView.reloadData()
    }
}

extension HeroListViewController: BannerViewDelegate {
    func didBannerItemSelected(item: Hero) {
        heroListPresenter.getHeroInformationFromBaner(item)
    }
}
