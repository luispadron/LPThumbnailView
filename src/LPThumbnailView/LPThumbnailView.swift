//
//  LPThumbnailView.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/8/17.
//
//  MIT License
//
//  Copyright (c) 2017 Luis Padron
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

/**
 LPThumbnailView

 A thumbnail view for displaying images and give context in an application which takes photos/video thumbnails.
 Simply add to a view controler as a subview.
 */
open class LPThumbnailView: UIView {

    // MARK: Public members/properties

    /**
     The delegate responsible for listening to touches/updates propogated from this view.
     */
    public weak var delegate: LPThumbnailViewDelegate? = nil

    /**
     The images which the `LPThumbnailView` will display.

     To add images you must call `addImage` or `addImageWithContext`
     */
    public private(set) var images: [UIImage] = [UIImage]()

    /**
     The scale mode to use for the `imageView`.
     */
    public var imageScaleMode: UIView.ContentMode = .scaleAspectFill {
        didSet { self.imageView.contentMode = self.imageScaleMode }
    }

    /**
     Whether or not the size of the counter view should be calculated automatically.

     If so, the counter view's size will be a ratio of the `LPThumbnailView`, otherwise
     `counterViewSize` will be used as the size.
     */
    public var automaticallyCalculatesCounterViewSize: Bool = true

    /**
     The size of counter view and it's label.

     Only used when `automaticallyCalculatesCounterViewSize` is `false`.
     */
    public var counterViewSize: CGFloat = 50 {
        didSet {
            guard !automaticallyCalculatesCounterViewSize else { return }
            self.counterViewWidthConstraint?.constant = self.counterViewSize
            self.counterViewHeightConstraint?.constant = self.counterViewSize
        }
    }

    /**
     The amount of top spacing from the `LPThumbnailView` parent view to give to the counter view and label.
     */
    public var counterViewTopSpacing: CGFloat = 4.0 {
        didSet { self.counterViewTopConstraint?.constant = self.counterViewTopSpacing }
    }

    /**
     The amount of trailing spacing from the `LPThumbnailView` parent view to give to the counter view and label.
     */
    public var counterViewTrailingSpacing: CGFloat = 2.0 {
        didSet { self.counterViewTrailingConstraint?.constant = -self.counterViewTrailingSpacing }
    }

    /**
     An accessor for the label which displays the amount of images in the counter view.
     */
    public var counterViewLabel: UILabel {
        return self.counterView.counterLabel
    }

    /**
     The background color for the counter view which counts the number of images in the view.
     */
    public var counterViewBackgroundColor: UIColor = UIColor.cyan {
        didSet { self.counterView.backgroundColor = self.counterViewBackgroundColor }
    }

    /**
     The animation style used when calling `addImage`
     */
    public var animationStyle: LPThumbnailViewAnimationStyle = .crossDissolve

    /**
     The animation options used when animating the counter view label change.
     */
    public var counterViewAnimationOptions: UIView.AnimationOptions = [.transitionFlipFromBottom]

    /**
     Whether or not this view automatically hides it self when there are no images to display.

     This is `true` by default.
     */
    public var hidesWhenEmpty: Bool = true

    // MARK: Private members/properties

    /// The top constraint for the counter view
    private var counterViewTopConstraint: NSLayoutConstraint? = nil

    /// The trailing constraints for the counter view
    private var counterViewTrailingConstraint: NSLayoutConstraint? = nil

    /// The height constraint for the counter view
    private var counterViewHeightConstraint: NSLayoutConstraint? = nil

    /// The width constraint for the counter view
    private var counterViewWidthConstraint: NSLayoutConstraint? = nil

    /// The scale multiplier for the imave view, i.e how much the image view should take up of the entire view.
    /// Value must be between 0 and 1.
    private let imageViewScaleMultiplier: CGFloat = 0.70

    /// The calculated ratio size for the image view
    private var automaticCounterViewSize: CGFloat {
        return (self.frame.width + self.frame.height) * 0.15
    }


    // MARK: Overrides

    /// Overriden initializer.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    /// Overriden initializer.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    // MARK: Public API

    /**
     Adds an image to the `images` array and performs an animation.

     Will animate with `duration` length, if `duration = 0` will not animate and will just perform changes instantly.
     Animation style performed depends on `animationStyle` property.

     - Parameters:
        - image: The image to add.
        - duration: How long to animate for, if this is 0, no animation is performed.
     */
    public func addImage(_ image: UIImage, duration: TimeInterval = 0.4) {
        self.images.append(image)
        self.toggleSelfVisibility()
        self.toggleCounterView()
        // Dont animate
        guard duration > 0 else {
            self.imageView.image = image
            self.counterViewLabel.text = "\(images.count)"
            return
        }
        // Animate
        self.animateImageAddition(image, duration: duration)
    }

