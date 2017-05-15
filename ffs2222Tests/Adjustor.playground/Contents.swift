import SpriteKit
import PlaygroundSupport

let size = CGSize(width: 600, height: 500)
let view = SKView(frame: CGRect(x: 500, y: 500, width: size.width, height: size.height))
let scene = SKScene(size: size)
scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

PlaygroundPage.current.liveView = view
view.presentScene(scene)

print("hi")

public final class Adjustor: SKLabelNode {
  
  private let left  = AdjustorButtonLeft()
  private let right = AdjustorButtonRight()
  
  private let numLabel = SKLabelNode()
  private let txtLabel = SKLabelNode()
  
  private let width = CGFloat(140)
  private let node = SKSpriteNode()
  
  public override var text: String? {
    get {
      if let txt = txtLabel.text{
        return txt
      } else { return "error" }
    }
    set {
      txtLabel.text = newValue
    }
  }
  
  var number: Double {
    get {
      guard let txt = numLabel.text else { return -99 }
      if let num = Double(txt) {
        return num
      } else { return -99 }
    }
    set {
      numLabel.text = String(newValue)
    }
  }
  
  var step = 1.0
  
  // Funcs:
  private func activateButtons() {
    left .isUserInteractionEnabled = true
    right.isUserInteractionEnabled = true
  }
  
  private func getBiggerSize() -> CGSize {
    if numLabel.frame.width > txtLabel.frame.width {
      return numLabel.frame.size
    } else {
      return txtLabel.frame.size
    }
  }

  private func setColor(to color: SKColor) {
      left.color = color
    right.color = color
    txtLabel.fontColor = color
    numLabel.fontColor = color
  }
  
  private func setSizes() {
    node.size.width = (getBiggerSize().width + width)
    node.size.height = (numLabel.frame.size.height + txtLabel.frame.size.height)
    }
  
  private func makeButtonsUI() {
    left.size   = CGSize(width: 30, height: 30)
    left.color  = .black
    right.size  = CGSize(width: 45, height: 45)
    right.color = .black
    
    left .position.x = node.frame.minX + (left.frame.width/2) + 5
    right.position.x = node.frame.maxX - (right.frame.width/2) - 5
    
    right.zPosition += 50
  }
  
  private func makeLabelsUI() {
    txtLabel.fontName  = "Chalkduster"
    numLabel.fontName  = "Chalkduster"
    txtLabel.fontColor = .black
    numLabel.fontColor = .black
    txtLabel.verticalAlignmentMode = .center
    numLabel.verticalAlignmentMode = .center
    txtLabel.position.y = node.frame.maxY - (txtLabel.frame.height/2)
    numLabel.position.y = node.frame.minY + (numLabel.frame.height/2)
  }
  
  init(text: String, number: Double, step: Double) {
    super.init()
    //super.init(texture: nil, color: SKColor.clear, size: CGSize.zero)
    self.text   = text
    self.number = number
    if step <= 0 {
      self.step = 1
    } else { self.step = step }
    
    setSizes()
    makeButtonsUI()
    makeLabelsUI()
    setColor(to: .black)
    activateButtons()
    
    let shape = SKShapeNode(rect: frame)
    shape.strokeColor = .black
    
    func addChildren(_ nodes: [SKNode]) { for cnode in nodes { node.addChild(cnode) } }
    addChild(node)
    addChildren([left, right, numLabel, txtLabel, shape])
  }
  
  public required init?(coder aDecoder: NSCoder) { fatalError() }
  
  private final class AdjustorButtonLeft:  SKSpriteNode {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if let node = parent {
        if let adjustor = node.parent as? Adjustor { adjustor.number -= (1 * adjustor.step) }
      }
    }
  }
  
  private final class AdjustorButtonRight: SKSpriteNode {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if let node = parent {
        if let adjustor = node.parent as? Adjustor { adjustor.number += (1 * adjustor.step) }
      }
    }
  }
};

scene.addChild(Adjustor(text: "hey there", number: 5, step: 1))