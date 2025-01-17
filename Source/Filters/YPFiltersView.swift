//
//  YPFiltersView.swift
//  photoTaking
//
//  Created by Sacha Durand Saint Omer on 21/10/16.
//  Copyright © 2016 octopepper. All rights reserved.
//

import Stevia

class YPFiltersView: UIView {
    
    let imageView = UIImageView()
    var collectionView: UICollectionView!
    var filtersLoader: UIActivityIndicatorView!
    var bottomLayoutGuide: UILayoutSupport!
    
    let captionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        return textView
    }()
    fileprivate let filterMenuItem: YPMenuItem = {
        let item = YPMenuItem()
        item.textLabel.text = YPConfig.wordings.filter
        item.button.addTarget(self, action: #selector(selectFilter), for: .touchUpInside)
        return item
    }()
    fileprivate let captionMenuItem: YPMenuItem = {
        let item = YPMenuItem()
        item.textLabel.text = YPConfig.wordings.caption
        item.button.addTarget(self, action: #selector(selectCaption), for: .touchUpInside)
        item.select()
        return item
    }()
    fileprivate let buttonsContainer: UIView = UIView()
    fileprivate let collectionViewContainer: UIView = UIView()
    fileprivate let captionContainer: UIView = UIView()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout())
        filtersLoader = UIActivityIndicatorView(style: .gray)
        filtersLoader.hidesWhenStopped = true
        filtersLoader.startAnimating()
        filtersLoader.color = YPConfig.colors.tintColor
        
        sv(
            imageView,
            collectionViewContainer.sv(
                filtersLoader,
                collectionView
            ),
            captionContainer.sv(
                captionTextView
            ),
            buttonsContainer.sv(
                captionMenuItem,
                filterMenuItem
            )
        )
        
        let isIphone4 = UIScreen.main.bounds.height == 480
        let sideMargin: CGFloat = isIphone4 ? 20 : 0
        
        |-sideMargin-imageView.top(0)-sideMargin-|
        |-sideMargin-collectionViewContainer-sideMargin-|
        |-sideMargin-buttonsContainer-sideMargin-|
        |-sideMargin-captionContainer-sideMargin-|
        
        captionContainer.Bottom == buttonsContainer.Top
        imageView.Bottom == captionContainer.Top
        
        captionTextView.fillContainer(20)
        
        collectionViewContainer.Bottom == buttonsContainer.Top
        imageView.Bottom == collectionViewContainer.Top
        
        if #available(iOS 11.0, *) {
            buttonsContainer.Bottom == safeAreaLayoutGuide.Bottom
        } else {
            buttonsContainer.Bottom == bottomLayoutGuide.Bottom
        }
        
        equal(widths: [filterMenuItem, captionMenuItem])
        |-sideMargin-captionMenuItem-filterMenuItem-sideMargin-|
        filterMenuItem.fillVertically()
        captionMenuItem.fillVertically()
        
        |collectionView.centerVertically().height(160)|
        filtersLoader.centerInContainer()
        
        imageView.heightEqualsWidth()
        
        backgroundColor = UIColor(r: 247, g: 247, b: 247)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionViewContainer.isHidden = true
        captionContainer.isHidden = false
    }
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        layout.itemSize = CGSize(width: 100, height: 120)
        return layout
    }
    
    @objc public func selectFilter() {
        collectionViewContainer.isHidden = false
        captionContainer.isHidden = true
        captionMenuItem.deselect()
        filterMenuItem.select()
    }
    
    @objc public func selectCaption() {
        collectionViewContainer.isHidden = true
        captionContainer.isHidden = false
        captionMenuItem.select()
        filterMenuItem.deselect()
    }
}
