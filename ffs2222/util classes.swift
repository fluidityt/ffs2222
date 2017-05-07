//
//  Toggler.swift
//  ffs2222

import SpriteKit

class RefBool {
  var value: Bool
  init(_ value: Bool) {
    self.value = value
  }
}

class Toggler: SKLabelNode {
  
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if refBool.value { toggleOff() } else { toggleOn() }
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("") }
  override init() {
    self.refBool = RefBool(false)
    self.labelName = "ERROR"
    super.init()
  }
};


