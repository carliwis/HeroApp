//
//  HeroDetailViewController.swift
//  HeroApp
//
//  Created by Carlos Osuna on 18/02/21.
//

import UIKit

private let heroCellIdentifier = "HeroCellIdentifier"

class HeroDetailViewController: UIViewController, HeroDetailViewDelegate {
    
    @IBOutlet weak var vwDecoration: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblRace: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblFirstComic: UILabel!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let heroDetailPresenter = HeroDetailPresenter(heroDetailService: HeroDetailService())
    var hero: Hero?
    
    var recomnendations = [Hero]()

    override func viewDidLoad() {
        super.viewDidLoad()
        heroDetailPresenter.setViewDelegate(heroDetailViewDelegate: self)
        
        setupView()
        heroDetailPresenter.getProfileDescriptionBy(hero: hero)
        
        setupCollectionView()
        setupLayout()
    }


    // MARK: - Utils
    
    func setupView() {
        thumbnailImageView.layer.cornerRadius = 75
        thumbnailImageView.layer.masksToBounds = true
        
        vwDecoration.layer.cornerRadius = 80
        vwDecoration.layer.masksToBounds = true
    }
    
    // MAR: - HeroDetailViewDelegate
    
    func setProfileDescription(title: String, name: String, occupation: String, imageURL:String) {
        navigationItem.title = title
        lblName.text = name
        lblOccupation.text = occupation
        thumbnailImageView.sd_setImage(with: URL(string: imageURL), completed: { (img:UIImage?, error:Error?, cacheType:SDImageCacheType,imageUrl:URL?) -> Void in
            if let img = img, error == nil {
                self.thumbnailImageView.image = img
            }
        })
    }
    
    func setAboutDescription(gender: String, race: String, height: String, weight: String, firstAppearance: String) {
        lblGender.text = gender
        lblRace.text = race
        lblHeight.text = height
        lblWeight.text = weight
        lblFirstComic.text = firstAppearance
    }
}

extension HeroDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    private func setupCollectionView() {
        let heroCellNib = UINib(nibName: "HeroCell", bundle: nil)
        self.collectionView.register(heroCellNib, forCellWithReuseIdentifier: heroCellIdentifier)
        
//        if recomnendations.count > 0 {
//            collectionHeightConstraint.constant = 200
//        } else {
//            collectionHeightConstraint.constant = 0
//        }
    }
    
    private func setupLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            let itemCount = 1

            let itemSize = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.absolute(self.view.frame.width / 2),
                heightDimension: NSCollectionLayoutDimension.fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitem: item, count: itemCount)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading:0, bottom: 10, trailing:0)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            return section
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recomnendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: heroCellIdentifier, for: indexPath) as! HeroCell
        cell.hero = recomnendations[indexPath.row]
        return cell
    }
    
    
}
