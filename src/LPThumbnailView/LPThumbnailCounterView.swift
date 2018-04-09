//
//  LPThumbnailCounterView.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/9/17.
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
 LPThumbnailCounterView

 A circular view with a label, used inside of `LPThumbnailView`.
 */
internal class LPThumbnailCounterView: LPShadowView {
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

    /// Makes sure to update the corner radius on any bound changes.
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
    }

    // MARK: Helpers

    /// Helper function to initialize the view
    internal override func initialize() {
        // Set shadow properties
        self.normalShadowRadius = 2
        self.normalShadowOpactiy = 0.4
        self.touchedShadowRadius = 1
        self.touchedShadowOpacity = 0.2
        self.setShadowTo(.normal, duration: 0.0)
        // Constraint setup
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = self.bounds.width / 2
        // Add constraints for label
        self.addSubview(counterLabel)
        self.counterLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.counterLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.counterLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.counterLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    // MARK: Subviews

    /// The label which will display a count of the images in `LPThumbnailView` 
    internal lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
}
