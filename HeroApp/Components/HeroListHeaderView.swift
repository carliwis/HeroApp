//
//  HeroListHeaderView.swift
//  HeroApp
//
//  Created by Carlos Osuna on 19/02/21.
//

import UIKit

protocol HeroListHeaderViewDelegate {
    func handleLayoutForm(isGrid: Bool)
}

class HeroListHeaderView: UICollectionReusableView {

    var delegate: HeroListHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBOutlet weak var lblTitle: UILabel!

    // MARK: - IBAction

    @IBAction func handleGridLayout(_ sender: UIButton) {
        delegate?.handleLayoutForm(isGrid: true)
    }

    @IBAction func handleListLayout(_ sender: UIButton) {
        delegate?.handleLayoutForm(isGrid: false)
    }

    
}
