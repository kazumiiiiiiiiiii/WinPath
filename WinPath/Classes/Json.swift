//
//  Json.swift
//  WinPath
//
//  Created by Apple on 2018/11/11.
//  Copyright © 2018 Kazumi Watanabe. All rights reserved.
//

import Cocoa

struct jsonHistory: Codable {
    var records: [jsonRecord]
}
struct jsonRecord: Codable {
    var type: Int
    var open: String
    var input: String
    var exec: String
}

struct jsonBookmark: Codable {
    var records: [jsonBook]
}
struct jsonBook: Codable {
    var name: String
    var type: Int
    var open: String
    var input: String
    var exec: String
}

class Json: NSObject {

    // MARK: History
    
    static func loadHistoryJsonFile(file: String) -> jsonHistory! {
        // ファイルマネージャー
        let manager = FileManager.default
        // ドキュメントパス
        let filePath = manager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(file)
        // ファイルが存在しているか確認
        if (manager.fileExists(atPath: filePath.path)) {
            // 実行
            do {
                // データを読込
                let loadData = try Data(contentsOf: filePath)
                // 読み込んでリターン
                return try JSONDecoder().decode(jsonHistory.self, from: loadData)
            } catch _ as NSError {
                // エラーでリターン
                return nil
            }
        }
        // エラーでリターン
        return nil
    }
    
    static func saveHistoryJsonFile(contents: jsonHistory, file: String) -> Bool
    {
        // ファイルマネージャー
        let manager = FileManager.default
        // ドキュメントパス
        let filePath = manager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(file)
        print(filePath);
        // ファイルが存在しているか確認
        if (manager.fileExists(atPath: filePath.path)) {
            // 実行
            do {
                // 削除
                try manager.removeItem(at: filePath)
            } catch _ as NSError {
                // エラーでリターン
                return false
            }
        }
        // jsonエンコーダー
        let encoder = JSONEncoder()
        // エンコード出力を設定
        encoder.outputFormatting = .prettyPrinted
        // 実行
        do {
            // エンコード
            let encoded = try encoder.encode(contents)
            // 書き出し
            try String(data: encoded, encoding: .utf8)!.write(to: filePath, atomically: false, encoding: .utf8)
        } catch _ as NSError {
            // エラーでリターン
            return false
        }
        // リターン
        return true
    }
    
    // MARK: Bookmark
    
    static func loadBookmarkJsonFile(file: String) -> jsonBookmark! {
        // ファイルマネージャー
        let manager = FileManager.default
        // ドキュメントパス
        let filePath = manager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(file)
        // ファイルが存在しているか確認
        if (manager.fileExists(atPath: filePath.path)) {
            // 実行
            do {
                // データを読込
                let loadData = try Data(contentsOf: filePath)
                // 読み込んでリターン
                return try JSONDecoder().decode(jsonBookmark.self, from: loadData)
            } catch _ as NSError {
                // エラーでリターン
                return nil
            }
        }
        // エラーでリターン
        return nil
    }
    
    static func saveBookmarkJsonFile(contents: jsonBookmark, file: String) -> Bool
    {
        // ファイルマネージャー
        let manager = FileManager.default
        // ドキュメントパス
        let filePath = manager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(file)
        // ファイルが存在しているか確認
        if (manager.fileExists(atPath: filePath.path)) {
            // 実行
            do {
                // 削除
                try manager.removeItem(at: filePath)
            } catch _ as NSError {
                // エラーでリターン
                return false
            }
        }
        // jsonエンコーダー
        let encoder = JSONEncoder()
        // エンコード出力を設定
        encoder.outputFormatting = .prettyPrinted
        // 実行
        do {
            // エンコード
            let encoded = try encoder.encode(contents)
            // 書き出し
            try String(data: encoded, encoding: .utf8)!.write(to: filePath, atomically: false, encoding: .utf8)
        } catch _ as NSError {
            // エラーでリターン
            return false
        }
        // リターン
        return true
    }
}
