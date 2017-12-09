//
//  LPShadowImageView.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/9/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

internal class LPShadowImageView: UIView {
    // MARK: Members/Properties

    internal var image: UIImage? = nil {
        didSet {
            self.imageView.image = self.image
        }
    }

    // MARK: Override

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    override var contentMode: UIViewContentMode {
        didSet { self.imageView.contentMode = self.contentMode }
    }

    // MARK: Helpers

    private func initialize() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.addSubview(imageView)
        self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    // MARK: Subviews

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
