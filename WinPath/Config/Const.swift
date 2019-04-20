//
//  Const.swift
//  WInPath
//
//  Created by Apple on 2018/11/10.
//  Copyright © 2018年 Kazumi Watanabe. All rights reserved.
//

import Cocoa

class Const: NSObject {

    // ロケーション
    class var locale: String       { return "ja_JP" }
    // ブックマークファイル名
    class var bookmarkFile: String { return "bookmark.json" }
    // 履歴ファイル名
    class var historyFile: String  { return "history.json" }
    // 余白サイズ
    class var margin: CGFloat      { return 10.0; }
    // パスアイテム名
    class var pathName: String     { return "パス" }
    // パスメニュー名
    class var pathMenu: String     { return self.pathName + "変換" }
    // ブックマークアイテム名
    class var bookmarkName: String { return "パス" }
    // ブックマークメニュー名
    class var bookmarkMenu: String { return "保存" + self.bookmarkName }
    // 履歴アイテム名
    class var historyName: String  { return "履歴" }
    // 履歴メニュー名
    class var historyMenu: String  { return self.historyName }
    // 文字列変換対象の配列
    class var pathConvertTargets: [String:String] {
        return [
            "アプリケーション" : "Applications",
            "システム" : "System",
            "ユーザー" : "Users",
            "ライブラリ" : "Library",
            "ダウンロード" : "Downloads",
            "デスクトップ" : "Desktop",
            "パブリック" : "Public",
            "ピクチャ" : "Pictures",
            "ミュージック" : "Music",
            "ムービー" : "Movies",
            "書類" : "Documents"
        ]
    }
    
    class var bookmarkLimit: Int {
        return 100
    }
    
    
}
