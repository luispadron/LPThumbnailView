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

    private var borderViewHeightConstraint: NSLayoutConstraint? = nil
    private var borderViewWidthConstraint: NSLayoutConstraint? = nil
    
    private var imageViewHeightConstraint: NSLayoutConstraint? = nil
    private var imageViewWidthConstraint: NSLayoutConstraint? = nil

    // MARK: Overrides

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    open override func updateConstraints() {
        super.updateConstraints()
        self.borderViewHeightConstraint?.constant = self.bounds.height * 0.80
        self.borderViewWidthConstraint?.constant = self.bounds.width * 0.80

        self.imageViewHeightConstraint?.constant = self.borderView.bounds.height * 0.70
        self.imageViewWidthConstraint?.constant = self.borderView.bounds.width * 0.70
    }

    // MARK: Helpers

    private func initialize() {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(borderView)
        self.createConstraints()
    }

    private func createConstraints() {
        // Add border view constraints
        self.borderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.borderView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.borderViewHeightConstraint = self.borderView.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.80)
        self.borderViewWidthConstraint = self.borderView.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.80)
        self.borderViewHeightConstraint?.isActive = true
        self.borderViewWidthConstraint?.isActive = true

        // Add image view constraints
        self.imageView.centerXAnchor.constraint(equalTo: self.borderView.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.borderView.centerYAnchor).isActive = true
        self.imageViewHeightConstraint = self.imageView.heightAnchor.constraint(equalToConstant: self.borderView.bounds.height * 0.70)
        self.imageViewWidthConstraint = self.imageView.widthAnchor.constraint(equalToConstant: self.borderView.bounds.width * 0.70)
        self.imageViewHeightConstraint?.isActive = true
        self.imageViewWidthConstraint?.isActive = true
    }

    // MARK: Subviews

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.frame = self.bounds
        view.addSubview(self.imageView)
        return view
    }()
}
