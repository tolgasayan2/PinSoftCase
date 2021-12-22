//
//  Displayable.swift
//  PinSoftCase
//
//  Created by Tolga Sayan on 20.12.2021.
//

protocol Displayable {
  var titleLabel: String { get }
  var genreText: String { get }
  var release: String { get }
  var directorLabel: String { get }
  var actorLabel: String { get }
  var artwork: String { get }
}
