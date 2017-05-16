//
//  Toggler.swift
//  ffs2222

import SpriteKit

final class RefBool {
  
  var value: Bool
  
  var isOn: Bool {
    get { return self.value }
    set { value = newValue }
  }
  var isTrue: Bool {
    get { return self.value }
    set { value = newValue  }
  }
  
  init(_ value: Bool) {
    self.value = value
  }
};

final class RefDouble {
  var value: Double
  
  init(_ value: Double) {
    self.value = value
  }
};

// MARK: - Toggler:
public final class Toggler: SKLabelNode {
  
  private var refBool: RefBool
  var value: Bool { return refBool.value }
  
  var labelName: String
  /*
   var offText = ""
   var onText = ""
   */
  
  func toggleOn() {
    refBool.value = true
    text = labelName + ": on"
  }
  
  func toggleOff() {
    refBool.value = false
    text = labelName + ": off"
  }
  
  /*init(offText: String, onText: String, refBool: RefBool) {
   ref = refBool
   super.init(fontNamed: "Chalkduster")
   if refBool.value { toggleOn() } else { toggleOff() }
   isUserInteractionEnabled = true
   }
   */
  
  init(labelName: String, refBool: RefBool) {
    self.refBool = refBool
    self.labelName = labelName
    super.init(fontNamed: "Chalkduster")
    isUserInteractionEnabled = true
    
    self.refBool = refBool
    self.labelName = labelName
    if refBool.value { toggleOn() } else { toggleOff() }
  }
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if refBool.value { toggleOff() } else { toggleOn() }
  }
  
  public required init?(coder aDecoder: NSCoder) { fatalError("") }
  override init() {
    self.refBool = RefBool(false)
    self.labelName = "ERROR"
    super.init()
  }
};

// MARK: - Adjustor:
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
  
  private var refDouble: RefDouble
  
  var number: Double {
    get {
      guard let txt = numLabel.text else { return -99 }
      if let num = Double(txt) {
        return num
      } else { return -99 }
    }
    set {
      refDouble.value = newValue
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
  
  init(text: String, refDouble: RefDouble, step: Double) {
    self.refDouble = refDouble
    super.init()
    
    let number = refDouble.value
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

