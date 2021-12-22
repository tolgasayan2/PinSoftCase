//
//  Films.swift
//  PinSoftCase
//
//  Created by Tolga Sayan on 20.12.2021.
//



struct Film: Decodable {
  let title: String
  let releaseDate: String
  let genre: String
  let director: String
  let actors: String
  let artworkUrl: String
  
  enum CodingKeys: String, CodingKey {
      case title = "Title"
      case releaseDate = "Released"
      case genre = "Genre"
      case director = "Director"
      case actors = "Actors"
      case artworkUrl = "Poster"
    }
}


extension Film: Displayable {
  
  var titleLabel: String {
    title
  }
  
  var genreText: String {
    genre
  }
  
  var release: String {
    releaseDate
  }
  
  var directorLabel: String {
    director
  }
  
  var actorLabel: String {
    actors
  }
  var artwork: String {
    artworkUrl
  }
}

