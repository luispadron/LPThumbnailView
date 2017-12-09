//
//  LPThumbnailView.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/8/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit

public enum LPThumbnailViewAnimationStyle {
    case enterFromRight
    case enterFromLeft
    case enterFromTop
    case enterFromBottom
    case crossDissolve
}

open class LPThumbnailView: UIView {

    // MARK: Members/Properties

    public private(set) var images: [UIImage] = [UIImage]()

    public var imageScaleMode: UIViewContentMode = .scaleAspectFill {
        didSet { self.imageView.contentMode = self.imageScaleMode }
    }

    public var automaticallyCalculatesCounterViewSize: Bool = true

    public var counterViewSize: CGFloat = 50 {
        didSet {
            guard !automaticallyCalculatesCounterViewSize else { return }
            self.counterViewWidthConstraint?.constant = self.counterViewSize
            self.counterViewHeightConstraint?.constant = self.counterViewSize
        }
    }

    private var automaticCounterViewSize: CGFloat {
        return (self.frame.width + self.frame.height) * 0.15
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

    public var counterViewLabel: UILabel {
        return self.counterView.counterLabel
    }

    public var counterViewBackgroundColor: UIColor = UIColor.cyan {
        didSet { self.counterView.backgroundColor = self.counterViewBackgroundColor }
    }

    public var animationDuration: TimeInterval = 0.4

    public var animationStyle: LPThumbnailViewAnimationStyle = .enterFromRight

    public var counterViewAnimationOptions: UIViewAnimationOptions = [.transitionFlipFromBottom]

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
            self.counterViewLabel.text = "\(images.count)"
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
        self.counterViewHeightConstraint = self.counterView.heightAnchor.constraint(equalToConstant: self.automaticCounterViewSize)
        self.counterViewWidthConstraint = self.counterView.widthAnchor.constraint(equalToConstant: self.automaticCounterViewSize)
        self.counterViewTopConstraint?.isActive = true
        self.counterViewTrailingConstraint?.isActive = true
        self.counterViewHeightConstraint?.isActive = true
        self.counterViewWidthConstraint?.isActive = true
    }

    private func createTemporaryImageView(with image: UIImage) -> UIImageView {
        let imgViewBounds = self.imageView.frame
        let tempImageView = UIImageView()

        let xOffset: CGFloat
        let yOffset: CGFloat
        switch self.animationStyle {
        case .enterFromRight:
            xOffset = (imgViewBounds.width * 0.90) + 60
            yOffset = 0
        case .enterFromLeft:
            xOffset = -(imgViewBounds.width * 0.90) - 60
            yOffset = 0
        case .enterFromTop:
            xOffset = 0
            yOffset = -(imgViewBounds.height * 0.90) - 60
        case .enterFromBottom:
            xOffset = 0
            yOffset = (imgViewBounds.height * 0.90) + 60
        case .crossDissolve:
            xOffset = 0
            yOffset = 0
        }

        tempImageView.frame = CGRect(x: imgViewBounds.origin.x + xOffset,
                                     y: imgViewBounds.origin.y + yOffset,
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
                                        tempImgView.frame = CGRect(x: self.imageView.frame.origin.x,
                                                                   y: self.imageView.frame.origin.y,
                                                                   width: tempImgView.frame.width,
                                                                   height: tempImgView.frame.height)
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
                                        UIView.transition(with: self.counterViewLabel,
                                                          duration: self.animationDuration * (1/3),
                                                          options: self.counterViewAnimationOptions,
                                                          animations: {
                                                            self.counterViewLabel.text = "\(self.images.count)"
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
        counterView.backgroundColor = self.counterViewBackgroundColor
        return counterView
    }()
}
