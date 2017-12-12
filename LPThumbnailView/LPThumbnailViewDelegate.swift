//
//  LPThumbnailViewDelegate.swift
//  LPThumbnailView
//
//  Created by Luis Padron on 12/12/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

/**
 LPThumbnailViewDelegate

 The delegate responsible with listening to any touches or other updates that are called from `LPThumbnailView`
 */
public protocol LPThumbnailViewDelegate: class {
    /// This function is called whenever a `LPThumbnailView` determines a touch has happened.
    func thumbnailViewWasTapped(_ view: LPThumbnailView)
}
