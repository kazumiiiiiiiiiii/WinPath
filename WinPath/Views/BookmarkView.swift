//
//  BookmarkView.swift
//  WinPath
//
//  Created by Apple on 2018/11/11.
//  Copyright © 2018 Kazumi Watanabe. All rights reserved.
//

import Cocoa

class BookmarkView: NSView {

    // MARK: GlobalVariables
    
    var scrollView = NSScrollView()
    var clipView = NSClipView()
    var contentsView = NSView()
    var nullView = NSTextView()
    var bookmarks: jsonBookmark!
    var bookmarkViews: Array<[String: Any]> = Array<[String: Any]>()
    
    // MARK: InitFunctions
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setSelfView()
        self.setViewFrame(frame: frameRect)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    // MARK: ApplicationEvenets
    
    /**
     * ブックマークから開くメソッド
     */
    @objc func openBookmark(_ sender: NSButton)
    {
        // ブックマークを取得
        let bookmark = bookmarks.records[sender.tag];
        // パスを開く
        if (PathManager.open(type: bookmark.type, open: bookmark.open, input: bookmark.input)) {
            
            // 履歴を登録
            if (PathManager.addHistory(type: bookmark.type, open: bookmark.open, input: bookmark.input) == false) {
                // エラーを出力
                self.error(message: Const.historyName + "の保存に失敗しました", button: "OK")
            }
            
        } else {
            // エラーを出力
            self.error(message: "ご指定の" + Const.pathName + "は開けませんでした。", button: "OK")
        }
        // 画面の再読み込み
        self.reloadSelfView()
    }
    /**
     * ブックマークの削除メソッド
     */
    @objc func deleteBookmark(_ sender: NSButton)
    {
        // 削除
        bookmarks.records.remove(at: sender.tag)
        // 保存
        if (BookmarkManager.saveBookmark(bookmarks: bookmarks) == false) {
            // エラーを出力
            self.error(message: Const.bookmarkName + "の削除に失敗しました。", button: "OK")
        }
        // 画面の再読み込み
        self.reloadSelfView()
    }
    /**
     * アクティブ時メソッド
     */
    public func appBecomeActive()
    {
        
    }
    
    // MARK: DelegateFunctoins
    
    
    
    // MARK: SettingFunctions
    
