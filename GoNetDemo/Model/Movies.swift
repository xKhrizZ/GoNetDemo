//
//  Movies.swift
//  GoNetDemo
//
//  Created by Christian Rojas on 17/02/22.
//

import Foundation

struct Movies: Codable {
    let page: Int?
    let results: [Results]?
}

struct Results: Codable {
    let adult: Bool?
    let backdrop_path: String?
    let id: Int?
    let media_type: String?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Float?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let video: Bool?
    let vote_average: Float?
    let vote_count: Int?
}
