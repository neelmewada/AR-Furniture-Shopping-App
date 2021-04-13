//
//  ProductDetailView.swift
//  AR Shop
//
//  Created by Neel Mewada on 13/04/21.
//

import UIKit

class ProductDetailView: UIView {
    // MARK: - Lifecycle
    
    private var viewModel: ProductDetailViewModel
    
    init(_ product: Product) {
        self.viewModel = ProductDetailViewModel(product)
        super.init(frame: .zero)
        self.viewModel.setUpdateCallback(self.viewModelDidChange)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = coder.decodeObject() as! ProductDetailViewModel
        super.init(coder: coder)
        self.viewModel.setUpdateCallback(self.viewModelDidChange)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(viewModel)
    }
    
    /// Use this function to make push edits & changes from this view to the viewModel
    func viewDidChange() {
        
    }
    
    /// Called when the viewModel is modified/set `externally`. Use this function to update data displayed by this view
    func viewModelDidChange() {
        configureData()
    }
    
    // MARK: - Properties
    
    private let galleryImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = UIColor.fromHex("F2F6F9")
        
        addSubview(galleryImageView)
        galleryImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 380)
        
        /*let imageOverlay = UIView()
        imageOverlay.backgroundColor = UIColor(white: 0, alpha: 0.25)
        galleryImageView.addSubview(imageOverlay)
        imageOverlay.fillSuperview()*/
        
        configureData()
    }
    
    public func configureData() {
        
        
        guard let galleryImageUrl = viewModel.galleryImageUrl else { return }
        
        galleryImageView.image = nil
        galleryImageView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        galleryImageView.sd_setImage(with: galleryImageUrl, placeholderImage: UIImage(named: "white_square")!, options: .delayPlaceholder, completed: nil)
    }
}
