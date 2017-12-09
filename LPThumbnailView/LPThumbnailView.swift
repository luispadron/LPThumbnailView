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

    public var image: UIImage? {
        didSet { self.imageView.image = image }
    }

    public var imageScaleMode: UIViewContentMode = .scaleAspectFill {
        didSet { self.imageView.contentMode = self.imageScaleMode }
    }

    public private(set) var imageCount: Int = 0

    public var counterViewSize: CGFloat = 30.0 {
        didSet {
            self.counterViewHeightConstraint?.constant = self.counterViewSize
            self.counterViewWidthConstraint?.constant = self.counterViewSize
        }
    }

    public var counterViewTopSpacing: CGFloat = 8.0 {
        didSet {
            self.counterViewTopConstraint?.constant = self.counterViewTopSpacing
        }
    }

    public var counterViewTrailingSpacing: CGFloat = 2.0 {
        didSet {
            self.counterViewTrailingConstraint?.constant = -self.counterViewTrailingSpacing
        }
    }

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

    public func updateImageCount(to newCount: Int, animated: Bool = true) {
        self.imageCount = newCount
        guard animated else { return }
        UIView.transition(with: counterView.counterLabel,
                          duration: 0.3, options: .transitionFlipFromBottom,
                          animations: {
                            self.counterView.counterLabel.text = "\(newCount)"
                          },
                          completion: nil
        )
    }

    public func updateImageCount(by increment: Int, animated: Bool = true) {
        self.updateImageCount(to: imageCount + increment, animated: animated)
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
