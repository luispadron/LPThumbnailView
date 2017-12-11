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

    public func addImage(_ img: UIImage, duration: TimeInterval = 0.4) {
        self.images.append(img)
        self.toggleCounterView()
        guard duration > 0 else {
            self.imageView.image = img
            self.counterViewLabel.text = "\(images.count)"
            return
        }
        self.animateImageAddition(img, duration: duration)
    }

    public func addImageWithContext(_ tempImageView: UIImageView, duration: TimeInterval = 1.0) {
        guard let img = tempImageView.image else { return }
        self.images.append(img)
        self.toggleCounterView()
        self.animateImageAdditionWithContext(tempImageView, img: img, duration: duration)
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

    private func animateImageAddition(_ img: UIImage, duration: TimeInterval) {
        let tempImgView = createTemporaryImageView(with: img)
        self.insertSubview(tempImgView, at: 0)

        UIView.animateKeyframes(withDuration: duration,
                                delay: 0.0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
                                        tempImgView.frame = CGRect(x: self.imageView.frame.origin.x,
                                                                   y: self.imageView.frame.origin.y,
                                                                   width: tempImgView.frame.width,
                                                                   height: tempImgView.frame.height)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                                        self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                        self.animateImageChange(to: img, duration: duration * (1/3))
                                        tempImgView.alpha = 0.0
                                    }

                                    UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                                        self.animateCounterLabel(duration: duration * (1/3))
                                        self.imageView.transform = CGAffineTransform.identity
                                    }
                                },
                                completion: { _ in
                                    // Remove temp image view
                                    tempImgView.removeFromSuperview()
                                }
        )
    }

    private func animateImageAdditionWithContext(_ tempImageView: UIImageView, img: UIImage, duration: TimeInterval) {
        let imageViewFrame = self.imageView.convert(CGRect.zero, to: tempImageView.superview)
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0.2,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 2/4) {
                                        tempImageView.frame = CGRect(x: imageViewFrame.origin.x,
                                                                     y: imageViewFrame.origin.y,
                                                                     width: self.imageView.frame.width,
                                                                     height: self.imageView.frame.height)
                                    }

                                    UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
                                        tempImageView.alpha = 0.0
                                        self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                        self.animateImageChange(to: img, duration: 0.25)
                                    }

                                    UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                                        self.animateCounterLabel(duration: duration * 0.25)
                                        self.imageView.transform = CGAffineTransform.identity
                                    }
                                },
                                completion: { _ in
                                    tempImageView.removeFromSuperview()
                                }
        )
    }

    private func animateImageChange(to newImage: UIImage, duration: TimeInterval) {
        UIView.transition(with: self.imageView,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { self.imageView.image = newImage },
                          completion: nil
        )
    }

    private func animateCounterLabel(duration: TimeInterval) {
        UIView.transition(with: self.counterViewLabel,
                          duration: duration,
                          options: self.counterViewAnimationOptions,
                          animations: { self.counterViewLabel.text = "\(self.images.count)" },
                          completion: nil
        )
    }

    private func toggleCounterView() {
        guard self.images.count > 1 else {
            // Hide counter view
            UIView.animate(withDuration: 0.2, animations: {
                self.counterView.alpha = 0.0
            }, completion: { _ in
                self.counterView.isHidden = true
            })
            return
        }

        // Show counter view
        self.counterView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.counterView.alpha = 1.0
        }
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
        counterView.isHidden = true
        return counterView
    }()
}