    /**
     * ビューをセットする
     */
    private func setSelfView()
    {
        // ブックマーク表示格納配列を初期化
        bookmarkViews = Array<[String : Any]>()
        // ブックマークを確認
        bookmarks = Json.loadBookmarkJsonFile(file: Const.bookmarkFile)!
        // 件数が存在している場合
        if (bookmarks.records.count > 0) {
            // レコード件数分繰り返し
            for (index, record) in bookmarks.records.enumerated() {
                // 実行日時表示ビュー生成
                let nameView = NSTextView()
                // テキストを追加
                nameView.insertText(record.name, replacementRange: NSRange(location: 0, length: 0))
                // 背景色を透明に指定
                nameView.backgroundColor = NSColor.clear
                // フォントサイズ指定
                nameView.font = NSFont.systemFont(ofSize: 10)
                // カラー指定
                nameView.textColor = NSColor.darkGray
                // 編集禁止
                nameView.isEditable = false
                // 表示を追加
                contentsView.addSubview(nameView)
                // パス表示ビュー生成
                let pathView = NSTextView()
                // テキストを追加
                pathView.insertText(record.input, replacementRange: NSRange(location: 0, length: 0))
                // 背景色を透明に指定
                pathView.backgroundColor = NSColor.clear
                // カラー指定
                pathView.textColor = NSColor.darkGray
                // 改行判定指定
                pathView.textContainer?.lineBreakMode = .byClipping
                // 行数指定
                pathView.textContainer?.maximumNumberOfLines = 1
                // 編集禁止
                pathView.isEditable = false
                // 表示を追加
                contentsView.addSubview(pathView)
                // Finderで開くボタン
                let open = NSButton()
                // イメージ設定
                open.image = NSImage(named: "open")
                // タグ指定
                open.tag = index
                // ターゲット指定
                open.target = self
                // アクション指定
                open.action = #selector(openBookmark(_:))
                // スタイル指定
                open.bezelStyle = .texturedSquare
                // 表示を追加
                contentsView.addSubview(open)
                // 削除ボタン
                let delete = NSButton()
                // イメージ設定
                delete.image = NSImage(named: "delete")
                // タグ指定
                delete.tag = index
                // ターゲット指定
                delete.target = self
                // アクション指定
                delete.action = #selector(deleteBookmark(_:))
                // スタイル指定
                delete.bezelStyle = .texturedSquare
                // 表示を追加
                contentsView.addSubview(delete)
                // ボーダー用のView
                let border = NSView()
                // 背景色を指定
                border.backgroundColor = NSColor.gray
                // 表示を追加
                contentsView.addSubview(border)
                // ブックマーク表示格納配列に追加
                bookmarkViews.append([
                    "name_view"     : nameView,
                    "path_view"     : pathView,
                    "border_view"   : border,
                    "open_button"   : open,
                    "delete_button" : delete
                    ])
            }
            // ドキュメントビュー指定
            clipView.documentView = contentsView
            // コンテンツ指定
            scrollView.contentView = clipView
            // 背景色の指定
            clipView.backgroundColor = NSColor.clear
            // 背景色の指定
            scrollView.drawsBackground = false
            scrollView.backgroundColor = NSColor.clear
            scrollView.documentView?.backgroundColor = NSColor.clear
            // 表示を追加
            self.addSubview(scrollView)
        }
        // 表示件数なし用のView
        nullView = NSTextView()
        // 文字追加
        nullView.insertText("※ " + Const.bookmarkName + "が保存されていません。", replacementRange: NSRange(location: 0, length: 0))
        nullView.backgroundColor = NSColor.clear
        
        nullView.alignment = .center
        // 表示を追加
        self.addSubview(nullView)
    }
    /**
     * ビューのフレームをセットする
     */
    public func setViewFrame(frame: CGRect)
    {
        // スペースサイズの取得
        let spaceSize = frame.size
        // 自身のサイズを指定
        self.frame = CGRect(x: 0, y: 0, width: spaceSize.width, height: spaceSize.height)
        // ブックマーク表示存在時
        if (bookmarkViews.count > 0) {
            // サイズ指定
            let lineHeight: CGFloat = 35
            let lineHarf = lineHeight / 2
            let buttonSideSize: CGFloat = 26
            let harfMargin = Const.margin / 2
            // コンテンツ高さ
            var contentsHeight:CGFloat = (lineHeight * CGFloat(bookmarkViews.count)) + Const.margin
            // フレームの方が大きい場合はフレームを指定
            contentsHeight = (spaceSize.height > contentsHeight) ? spaceSize.height : contentsHeight
            // 表示位置をセット
            scrollView.frame = CGRect(x: 0, y: 0, width: spaceSize.width, height: spaceSize.height)
            // コンテンツサイズを指定
            contentsView.frame = CGRect(x: 0, y: 0, width: spaceSize.width, height: contentsHeight)
            // 余白を追加
            contentsHeight -= Const.margin
            // 件数分繰り返し
            for views in bookmarkViews {
                // 表示位置を生成
                let viewY = contentsHeight - lineHeight
                // ビューを取得
                let open = views["open_button"] as! NSButton
                let delete = views["delete_button"] as! NSButton
                let nameView = views["name_view"] as! NSTextView
                let pathView = views["path_view"] as! NSTextView
                let borderView = views["border_view"] as! NSView
                // 画像サイズを指定
                open.image?.size = CGSize(width: buttonSideSize * 0.5, height: buttonSideSize * 0.5)
                delete.image?.size = CGSize(width: buttonSideSize * 0.5, height: buttonSideSize * 0.5)
                // 表示位置を指定
                open.frame = CGRect(x: spaceSize.width - (buttonSideSize * 2) - harfMargin, y: contentsHeight - buttonSideSize - 7, width: buttonSideSize, height: buttonSideSize)
                delete.frame = CGRect(x: spaceSize.width - buttonSideSize - harfMargin, y: contentsHeight - buttonSideSize - 7, width: buttonSideSize, height: buttonSideSize)
                
                // フレーム指定
                nameView.frame = CGRect(x: harfMargin, y: viewY + 7, width: open.frame.origin.x - harfMargin, height: lineHarf)
                // フレーム指定
                pathView.frame = CGRect(x: harfMargin, y: viewY - 2, width: open.frame.origin.x - harfMargin, height: lineHarf)
                // 表示位置を指定
                borderView.frame = CGRect(x: 0, y: contentsHeight - lineHeight, width: spaceSize.width, height: 1)
                // コンテンツ高さをインクリメント
                contentsHeight -= 30
            }
            // 表示位置を指定
            let viewPoint = NSPoint(x: 0, y: contentsView.frame.size.height)
            // セット
            scrollView.documentView?.scroll(viewPoint)
        } else {
            // 表示位置をセット
            nullView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 12)
            nullView.verticalAlign(size: frame.size, position: "middle")
        }
    }
    /**
     * 画面の再読み込み
     */
    public func reloadSelfView()
    {
        // サブビューを削除
        scrollView.removeFromSuperview()
        // ビューを取得
        for views in bookmarkViews {
            // ビューを取得
            let open = views["open_button"] as! NSButton
            let delete = views["delete_button"] as! NSButton
            let nameView = views["name_view"] as! NSTextView
            let pathView = views["path_view"] as! NSTextView
            let borderView = views["border_view"] as! NSView
            open.removeFromSuperview()
            delete.removeFromSuperview()
            nameView.removeFromSuperview()
            pathView.removeFromSuperview()
            borderView.removeFromSuperview()
        }
        nullView.removeFromSuperview()
        self.setSelfView()
        self.setViewFrame(frame: self.frame)
    }
}
