//
//  Model.swift
//  AzimeProject
//
//  Created by Артем Мак on 10.12.2021.
//  Copyright © 2021 Артем Мак. All rights reserved.
//

//MARK: - ModelFilm
struct  ModelFilm: Decodable {
    var results: [Film]
}

//MARK: - Film
struct  Film: Decodable {
    var id: Int?
    var poster_path: String?
    var original_title: String?
    var title: String?
    var vote_average: Double?
    var vote_count: Int?
    var release_date: String?
    var genre_ids: [Int]?
}
