//
//  BannerViewCell.swift
//  HeroApp
//
//  Created by Carlos Osuna on 20/02/21.
//

import UIKit
import DKCarouselView

protocol BannerViewDelegate {
    func didBannerItemSelected(item:Hero)
}

class BannerViewCell: UICollectionViewCell {
    
    var delegate:BannerViewDelegate?
    
    var banners: [Hero]? {
        didSet {
            guard let _ = banners else { return }
            setUpBannerViewSettins()
        }
    }
    
    private var bannerView:DKCarouselView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Utils
    private func setUpBannerViewSettins() {
        guard let banners = self.banners, bannerView == nil else { return }
        bannerView = DKCarouselView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        var items = [AnyObject]()
        for banner in banners.enumerated() {
            let carouselItem = DKCarouselURLItem()
            carouselItem.imageUrl = banner.element.imageURL ?? ""
            items.append(carouselItem)
        }
        bannerView.setItems(items)
        bannerView.setAutoPagingForInterval(10)
        
        self.addSubview(bannerView)
        
        bannerView.setDidSelect { (item: DKCarouselItem?, index: Int) in
            guard index <= banners.count  else { return }
            self.delegate?.didBannerItemSelected(item: banners[index])
        }
    }
}
