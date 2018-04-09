//
//  LPThumbnailViewAnimationStyle.swift
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
