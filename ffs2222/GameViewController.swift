//  Created by justin fluidity on 4/26/17.

// DESIGN: Have boxes laugh at you once you die...
// DESIGN: Game mode... TWO yellow boxes??
// DESIGN: Different shapes?
// DESIGN: Boxes rotate / warp?

// TODO: Fairness algo
// TODO: Options screen
// TODO: Eye animations
// TODO: GameCenter
// TODO: Options menu

// FIXME: Update yellow box bound constraints
// FIXME: Random global stuff in DoContact and Spawner

import SpriteKit

// Globals:
var gview = SKView()
var gsi   = GameScene()
var score = 0 // Too lazy to make an init for other scenes...
var highscore: Int = 0

var devmode = false
var devdifficulty = 5
let fairness = CGFloat(15) // 5 points on either side?

class GameViewController: UIViewController {
  
  private let mySize = CGSize(width: 600, height: 500)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let view = self.view as! SKView? else { fatalError("wtf happened") }; do {
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
      view.frame = CGRect(x: 0, y: 0, width: mySize.width, height: mySize.height)
      // g.view = view
    }
    
    let scene = LaunchScene(size: CGSize(width: 600, height: 1000))
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

