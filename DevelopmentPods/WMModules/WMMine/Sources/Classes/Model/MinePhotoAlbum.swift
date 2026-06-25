//
//  MinePhotoAlbum.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import SmartCodable

struct MinePhotoAlbum: SmartCodableX {
    var imagePath: String?
    var sort: Int?
    var id: Int?
}

extension MinePhotoAlbum: Equatable {
    public static func == (lhs: MinePhotoAlbum, rhs: MinePhotoAlbum) -> Bool {
        return lhs.sort == rhs.sort && lhs.imagePath == rhs.imagePath && lhs.id == rhs.id
    }
}
