//
//  LPThumbnailView.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/8/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit

open class LPThumbnailView: UIView {

    // MARK: Members/Properties

    public private(set) var images: [UIImage] = [UIImage]()

    public var imageScaleMode: UIViewContentMode = .scaleAspectFill {
        didSet { self.imageView.contentMode = self.imageScaleMode }
    }

    public var counterViewSize: CGFloat = 35.0 {
        didSet {
            self.counterViewHeightConstraint?.constant = self.counterViewSize
            self.counterViewWidthConstraint?.constant = self.counterViewSize
        }
    }

    public var counterViewTopSpacing: CGFloat = 4.0 {
        didSet {
            self.counterViewTopConstraint?.constant = self.counterViewTopSpacing
        }
    }

    public var counterViewTrailingSpacing: CGFloat = 2.0 {
        didSet {
            self.counterViewTrailingConstraint?.constant = -self.counterViewTrailingSpacing
        }
    }

    public var animationDuration: TimeInterval = 0.5

    private var counterViewTopConstraint: NSLayoutConstraint? = nil

    private var counterViewTrailingConstraint: NSLayoutConstraint? = nil

    private var counterViewHeightConstraint: NSLayoutConstraint? = nil

    private var counterViewWidthConstraint: NSLayoutConstraint? = nil

    private let imageViewScaleMultiplier: CGFloat = 0.70


    // MARK: Overrides

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    // MARK: Actions

    public func addImage(_ img: UIImage, animated: Bool = true) {
        self.images.append(img)
        guard animated else {
            self.imageView.image = img
            self.counterView.counterLabel.text = "\(images.count)"
            return
        }
        self.animateImageAddition(img)
    }

    // MARK: Helpers

    private func initialize() {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.addSubview(counterView)
        self.createConstraints()
    }

    private func createConstraints() {
        // Add image view constraints
        self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: imageViewScaleMultiplier).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: imageViewScaleMultiplier).isActive = true

        // Add counter view constraints
        self.counterViewTopConstraint = self.counterView.topAnchor.constraint(equalTo: self.topAnchor,
                                                                        constant: self.counterViewTopSpacing)
        self.counterViewTrailingConstraint = self.counterView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                                                constant: -self.counterViewTrailingSpacing)
        self.counterViewHeightConstraint = self.counterView.heightAnchor.constraint(equalToConstant: self.counterViewSize)
        self.counterViewWidthConstraint = self.counterView.widthAnchor.constraint(equalToConstant: self.counterViewSize)
        self.counterViewTopConstraint?.isActive = true
        self.counterViewTrailingConstraint?.isActive = true
        self.counterViewHeightConstraint?.isActive = true
        self.counterViewWidthConstraint?.isActive = true
    }

    private func createTemporaryImageView(with image: UIImage) -> UIImageView {
        let imgViewBounds = self.imageView.frame
        let tempImageView = UIImageView()
        tempImageView.frame = CGRect(x: imgViewBounds.origin.x + (imgViewBounds.width * 0.90) + 60,
                                     y: imgViewBounds.origin.y,
                                     width: imgViewBounds.width * 0.90,
                                     height: imgViewBounds.height * 0.90)
        tempImageView.clipsToBounds = true
        tempImageView.contentMode = self.imageScaleMode
        tempImageView.image = image
        return tempImageView
    }

    private func animateImageAddition(_ img: UIImage) {
        let tempImgView = createTemporaryImageView(with: img)
        self.insertSubview(tempImgView, at: 0)

        UIView.animateKeyframes(withDuration: animationDuration,
                                delay: 0.0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
                                        tempImgView.frame = self.imageView.frame
                                        tempImgView.layoutIfNeeded()
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                                        self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                        let trasitionDuration = self.animationDuration - (self.animationDuration * 1/3)
                                        UIView.transition(with: self.imageView,
                                                          duration: trasitionDuration * (1/3),
                                                          options: .transitionCrossDissolve,
                                                          animations: {
                                                            self.imageView.image = img
                                                          },
                                                          completion: nil)
                                        tempImgView.alpha = 0.0
                                    }

                                    UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                                        UIView.transition(with: self.counterView.counterLabel,
                                                          duration: self.animationDuration * (1/3),
                                                          options: .transitionFlipFromBottom,
                                                          animations: {
                                                            self.counterView.counterLabel.text = "\(self.images.count)"
                                                          },
                                                          completion: nil)
                                        self.imageView.transform = CGAffineTransform.identity
                                    }
                                },
                                completion: nil
        )
    }

    // MARK: Subviews

    private lazy var imageView: LPShadowImageView = {
        let view = LPShadowImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = self.imageScaleMode
        return view
    }()

    private lazy var counterView: LPThumbnailCounterView = {
        let counterView = LPThumbnailCounterView()
        return counterView
    }()
}
