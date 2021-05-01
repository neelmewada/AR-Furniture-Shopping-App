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
        self.viewDidChange()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = coder.decodeObject() as! ProductDetailViewModel
        super.init(coder: coder)
        self.viewModel.setUpdateCallback(self.viewModelDidChange)
        self.configureView()
        self.viewDidChange()
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(viewModel)
    }
    
    /// Use this function to make/push edits & changes to the viewModel
    func viewDidChange() {
        viewModel.selectedColorIndex = 0
        viewModel.productAmount = amountStepper.value
    }
    
    /// Called when the viewModel is modified/set `externally`. Use this function to update data displayed by this view.
    func viewModelDidChange() {
        configureData()
    }
    
    // MARK: - Actions
    
    @objc func arModeButtonPressed() {
        let arViewController = ProductARViewController(viewModel.product.id)
        AppRuntime.navigationController?.pushViewController(arViewController, animated: true)
    }
    
    @objc func addToCartButtonPressed() {
        viewModel.addProductToCart()
        let cartViewController = CartViewController()
        AppRuntime.navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    func favoriteChanged(_ isFavorite: Bool) {
        viewModel.isFavorite = isFavorite
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = Constants.primaryBackgroundColor
        
        addSubview(scrollView)
        scrollView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.isActive = true
        heightConstraint.priority = UILayoutPriority(250)
        
        contentView.addSubview(galleryImageView)
        galleryImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 380)
        
        let imageOverlay = UIView()
        imageOverlay.backgroundColor = UIColor(white: 0, alpha: 0.25)
        galleryImageView.addSubview(imageOverlay)
        imageOverlay.fillSuperview()
        
        contentView.addSubview(productTitleLabel)
        productTitleLabel.anchor(top: galleryImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingLeft: 30, paddingRight: 30)
        
        contentView.addSubview(productPriceLabel)
        productPriceLabel.anchor(top: productTitleLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 30)
        
        contentView.addSubview(productRatingView)
        productRatingView.anchor(top: productTitleLabel.bottomAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingRight: 30)
        productRatingView.setDimensions(height: 16, width: 101)
        
        let separator1 = addSeparator(topAnchor: productPriceLabel.bottomAnchor)
        
        contentView.addSubview(amountStepper)
        amountStepper.anchor(top: separator1.bottomAnchor, left: contentView.leftAnchor, paddingTop: 34, paddingLeft: 30)
        amountStepper.setDimensions(height: 54, width: 70)
        
        contentView.addSubview(arModeButton)
        arModeButton.anchor(top: amountStepper.topAnchor, left: amountStepper.rightAnchor, paddingLeft: 14)
        arModeButton.setDimensions(height: 54, width: 70)
        arModeButton.imageView?.setDimensions(height: 38, width: 38)
        
        contentView.addSubview(addToCartButton)
        addToCartButton.anchor(top: amountStepper.topAnchor, left: arModeButton.rightAnchor, right: rightAnchor, paddingLeft: 14, paddingRight: 30, height: 54)
        
        let separator2 = addSeparator(topAnchor: amountStepper.bottomAnchor, paddingTop: 34)
        
        contentView.addSubview(descriptionTitleLabel)
        descriptionTitleLabel.anchor(top: separator2.bottomAnchor, left: contentView.leftAnchor, paddingTop: 24, paddingLeft: 30)
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: descriptionTitleLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 6, paddingLeft: 30, paddingRight: 30)
        
        contentView.addSubview(categoriesTitleLabel)
        categoriesTitleLabel.anchor(top: descriptionLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 24, paddingLeft: 30)
        
        contentView.addSubview(categoriesLabel)
        categoriesLabel.anchor(top: descriptionLabel.bottomAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingRight: 30)
        
        let separator3 = addSeparator(topAnchor: categoriesLabel.bottomAnchor)
        
        contentView.addSubview(reviewsTitleLabel)
        reviewsTitleLabel.anchor(top: separator3.bottomAnchor, left: contentView.leftAnchor, paddingTop: 24, paddingLeft: 30)
        
        contentView.addSubview(reviewsNumberLabel)
        reviewsNumberLabel.anchor(top: reviewsTitleLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 14, paddingLeft: 30)
        
        contentView.addSubview(ratingsNumberSecondaryLabel)
        ratingsNumberSecondaryLabel.anchor(top: separator3.bottomAnchor, right: contentView.rightAnchor, paddingTop: 26, paddingRight: 30)
        
        contentView.addSubview(ratingsNumberPrimaryLabel)
        ratingsNumberPrimaryLabel.anchor(bottom: ratingsNumberSecondaryLabel.bottomAnchor, right: ratingsNumberSecondaryLabel.leftAnchor, paddingBottom: -1)
        
        let separator4 = addSeparator(topAnchor: reviewsNumberLabel.bottomAnchor)
        separator4.anchor(bottom: contentView.bottomAnchor, paddingBottom: 50)
        
        addSubview(productTopBar)
        productTopBar.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingBottom: -50)
        
        configureData()
    }
    
    private func addSeparator(topAnchor: NSLayoutYAxisAnchor, paddingTop: CGFloat = 24) -> UIView {
        let separator = UIView()
        contentView.addSubview(separator)
        separator.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: paddingTop, paddingLeft: 30, paddingRight: 30, height: 1)
        separator.backgroundColor = UIColor.fromHex("C6C5C5")
        return separator
    }
    
    public func configureData() {
        productTitleLabel.text = viewModel.productTitle
        productPriceLabel.text = viewModel.productPriceLabel
        productRatingView.setRating(viewModel.productRating)
        descriptionLabel.text = viewModel.productDescription
        categoriesLabel.text = viewModel.categoriesText
        reviewsNumberLabel.text = viewModel.productReviewsText
        ratingsNumberPrimaryLabel.text = viewModel.productRatingText
        productTopBar.isFavorite = viewModel.isFavorite
        productTopBar.setFavoriteButton(hidden: !viewModel.isUserSignedIn)
        
        guard let galleryImageUrl = viewModel.galleryImageUrl else { return }
        
        galleryImageView.image = nil
        galleryImageView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        galleryImageView.sd_setImage(with: galleryImageUrl, placeholderImage: UIImage(named: "white_square")!, options: .delayPlaceholder, completed: nil)
    }
    
    
    // MARK: - Properties
    
    private lazy var productTopBar = ProductDetailTopBar(scrollView: self.scrollView, favoriteChanged)
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private let contentView = UIView()
    
    private let galleryImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 20)
        label.textColor = .black
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 20)
        label.textColor = .black
        return label
    }()
    
    private var productRatingView = ProductRatingView()
    
    private lazy var amountStepper: NumberStepperView = {
        let stepper = NumberStepperView(min: 1, max: 3)
        stepper.addValueChangeEventListener(self.viewDidChange)
        return stepper
    }()
    
    private lazy var arModeButton: CustomButton = {
        let button = CustomButton()
        button.setImage(UIImage(named: "ar_icon"), for: .normal)
        button.setPressedHandler(self.arModeButtonPressed)
        return button
    }()
    
    private lazy var addToCartButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Add To Cart", for: .normal)
        button.setPressedHandler(self.addToCartButtonPressed)
        return button
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 15)
        label.textColor = .black
        label.text = "Description"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 13)
        label.textColor = UIColor.fromHex("353636")
        label.numberOfLines = 0
        return label
    }()
    
    private let categoriesTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Categories: "
        return label
    }()
    
    private let categoriesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 12)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 3
        return label
    }()
    
    private let reviewsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 15)
        label.textColor = .black
        label.text = "Reviews"
        return label
    }()
    
    private let reviewsNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.textColor = .black
        return label
    }()
    
    private let ratingsNumberPrimaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 17)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    private let ratingsNumberSecondaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 12)
        label.textColor = .black
        label.textAlignment = .right
        label.text = " Out of 5.0"
        label.sizeToFit()
        return label
    }()
}


