//
//  UserDefaults.swift
//  ffs2222

import Foundation

struct UD {
  
  static let userDefaults = UserDefaults.standard
  
  struct Keys {
    static let highscore = "highschore"
  }
  
  static func initUserDefaults() {
    if userDefaults.value(forKey: Keys.highscore) == nil {
      userDefaults.setValue(0, forKey: Keys.highscore)
    }
  }
  static func saveHighScore() {
    
    guard let oldHS = userDefaults.value(forKey: Keys.highscore) as? Int else { print("bad key"); return }
    if score > oldHS {
      userDefaults.setValue(score, forKey: Keys.highscore)
      print("saved high score!")
    }
  }
  static func loadHighScore() {
    guard let value = userDefaults.value(forKey: Keys.highscore) else { print("no hs in UD"); return }
    guard let hs = value as? Int else { print("value was not Int"); return }
    highscore = hs
    print("loaded high score!")
  }
};
