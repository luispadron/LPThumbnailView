//
//  LPShadowImageView.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/9/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

/// Enum to determine the shadow type of a view.
internal enum LPShadowType {
    /// Normal shadow, when view is not being touched.
    case normal

    /// Touched shadow, when view is being touched
    case touched
}

/**
 LPShadowImageView

 A simple view which contains an image view.
 This is needed to add both rounded corners AND shadow.
 Used inside of `LPThumbnailView`
 */
internal class LPShadowImageView: UIView {
    // MARK: Static properties

    /// The shadow opacity when in the normal state
    private static let normalShadowOpactiy: Float = 0.7

    /// The shadow opacity when in the touchedstate
    private static let touchedShadowOpacity: Float = 0.4

    /// The shadow radius when in the normal state
    private static let normalShadowRadius: CGFloat = 4

    /// The shadow radius when in the touched state
    private static let touchedShadowRadius: CGFloat = 3

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
    private func initialize() {
        self.setShadowTo(.normal, duration: 0.0)
        self.addSubview(imageView)
        self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    /// Sets a normal shadow for this view, i.e when not being touched, duration of 0 means no animation
    internal func setShadowTo(_ type: LPShadowType, duration: TimeInterval) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)

        // Animate the shadow opacity and radius change
        let shadowOpacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowOpacityAnimation.fromValue = type == .normal ? LPShadowImageView.touchedShadowOpacity :
                                                            LPShadowImageView.normalShadowOpactiy
        shadowOpacityAnimation.toValue = type == .normal ? LPShadowImageView.normalShadowOpactiy :
                                                            LPShadowImageView.touchedShadowOpacity
        shadowOpacityAnimation.duration = duration
        let shadowRadiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
        shadowRadiusAnimation.fromValue = type == .normal ? LPShadowImageView.touchedShadowRadius :
                                                            LPShadowImageView.normalShadowRadius
        shadowRadiusAnimation.toValue = type == .normal ? LPShadowImageView.normalShadowRadius :
                                                            LPShadowImageView.touchedShadowRadius
        shadowRadiusAnimation.duration = duration
        self.layer.add(shadowOpacityAnimation, forKey: "shadowOpacity")
        self.layer.add(shadowRadiusAnimation, forKey: "shadowRadius")

        self.layer.shadowOpacity = type == .normal ? LPShadowImageView.normalShadowOpactiy :
                                                    LPShadowImageView.touchedShadowOpacity
        self.layer.shadowRadius = type == .normal ? LPShadowImageView.normalShadowRadius :
                                                    LPShadowImageView.touchedShadowRadius
    }

    /// Sets a touched shadow, i.e when view is touched the shadow becomes smaller
    internal func setTouchedShadow(duration: TimeInterval) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
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
