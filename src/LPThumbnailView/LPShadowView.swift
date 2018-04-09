//
//  LPShadowView.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/12/17.
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
 Enum to determine the shadow type of a view.
 */
internal enum LPShadowType {
    /// Normal shadow, when view is not being touched.
    case normal
    /// Touched shadow, when view is being touched
    case touched
}

/**
 LPShadowView

 A simple view that draws a shadow and has some helper functions for updating/animating shadow.
 */

internal class LPShadowView: UIView {

    // MARK: Properties

    /// The shadow opacity when in the normal state
    internal var normalShadowOpactiy: Float = 0.7

    /// The shadow opacity when in the touchedstate
    internal var touchedShadowOpacity: Float = 0.4

    /// The shadow radius when in the normal state
    internal var normalShadowRadius: CGFloat = 4

    /// The shadow radius when in the touched state
    internal var touchedShadowRadius: CGFloat = 3

    // MARK: Init

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

    /// Initializes the view with a shadow
    internal func initialize() {
        self.setShadowTo(.normal, duration: 0.0)
    }

    // MARK: Shadow functions

    /// Updates the shadow of the view to the specified type.
    /// If duration = 0, no animation is performed.
    internal func setShadowTo(_ type: LPShadowType, duration: TimeInterval) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)

        // Animate the shadow opacity and radius change
        let shadowOpacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowOpacityAnimation.fromValue = type == .normal ? touchedShadowOpacity : normalShadowOpactiy
        shadowOpacityAnimation.toValue = type == .normal ? normalShadowOpactiy : touchedShadowOpacity
        shadowOpacityAnimation.duration = duration
        let shadowRadiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
        shadowRadiusAnimation.fromValue = type == .normal ? touchedShadowRadius : normalShadowRadius
        shadowRadiusAnimation.toValue = type == .normal ? normalShadowRadius : touchedShadowRadius
        shadowRadiusAnimation.duration = duration
        self.layer.add(shadowOpacityAnimation, forKey: "shadowOpacity")
        self.layer.add(shadowRadiusAnimation, forKey: "shadowRadius")

        self.layer.shadowOpacity = type == .normal ? normalShadowOpactiy : touchedShadowOpacity
        self.layer.shadowRadius = type == .normal ? normalShadowRadius : touchedShadowRadius
    }
}
