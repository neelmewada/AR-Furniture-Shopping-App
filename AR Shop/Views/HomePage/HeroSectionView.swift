//
//  HeroSectionView.swift
//  AR Shop
//
//  Created by Neel Mewada on 10/04/21.
//

import UIKit

// MARK: - HeroSectionView

class HeroSectionView: UIView {
    
    private var viewModel: HeroSectionViewModel
    
    init(viewModel: HeroSectionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.viewModel.setUpdateCallback(self.viewModelDidUpdate)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = HeroSectionViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Properties
        
    private let backgoundImageView = UIImageView()
    
    private lazy var introducingLabel: UILabel = {
        let label = UILabel()
        label.text = "Intoducing"
        label.font = UIFont(name: "PlainGermanica-Regular", size: 12)
        label.textColor = .black
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Budget Furnitures"
        label.font = UIFont(name: "Poppins-SemiBold", size: 12)
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "All furnitures discount"
        label.font = UIFont(name: "Poppins-Medium", size: 11)
        label.textColor = .black
        return label
    }()
    
    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.text = "Upto 50% Off*"
        label.textAlignment = .right
        label.font = UIFont(name: "Poppins-SemiBold", size: 14)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Lifecycle
    
    /// Use this function to send any updated data to viewModel.
    public func viewDidUpdate() {
        
    }
    
    /// This function is called when the viewModel is updated `externally`. Use this function to update this view.
    public func viewModelDidUpdate() {
        backgoundImageView.image = viewModel.heroImage
    }
    
    
    // MARK: - Helpers
    
    private func configureView() {
        addSubview(backgoundImageView)
        backgoundImageView.image = viewModel.heroImage
        backgoundImageView.contentMode = .scaleAspectFill
        backgoundImageView.fillSuperview()
        backgoundImageView.layer.cornerRadius = 10
        backgoundImageView.clipsToBounds = true
        
        addSubview(introducingLabel)
        introducingLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: introducingLabel.bottomAnchor, left: leftAnchor, paddingTop: 3, paddingLeft: 10)
        
        addSubview(subtitleLabel)
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 10)
        
        addSubview(discountLabel)
        discountLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 20)
    }
    
    func setViewModel(_ viewModel: HeroSectionViewModel) {
        self.viewModel = viewModel
        viewModelDidUpdate()
    }
}
