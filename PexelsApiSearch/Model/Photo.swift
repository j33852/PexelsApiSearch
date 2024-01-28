//
//  Photo.swift
//  PexelsApiSearch
//
//  Created by Chun Chieh Chang on 2024/01/26.
//

import Foundation

/*
 Pexel API Document: https://www.pexels.com/api/documentation/#
 */
struct Photo: Codable {

    let id: Int
    let url: String
    let photographer: String
    let src: PhotoSource

    func thumbUrl() -> URL? {
        return URL(string: src.tiny)
    }

    func originalPhotoUrl() -> URL? {
        return URL(string: src.original)
    }
}

struct PhotoSource: Codable {
    let original: String
    let tiny: String
}

struct SearchResult: Codable {
    let nextPage: String?
    let photos: [Photo]

    init() {
        nextPage = ""
        photos = []
    }

    private enum CodingKeys : String, CodingKey {
        case photos, nextPage = "next_page"
    }
}

