//
//  HomeViewDelegate.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/19.
//

import UIKit

protocol HomeViewDelgate: AnyObject {
    func didTapMoreButton(_ sender: UIButton)
}

protocol HomeCollectionViewMainBannerCellDelegate: AnyObject {
    func mainBannerCellCollectionView(didSelectItemAt indexPath: IndexPath)
}
