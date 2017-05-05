
import SpriteKit



class Toggler: SKLabelNode {
  
  var value = false
  
  var offText = ""
  var onText = ""
  
  func toggleOn() {
      value = true
      text = onText
  }
  
  func toggleOff() {
    value = false
    text = offText
  }
  
   init(text: String, state) {
    super.init(fontNamed: "Chalkduster")
    self.text = text
    isUserInteractionEnabled = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("") }
  override init() { super.init() }
};
