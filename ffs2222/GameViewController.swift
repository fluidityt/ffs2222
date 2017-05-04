//  Created by justin fluidity on 4/26/17.

// DESIGN: Have boxes laugh at you once you die...
// DESIGN: Game mode... TWO yellow boxes??
// DESIGN: Different shapes?
// DESIGN: Boxes rotate / warp?
// DESIGN: Make whole screen touchable?
// DESIGN: Increase difficulty
// DESIGN: Powerups / attacks?
// DESIGN: Difficulty?

// CREV: Random global stuff in DoContact and Spawner
// CREV: Config file (difficulty / globals)
// CREV: DoContact in serious need of guards

// TODO: Add win caption to failscene
// TODO: Add score label
// TODO: Options screen
// TODO: Eye animations
// TODO: GameCenter
// TODO: Options menu
// TODO: Add fullscreen version

// MAYBE: Add complex devmode to startscreen and options menu
// MAYBE: Add top 10 HS with names

// FIXME: Highscore on die-screen is broken if you get a new highscore
// FIXME: Horizontal double box hit still kills
// -----> need to actually delete the whole "box" even if it is 3-4 long etc

import SpriteKit

// Globals:
var gview = SKView()
var gsi   = GameScene()
var score = 0 // Too lazy to make an init for other scenes...
var highscore: Int = 0
var mainmenu: MainMenuScene? = nil

var devmode = false
var devdifficulty = 0


class GameViewController: UIViewController {
  
  private let mySize = CGSize(width: 600, height: 500)
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    // UD.setHighScore(to: 104)
    
    guard let view = self.view as! SKView? else { fatalError("wtf happened") }; do {
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
      view.frame = CGRect(x: 0, y: 0, width: mySize.width, height: mySize.height)
      // g.view = view
    }
    
    let scene = MainMenuScene(size: CGSize(width: 600, height: 1000))
    scene.scaleMode = .aspectFit
    view.presentScene(scene)
  }
  
  override var shouldAutorotate: Bool { return true }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone { return .allButUpsideDown }
    else { return .all }
  }
  override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
  override var prefersStatusBarHidden: Bool { return true }
}

