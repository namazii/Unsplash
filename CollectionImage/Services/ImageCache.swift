//
//  ImageCache.swift
//  CollectionImage
//
//  Created by Назар Ткаченко on 08.05.2022.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
