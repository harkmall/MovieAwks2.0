//
//  RatingEmojiRepresentable.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-10.
//

import Foundation

protocol RatingEmojiRepresentable {
    var rating: Float? { get }
}

extension RatingEmojiRepresentable {
    var emojiRating: String {
        guard let rating = rating else { return "-" }
        
        var emoji = "-"
        switch rating {
        case (0..<2):
            emoji = "😇"
        case (2..<4):
            emoji = "😐"
        case (4..<6):
            emoji = "😔"
        case (6..<8):
            emoji = "😬"
        case (8..<10):
            emoji = "😵"
        case 10:
            emoji = "💀"
        default:
            emoji = "-"
        }
        
        return "\(emoji) \(rating.formatted(.number.precision(.integerAndFractionLength(integerLimits: 1...2, fractionLimits: 1...1))))"
    }
}

extension Float: RatingEmojiRepresentable {
    var rating: Float? {
        return self
    }
}
