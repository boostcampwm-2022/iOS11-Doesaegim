//
//  String+truncate.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/26.
//

import Foundation

extension String {
    
  func truncate(length: Int, trailing: String = "…") -> String {
    return (self.count > length) ? self.prefix(length) + trailing : self
  }
}
