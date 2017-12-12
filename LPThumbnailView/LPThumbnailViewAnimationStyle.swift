//
//  LPThumbnailViewAnimationStyle.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/12/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

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