    /**
     Adds an image to the `images` array and performs an animation with context.

     This animation differs from `addImage` since it uses a temporary image view that was created outside of this instance.
     It then animates that temporary image view into the correct position and frame and performs an animation to make it look
     like the temporary image view was added to this thumbnail view.

     The image from the temporary image view is then used to become the new main thumbail for this view.

     ## Important
     `tempImageView` is removed from it's superview after this function is called

     - Parameters:
        - tempImageView: The temporary image view which will be animated.
        - duration: How long to animate for.
     */
    public func addImageWithContext(_ tempImageView: UIImageView, duration: TimeInterval = 1.0) {
        guard let img = tempImageView.image else { return }
        self.images.append(img)
        self.toggleSelfVisibility()
        self.toggleCounterView()
        self.animateImageAdditionWithContext(tempImageView, img: img, duration: duration)
    }

    /**
     Removes the __last__ image in `images` and performs an animation.

     __Requires__ that there be at least 1 image in the `images` array.

     - Parameters:
        - duration: How long to animate for, if this value is 0, no animation is performed.
     */
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

    /**
     Removes the image in `images` at the specified index and performs an animation.

     __Requires__ that the index is a valid index of `images`

     - Parameters:
        - index: The index of the image to remove.
        - duration: How long to animate for, if this value is 0, no animation is performed.
     */
    public func removeImage(at index: Int, duration: TimeInterval = 0.7) {
        if index != self.images.count - 1 || duration == 0 {
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

    /**
     Removes the `images` sent in from this views `images` array and performs an animation if and only if
     one of the images removed is main thumbnail image of this view.

     If any image in `images` is not in this views `images` the removal is ignored.

     - Parameters:
        - images: The images to remove.
        - duration: How long to animate for if image removed is currently being displayed.
     */
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

    /// The image view which will hold the thumbnail for this view.
    private lazy var imageView: LPShadowImageView = {
        let view = LPShadowImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = self.imageScaleMode
        view.isUserInteractionEnabled = false
        return view
    }()

    /// The counter view which contains a label and counts the number of images in `images`.
    private lazy var counterView: LPThumbnailCounterView = {
        let counterView = LPThumbnailCounterView()
        counterView.backgroundColor = self.counterViewBackgroundColor
        counterView.isHidden = true
        counterView.isUserInteractionEnabled = false
        return counterView
    }()

    /// A property animator for animating this view whenever the view is tapped.
    private lazy var animator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.6, animations: nil)
        animator.isInterruptible = true
        return animator
    }()
}

// MARK: Helpers

private extension LPThumbnailView {

    /// Helper which adds subviews and applies any constraints
    private func initialize() {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.viewWasTapped(_:)))
        gesture.minimumPressDuration = 0.05
        self.addGestureRecognizer(gesture)
        self.addSubview(imageView)
        self.addSubview(counterView)
        self.createConstraints()
        self.isHidden = self.hidesWhenEmpty
    }

    /// Creates constraints for the image view and counter view
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

    /// Creates a temporary image view which will be used to animate an image addition
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

    /// Toggles the visibilty of self if `hidesWhenEmpty` is true.
    /// If `images.count` is 0 then this view will hide, otherwise it shows.
    private func toggleSelfVisibility() {
        guard self.hidesWhenEmpty else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = self.images.count == 0 ? 0.0 : 1.0
        }, completion: { _ in
            self.isHidden = self.images.count == 0
        })
    }

    /// Toggles the counterview, shows if `images.count` is greater than 1, hides otherwise.
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

    /// Called whenever the view is tapped, animates the view and calls the view delegate.
    @objc private func viewWasTapped(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if animator.isRunning { animator.stopAnimation(true) }
            animator.addAnimations {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.imageView.setShadowTo(.touched, duration: 0.4)
                self.counterView.setShadowTo(.touched, duration: 0.4)
            }
            animator.startAnimation()

        case .ended:
            if animator.isRunning { animator.stopAnimation(true) }
            animator.addAnimations {
                self.transform = CGAffineTransform.identity
                self.imageView.setShadowTo(.normal, duration: 0.4)
                self.counterView.setShadowTo(.normal, duration: 0.4)
            }
            animator.startAnimation()
            self.delegate?.thumbnailViewWasTapped(self)

        default: break
        }
    }
}

// MARK: Animation code

private extension LPThumbnailView {

    /// Animates the addition of an image.
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

    /// Animates the addition of an image using a temporary image view provided when calling `addImageWithContext`
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

    /// Animates the removal of an image, only called when the main display image is removed.
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

    /// Animates the `imageView`'s image being updated.
    private func animateImageChange(to newImage: UIImage, duration: TimeInterval) {
        UIView.transition(with: self.imageView,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { self.imageView.image = newImage },
                          completion: nil
        )
    }

    /// Animates the counter label being changed.
    private func animateCounterLabel(duration: TimeInterval) {
        UIView.transition(with: self.counterViewLabel,
                          duration: duration,
                          options: self.counterViewAnimationOptions,
                          animations: { self.counterViewLabel.text = "\(self.images.count)" },
                          completion: nil
        )
    }
}
