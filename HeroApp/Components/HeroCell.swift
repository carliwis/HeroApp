//
//  HeroCell.swift
//  HeroApp
//
//  Created by Carlos Osuna on 18/02/21.
//

import UIKit

class HeroCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var backgroundImageView: UIView!
    
    var hero: Hero? {
        didSet {
            lblName.text = hero?.name
            lblFullName.text = hero?.fullName
            setupThumbnailImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       setupViews()
    }
    
    // MARK: - Utils
    
    func setupViews() {
        thumbnailImageView.layer.cornerRadius = 5
        thumbnailImageView.layer.masksToBounds = true
        
        backgroundImageView.layer.cornerRadius = 5
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.setShadow(offset: CGSize(width: 0, height: 0))
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageURL = hero?.imageURL {
            thumbnailImageView.sd_setImage(with: URL(string: thumbnailImageURL), completed: { (img:UIImage?, error:Error?, cacheType:SDImageCacheType,imageUrl:URL?) -> Void in
                if let img = img, error == nil {
                    self.thumbnailImageView.image = img
                }
            })
        }
    }

}
