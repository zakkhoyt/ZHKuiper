//
//  ZHShapeNodeColor.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 3/12/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import Foundation

enum ZHShapeNodeColor: UInt {
    case Black = 0
    case Blue = 1
    case Brown = 2
    case Cyan = 3
    case Green = 4
    case Magenta = 5
    case Orange = 6
    case Purple = 7
    case Red = 8
    case White = 9
    case Yellow = 10
    case BlackPoly = 11
    case BluePoly = 12
    case BrownPoly = 13
    case CyanPoly = 14
    case GreenPoly = 15
    case MagentaPoly = 16
    case OrangePoly = 17
    case PurplePoly = 18
    case RedPoly = 19
    case WhitePoly = 20
    case YellowPoly = 21
    case BlackStar = 22
    case BlueStar = 23
    case BrownStar = 24
    case CyanStar = 25
    case GreenStar = 26
    case MagentaStar = 27
    case OrangeStar = 28
    case PurpleStar = 29
    case RedStar = 30
    case WhiteStar = 31
    case YellowStar = 32
    
    
    static var randomColor: ZHShapeNodeColor {
        let random = arc4random_uniform(32)
        if let color = ZHShapeNodeColor(rawValue: UInt(random)) {
            return color
        }
        return .White
    }
    
    var contactBitMask: UInt32 {
        let mask = 1 << self.rawValue
        return UInt32(mask)
    }
    
    var imageNameFromBBColor: String {
        var name = ""
        switch self {
        case .Black:
            name = "black"
        case .Blue:
            name = "blue"
        case .Brown:
            name = "brown"
        case .Cyan:
            name = "cyan"
        case .Green:
            name = "green"
        case .Magenta:
            name = "magenta"
        case .Orange:
            name = "orange"
        case .Purple:
            name = "purple"
        case .Red:
            name = "red"
        case .White:
            name = "white"
        case .Yellow:
            name = "yellow"
        case .BlackPoly:
            name = "black_poly"
        case .BluePoly:
            name = "blue_poly"
        case .BrownPoly:
            name = "brown_poly"
        case .CyanPoly:
            name = "cyan_poly"
        case .GreenPoly:
            name = "green_poly"
        case .MagentaPoly:
            name = "magenta_poly"
        case .OrangePoly:
            name = "orange_poly"
        case .PurplePoly:
            name = "purple_poly"
        case .RedPoly:
            name = "red_poly"
        case .WhitePoly:
            name = "white_poly"
        case .YellowPoly:
            name = "yellow_poly"
        case .BlackStar:
            name = "black_star"
        case .BlueStar:
            name = "blue_star"
        case .BrownStar:
            name = "brown_star"
        case .CyanStar:
            name = "cyan_star"
        case .GreenStar:
            name = "green_star"
        case .MagentaStar:
            name = "magenta_star"
        case .OrangeStar:
            name = "orange_star"
        case .PurpleStar:
            name = "purple_star"
        case .RedStar:
            name = "red_star"
        case .WhiteStar:
            name = "white_star"
        case .YellowStar:
            name = "yellow_star"
        }
        return name
    }
    
    
}