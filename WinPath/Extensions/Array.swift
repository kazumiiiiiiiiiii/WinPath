//
//  Array.swift
//  WInPath
//
//  Created by Apple on 2018/11/10.
//  Copyright © 2018年 Kazumi Watanabe. All rights reserved.
//

import Cocoa

extension Array {

    /**
     * キーの存在を確認する
     */
    func hasKey(key: Int) -> Bool
    {
        return (self.count >= key + 1)
    }
    
}
