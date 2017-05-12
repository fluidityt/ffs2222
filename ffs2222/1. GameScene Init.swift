// Initial difficulty numbers: num 4, mod 6
import SpriteKit

enum State { case game, main, fail, loading }

enum Category {
  static let
  zero =    UInt32 (0),    yellow =  UInt32 (1),    black =   UInt32 (2),
  three =   UInt32 (4),    line  =   UInt32 (8),    death =   UInt32 (16)
};

/// Globals:
struct g {
  
  static var
  
  // SK Objects:
  view       = SKView(),
  gameScene  = GameScene(),
  nextAction = SKAction(),
  mainmenu:    MainMenuScene?,
  scoreLabel:  SKLabelNode?,
  player:      Player?,
  
  // Score:
  linesCleared   = 0,
  score          = 0,
  sessionScore   = 0,
  highscore: Int = 0,
  
  // Modes:
  mode       = (dev:   RefBool(false), spin: RefBool(false),
                fade:  RefBool(false), full: RefBool(false),
                score: RefBool(false), nh:   RefBool(true)),
  
  // Difficulty / UI Settings:
  fairness       = 15,
  difficulty = (boxNum: 4,
                boxNumMod: 4,
                boxSpeed: 1.0,
                boxSize: CGFloat(1.5)),
  size30 = CGSize(width: 30, height: 30),
  notificationHeight: CGFloat  = ((gameScene.size.height/7)/2),
  
  // Logic:
  state      = State.loading,
  waiting      = false,     // Used for score increase at end of loop.
  hits         = 0,         // Player HP.
  hitThisFrame = false,     // Used to keep player alive when hit 2 black at same time.
  paused       = false,
  isInvincible = false      // Used for contact in loop
};


// MARK: - DMV:
class GameScene: SKScene, SKPhysicsContactDelegate {
  
  private func selfInit() {
    //view!.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
    scaleMode = .aspectFit
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    setBackGroundColor(forScene: self)
    physicsWorld.contactDelegate = self
    physicsWorld.gravity = CGVector(dx: 0, dy: -0.25)
  }
  
  private func spawnStuff() {
    var spawn = Spawner(gsi: self)
    spawn.yellowNode()
    spawn.lineOfBlackBoxes(difficulty: (g.difficulty.boxNum, randy(g.difficulty.boxNumMod)))
    spawn.deathLine()
    spawn.touchPad()
    spawn.scoreLabel()
  }

  // Not private:
  func updateAction() {

    g.nextAction = {
      let wait     = SKAction.wait(forDuration: g.difficulty.boxSpeed)
      let run      = SKAction.run {
        var spawn = Spawner(gsi: self)
        spawn.lineOfBlackBoxes(
          difficulty: (base: g.difficulty.boxNum, mod:  randy(g.difficulty.boxNumMod)))
      }
      let onFinish = SKAction.run { self.run(g.nextAction) }
      let sequence = SKAction.sequence([wait,run,onFinish])
      
      return sequence
    }()
  }
  
  override func didMove(to view: SKView) {
    // OMFG what have I become??
    g.state = .main
    
    print("Welcome to Sprite Attack! Your HS is \(g.highscore)")
    
    selfInit()
    spawnStuff()
    updateAction()
    
    run(g.nextAction)
    
    // if g.modes.values.contains(.dev) { isInvincible = true }
    if g.mode.dev.value  { g.isInvincible = true         }
    if g.mode.fade.value { g.difficulty.boxSpeed -= 0.15 }
    
    g.score = 0
    g.linesCleared = 0
  }
};
