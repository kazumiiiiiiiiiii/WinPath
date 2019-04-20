//
//  BookmarkManager.swift
//  WinPath
//
//  Created by Apple on 2018/11/26.
//  Copyright © 2018 Kazumi Watanabe. All rights reserved.
//

import Cocoa

class BookmarkManager: NSObject {

    static func addBookmark(name: String, type: Int, open: String, input: String) -> Bool
    {
        // 日時フォーマット作成
        let formatter = DateFormatter()
        // スタイル指定
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        // 対象を日本時間にセット
        formatter.locale = Locale(identifier: Const.locale)
        // データ生成
        let putData = jsonBook(name: name, type: type, open: open, input: input, exec: formatter.string(from: Date()))
        // Json読み込み
        let json = Json.loadBookmarkJsonFile(file: Const.bookmarkFile)
        // 書込コンテンツを生成
        var writeContents = json ?? jsonBookmark(records: [])
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
        return self.saveBookmark(bookmarks: writeContents)
    }
    static func saveBookmark(bookmarks: jsonBookmark) -> Bool
    {
        // 履歴保存
        return Json.saveBookmarkJsonFile(contents: bookmarks, file: Const.bookmarkFile)
    }
}
