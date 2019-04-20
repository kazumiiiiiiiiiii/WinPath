//
//  String.swift
//  WInPath
//
//  Created by Apple on 2018/11/10.
//  Copyright © 2018年 Kazumi Watanabe. All rights reserved.
//

import Cocoa

extension String {

    /**
     * 区切り文字で配列を作成する
     */
    func explode(separator: String) -> Array<String>
    {
        return self.components(separatedBy: separator)
    }
    
}
