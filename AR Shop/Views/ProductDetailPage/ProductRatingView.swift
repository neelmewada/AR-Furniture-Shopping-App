//
//  ProductRatingView.swift
//  AR Shop
//
//  Created by Neel Mewada on 14/04/21.
//

import UIKit

class ProductRatingView: UIView {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    // MARK: - Properties
    
    private var rating: Float = 0
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        return stack
    }()
    
    private var starImageViews: [UIImageView] = [UIImageView]()
    
    // MARK: - Helpers
    
    private func configureView() {
        addSubview(stackView)
        stackView.fillSuperview()
        
        configureData()
    }
    
    public func configureData() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        starImageViews.removeAll()
        for i in 1...5 {
            let imageName = i <= Int(rating) ? "star_filled" : "star_empty"
            let imageView = UIImageView(image: UIImage(named: imageName))
            stackView.addArrangedSubview(imageView)
        }
    }
    
    public func setRating(_ rating: Float) {
        self.rating = ceil(rating)
        configureData()
    }
}
