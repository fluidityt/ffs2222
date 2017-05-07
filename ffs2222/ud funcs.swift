//
//  UserDefaults.swift
//  ffs2222

import Foundation

struct UD {
  
  static let userDefaults = UserDefaults.standard
  
  struct Keys {
    static let highScore = "highschore"
  }
  
  static func initUserDefaults() {
    if userDefaults.value(forKey: Keys.highScore) == nil {
      userDefaults.setValue(0, forKey: Keys.highScore)
    }
  }
  
  static func saveHighScore() {
    
    guard let oldHS = userDefaults.value(forKey: Keys.highScore) as? Int else { print("bad key"); return }
    if g.score > oldHS {
      g.highscore = g.score
      g.mainmenu?.updateScore()
      FailScene.newHighscore = true
      userDefaults.setValue(g.score, forKey: Keys.highScore)
      print("saved high g.score!")
    }
  }
  
  static func loadHighScore() {
    guard let value = userDefaults.value(forKey: Keys.highScore) else { print("no hs in UD"); return }
    guard let hs = value as? Int else { print("value was not Int"); return }
    g.highscore = hs
    g.mainmenu?.updateScore()
    print("loaded high g.score!")
  }
  
  static func setHighScore(to value: Int) {
    userDefaults.setValue(value, forKey: Keys.highScore)
    g.highscore = value
    g.mainmenu?.updateScore()
    print("reset g.highscore")
  }
  
};
