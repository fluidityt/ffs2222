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

// See also: Toggler

