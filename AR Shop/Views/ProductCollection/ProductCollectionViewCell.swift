//
//  ProductCollectionViewCell.swift
//  AR Shop
//
//  Created by Neel Mewada on 29/04/21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    // MARK: - Properties
    
    private var product: Product? = nil
    private var tapCallback: ((Product?) -> ())? = nil
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setDimensions(height: 170, width: 167)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Poppins-SemiBold", size: 11)
        label.numberOfLines = 0
        label.textColor = Constants.primaryBlackColor
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.font = UIFont(name: "Poppins-SemiBold", size: 15)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Actions
    
    @objc private func cellTapped() {
        print("Cell tapped")
        tapCallback?(product)
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = .clear
        
        addSubview(thumbnailView)
        thumbnailView.anchor(top: topAnchor)
        thumbnailView.centerX(inView: self)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: thumbnailView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        
        addSubview(priceLabel)
        priceLabel.anchor(top: titleLabel.bottomAnchor, paddingTop: 8)
        priceLabel.centerX(inView: self)
        
        self.anchor(bottom: priceLabel.bottomAnchor)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }
    
    /// Re-renders the cell view with the latest data
    func configureData() {
        thumbnailView.sd_setImage(with: URL(string: product?.thumbnailUrl ?? ""))
        titleLabel.text = product?.productName
        priceLabel.text = "$\(String(format: "%.2f", product?.productPrice ?? 0.0))"
    }
    
    func configureCell(_ product: Product) {
        self.product = product
        configureData()
    }
    
    func setTapCallback(_ callback: @escaping (Product?) -> ()) {
        self.tapCallback = callback
    }
}
