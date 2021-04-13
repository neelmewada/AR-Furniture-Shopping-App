//
//  ProductThumnbailColumnView.swift
//  AR Shop
//
//  Created by Neel Mewada on 11/04/21.
//

import UIKit

class ProductThumnbailColumnView: UIView {
    public var viewModel: ProductThumnbailColumnViewModel
    
    // MARK: - Lifecycle
    
    init(_ viewModel: ProductThumnbailColumnViewModel, indexInParent: Int, tapCallback: ((Int) -> ())?) {
        self.viewModel = viewModel
        self.tapCallback = tapCallback
        self.indexInParent = indexInParent
        
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = ProductThumnbailColumnViewModel()
        super.init(coder: coder)
        configureView()
    }
    
    /// Use this function to make push edits & changes from this view to the viewModel
    func viewDidChange() {
        
    }
    
    /// Called when the viewModel is modified/set `externally`. Use this function to update data displayed by this view
    func viewModelDidChange() {
        configureData()
    }
    
    // MARK: - Properties
    
    private var tapCallback: ((Int) -> ())? = nil
    public var indexInParent: Int = 0
    
    private let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 15)
        label.textColor = .black
        label.text = ""
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 15)
        label.textColor = .black
        label.text = ""
        return label
    }()
    
    // MARK: - Actions
    
    @objc func onPressed() {
        tapCallback?(indexInParent)
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        self.viewModel.setUpdateCallback(viewModelDidChange) // IMPORTANT
        self.isMultipleTouchEnabled = false
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPressed))
        self.addGestureRecognizer(tapGesture)
        
        addSubview(thumbnailImageView)
        thumbnailImageView.anchor(top: topAnchor, left: leftAnchor, width: 100, height: 100)
        
        addSubview(productNameLabel)
        productNameLabel.anchor(top: thumbnailImageView.topAnchor, left: thumbnailImageView.rightAnchor, right: rightAnchor, paddingTop: 14, paddingLeft: 20)
        
        addSubview(productPriceLabel)
        productPriceLabel.anchor(top: productNameLabel.topAnchor, left: productNameLabel.leftAnchor, right: rightAnchor, paddingTop: 35)
        
        configureData()
    }
    
    private func configureData() {
        productNameLabel.text = viewModel.productName
        productPriceLabel.text = viewModel.productPrice
        
        guard let thumbnailUrl = URL.init(string: viewModel.thumbnailUrl ?? "") else { return }
        
        thumbnailImageView.image = nil
        thumbnailImageView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        thumbnailImageView.sd_setImage(with: thumbnailUrl, placeholderImage: UIImage(named: "white_square")!, options: .delayPlaceholder) { image, error, cacheType, url in
            
        }
    }
    
    public func setViewModel(_ viewModel: ProductThumnbailColumnViewModel) {
        self.viewModel = viewModel
        viewModelDidChange()
    }
}
