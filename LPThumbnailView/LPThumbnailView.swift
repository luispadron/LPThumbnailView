//
//  LPThumbnailView.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/8/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit

/**
 LPThumbnailViewAnimationStyle

 Enum for determining the type of animation to use when calling `addImage(_:duration:)`.
 */
public enum LPThumbnailViewAnimationStyle {
    /// Animation which shows a temporary image entering from the right of `LPThumbnailView` then fades into the actual view.
    case enterFromRight
    /// Animation which shows a temporary image entering from the left of `LPThumbnailView` then fades into the actual view.
    case enterFromLeft
    /// Animation which shows a temporary image entering from the top of `LPThumbnailView` then fades into the actual view.
    case enterFromTop
    /// Animation which shows a temporary image entering from underneath of `LPThumbnailView` then fades into the actual view.
    case enterFromBottom
    /// Simply cross dissolves from the old image to the image animating to.
    case crossDissolve
}

/**
 LPThumbnailView

 A thumbnail view for displaying images and give context in an application which takes photos/video thumbnails.
 Simply add to a view controler as a subview.
 */
open class LPThumbnailView: UIView {

    // MARK: Public members/properties

    /**
     */
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
        didSet { self.counterViewTopConstraint?.constant = self.counterViewTopSpacing }
    }

    public var counterViewTrailingSpacing: CGFloat = 2.0 {
        didSet { self.counterViewTrailingConstraint?.constant = -self.counterViewTrailingSpacing }
    }

    public var counterViewLabel: UILabel {
        return self.counterView.counterLabel
    }

    public var counterViewBackgroundColor: UIColor = UIColor.cyan {
        didSet { self.counterView.backgroundColor = self.counterViewBackgroundColor }
    }

    public var animationStyle: LPThumbnailViewAnimationStyle = .crossDissolve

    public var counterViewAnimationOptions: UIViewAnimationOptions = [.transitionFlipFromBottom]

    public var hidesWhenEmpty: Bool = true

    // MARK: Private members/properties

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

    // MARK: Public API

    public func addImage(_ img: UIImage, duration: TimeInterval = 0.4) {
        self.images.append(img)
        self.toggleSelfVisibility()
        self.toggleCounterView()
        // Dont animate
        guard duration > 0 else {
            self.imageView.image = img
            self.counterViewLabel.text = "\(images.count)"
            return
        }
        // Animate
        self.animateImageAddition(img, duration: duration)
    }

    public func addImageWithContext(_ tempImageView: UIImageView, duration: TimeInterval = 1.0) {
        guard let img = tempImageView.image else { return }
        self.images.append(img)
        self.toggleSelfVisibility()
        self.toggleCounterView()
        self.animateImageAdditionWithContext(tempImageView, img: img, duration: duration)
    }

    public func removeImage(duration: TimeInterval = 0.7) {
        self.images.removeLast()
        self.toggleSelfVisibility()
        self.toggleCounterView()

        // Dont animate
        guard duration > 0 else {
            self.imageView.image = self.images.last
            self.counterViewLabel.text = "\(images.count)"
            return
        }

        // Animate
        guard let toImage = self.images.last else { return }
        self.animateImageRemoval(to: toImage, duration: duration)
    }

    public func removeImage(at index: Int, duration: TimeInterval = 0.7) {
        if index != self.images.count - 1, duration == 0 {
            // The image being removed isn't the one being displayed so we can just remove it with no animation.
            self.images.remove(at: index)
            self.toggleCounterView()
            // Update label
            if duration == 0 {
                self.counterViewLabel.text = "\(self.images.count)"
            } else {
                self.animateCounterLabel(duration: duration / 2)
            }
        } else {
            // Image being removed is the one being displayed, remove and animate if allowed.
            self.removeImage(duration: duration)
        }
    }

    public func removeImages(_ images: [UIImage], duration: TimeInterval = 0.7) {
        var displayedImageRemoved: Bool = false
        for img in images {
            guard let index = self.images.index(of: img) else { continue }
            if img == self.images.last {
                displayedImageRemoved = true
            }
            self.images.remove(at: index)
        }

        self.toggleSelfVisibility()
        self.toggleCounterView()

        if let img = self.images.last, displayedImageRemoved {
            // Animate change to new image since image being displayed was removed.
            self.animateImageRemoval(to: img, duration: duration)
        } else {
            // Just animate counter change.
            self.animateCounterLabel(duration: duration / 2)
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

// MARK: Helpers

private extension LPThumbnailView {

    private func initialize() {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.addSubview(counterView)
        self.createConstraints()
        self.isHidden = self.hidesWhenEmpty
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

    private func toggleSelfVisibility() {
        guard self.hidesWhenEmpty else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = self.images.count == 0 ? 0.0 : 1.0
        }, completion: { _ in
            self.isHidden = self.images.count == 0
        })
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
}

// MARK: Animation code

private extension LPThumbnailView {

    private func animateImageAddition(_ img: UIImage, duration: TimeInterval) {
        // If cross disolve dont perform frame animation changes
        switch self.animationStyle {
        case .crossDissolve:
            UIView.animateKeyframes(withDuration: duration,
                                    delay: 0.0,
                                    options: [],
                                    animations: {
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2) {
                                            self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                            self.animateImageChange(to: img, duration: duration * (1/2))
                                        }

                                        UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
                                            self.animateCounterLabel(duration: duration * (1/2))
                                            self.imageView.transform = CGAffineTransform.identity
                                        }
            },
                                    completion: nil
            )
        case .enterFromBottom: fallthrough
        case .enterFromTop: fallthrough
        case .enterFromLeft: fallthrough
        case .enterFromRight:
            // Add a temp image view and move it to the actual image view position
            let tempImgView = createTemporaryImageView(with: img)
            self.insertSubview(tempImgView, at: 0)
            // Animate move, scale and counter label change
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

    private func animateImageRemoval(to image: UIImage, duration: TimeInterval) {
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0.0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
                                        self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                    }

                                    UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                                        self.imageView.transform = CGAffineTransform.identity
                                        self.animateImageChange(to: image, duration: duration * 1/3)
                                    }

                                    UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                                        self.animateCounterLabel(duration: duration * 1/3)
                                    }
                                },
                                completion: nil)
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
}
