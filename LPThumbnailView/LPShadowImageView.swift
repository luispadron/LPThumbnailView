//
//  LPShadowImageView.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/9/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

/**
 LPShadowImageView

 A simple view which contains an image view.
 This is needed to add both rounded corners AND shadow.
 Used inside of `LPThumbnailView`
 */
internal class LPShadowImageView: LPShadowView {
    // MARK: Members/Properties

    /// The image for the `imageView`
    internal var image: UIImage? = nil {
        didSet { self.imageView.image = self.image }
    }

    // MARK: Override

    /// Overriden init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    /// Overriden init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    /// The content mode for the `imageView`
    override var contentMode: UIViewContentMode {
        didSet { self.imageView.contentMode = self.contentMode }
    }

    // MARK: Helpers

    /// Helper function to initialize the view.
    internal override func initialize() {
        super.initialize()
        self.addSubview(imageView)
        self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    // MARK: Subviews

    /// The image view which will be used inside of `LPThumbnailView`
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = self.contentMode
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.frame = self.frame
        return imageView
    }()
}
