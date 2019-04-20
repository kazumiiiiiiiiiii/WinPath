//
//  PathManager.swift
//  WIndowsPathOpen
//
//  Created by Apple on 2018/11/09.
//  Copyright © 2018年 Kazumi Watanabe. All rights reserved.
//

import Cocoa

class PathManager: NSObject {

    static func configure()
    {
        // ファイルマネージャー
        let manager = FileManager.default
        // ドキュメントパス
        let historyFilePath = manager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(Const.historyFile)
        // ドキュメントパス
        let bookmarkFilePath = manager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(Const.bookmarkFile)
        print(Const.historyFile);
        // ファイルが存在しているか確認
        if (manager.fileExists(atPath: historyFilePath.path) == false) {
            _ = Json.saveHistoryJsonFile(contents: jsonHistory(records: []), file: Const.historyFile)
        }
        // ファイルが存在しているか確認
        if (manager.fileExists(atPath: bookmarkFilePath.path) == false) {
            _ = Json.saveBookmarkJsonFile(contents: jsonBookmark(records: []), file: Const.bookmarkFile)
        }
    }
    
    /**
     * Win→Macへ変換する
     */
    static func convertToMac(path: String) -> String
    {
        var convert = path
        convert = convert.replacingOccurrences(of: "\\", with: "/")
        
        return convert
    }
    /**
     * Mac→Winへ変換する
     */
    static func convertToWin(path: String) -> String
    {
        var convert = path
        convert = convert.replacingOccurrences(of: "/", with: "\\")
        
        return convert
    }
    /**
     * パスを開くための変換を行う
     */
    static func openPath(path: String, select: String) -> (type: Int, open: String, input: String)
    {
        // 戻り値
        var type: Int = 1
        var open: String = ""
        var input: String = ""
        // アクセスを確認
        if (path.hasPrefix("//")) { // ファイルサーバー
            // 入力パスの作成
            input = select + path
            // パスを変換
            open = select + PathManager.urlEncode(path: path)
            // サーバーに変更
            type = 2
        } else {
            // 入力パスを格納
            input = path
            open = PathManager.convertJapaneseDirectory(path: path)
        }
        // リターン
        return (type, open, input)
    }
    /**
     * Pathを開く
     */
    static func open(type: Int, open: String, input: String) -> Bool
    {
        // アクセスを確認
        if (type == 2) { // ファイルサーバー
            // オープン
            NSWorkspace.shared.open(URL(string: open)!)
        } else {
            // ディレクトリのパスに変更
            let rootedPath = (open as NSString).expandingTildeInPath
            // エラー時
            if (NSWorkspace.shared.selectFile(open, inFileViewerRootedAtPath: rootedPath) == false) {
                // リターン
                return false;
            }
        }
        // リターン
        return true
    }
    /**
     * 日本語ディレクトリを英語化する
     */
    static func convertJapaneseDirectory(path: String) -> String
    {
        // 変換後の格納先
        var convertPath = ""
        // 置換対象の文字列
        let convertTargets:[String:String] = Const.pathConvertTargets
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
    /**
     * 日本語ディレクトリをURLエンコードする
     */
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
    /**
     * 履歴を登録する
     */
    static func addHistory(type: Int, open: String, input: String) -> Bool
    {
        // 日時フォーマット作成
        let formatter = DateFormatter()
        // スタイル指定
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        // 対象を日本時間にセット
        formatter.locale = Locale(identifier: Const.locale)
        // データ生成
        let putData = jsonRecord(type: type, open: open, input: input, exec: formatter.string(from: Date()))
        // Json読み込み
        let json = Json.loadHistoryJsonFile(file: Const.historyFile)
        // 書込コンテンツを生成
        var writeContents = json ?? jsonHistory(records: [])
        // 追加
        writeContents.records.insert(putData, at: 0)
        // 記録数が100件を超えている場合
        if (writeContents.records.count > 100) {
            // 100件目以降
            for _ in 100..<writeContents.records.count {
                // 削除
                writeContents.records.removeLast()
            }
        }
        // 履歴保存
        return Json.saveHistoryJsonFile(contents: writeContents, file: Const.historyFile)
    }
    
}
