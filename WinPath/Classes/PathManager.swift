//
//  PathManager.swift
//  WIndowsPathOpen
//
//  Created by Apple on 2018/11/09.
//  Copyright © 2018年 Kazumi Watanabe. All rights reserved.
//

import Cocoa

class PathManager: NSObject {

    static func convertJapaneseDirectory(path: String) -> String
    {
        // 変換後の格納先
        var convertPath = ""
        // 置換対象の文字列
        let convertTargets:[String:String] = [
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
        // 配列に「/」区切りで格納
        var strArr = path.explode(separator: "/")
        // 対象キー格納配列
        var targetKeys:Array<Int> = [];
        // 状態判定
        if (strArr[0] == "~") { // ユーザディレクトリ
            // ユーザーディレクトリ下のディレクトリを対象
            targetKeys = [1]
        } else if (strArr[0].count == 0) { //絶対パス指定
            // HD直下、ユーザーディレクトリ下のディレクトリを対象
            targetKeys = [1, 3]
            
        }
        // 件数分繰り返し
        for key in targetKeys {
            // キーが存在している場合
            if (strArr.hasKey(key: key)) {
                // キーが存在している場合
                if (convertTargets.keys.contains(strArr[key])) {
                    // 値を置換
                    strArr[key] = convertTargets[strArr[key]]!
                }
            }
        }
        // パスを生成
        convertPath += strArr.joined(separator: "/")
        // リターン
        return convertPath;
    }
    
    static func urlEncode(path: String) -> String
    {
        // 配列に「/」区切りで格納
        let strArr = path.explode(separator: "/")
        var encArr:Array<String> = []
        // 変換後の格納先
        var encodePath = ""
        // 件数分繰り返し
        for value in strArr {
            // エンコード後の配列に格納
            encArr.append(value.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        }
        // パスを生成
        encodePath += encArr.joined(separator: "/")
        // リターン
        return encodePath
    }
    
}
