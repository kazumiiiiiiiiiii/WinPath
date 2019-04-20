//
//  PathView.swift
//  WInPath
//
//  Created by Apple on 2018/11/10.
//  Copyright © 2018年 Kazumi Watanabe. All rights reserved.
//

import Cocoa

class PathView: NSView, NSTextFieldDelegate {
    
    // MARK: GlobalVariables
    
    var winPath = NSTextField()
    var openPath = NSTextField()
    var open = NSButton()
    var bookmark = NSButton()
    var select = NSPopUpButton()
    
    var defaultFrame: CGRect!
    
    // MARK: InitFunctions
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setSelfView()
        self.setViewFrame(frame: frameRect)
        self.appBecomeActive()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    // MARK: ApplicationEvenets
    
    /**
     * アクティブ時メソッド
     */
    public func appBecomeActive()
    {
        winPath.becomeFirstResponder()
    }
    
    // MARK: DelegateFunctoins
    
    /**
     * ファインダーを開く
     */
    @objc func controlTextDidChange(_ obj: Notification)
    {
        // テキストフィールドの取得
        let tf:NSTextField = obj.object as! NSTextField
        // テキスト一時格納
        var text = "";
        // タグがウィンドウズの場合
        if (tf.tag == 1) {
            // 変換
            text = PathManager.convertToMac(path: tf.stringValue)
            // 変換テキストをセット
            openPath.stringValue = text
            // 変換
            text = PathManager.convertToWin(path: text)
            // Winテキストをセット
            winPath.stringValue = text
        } else {
            // 変換
            text = PathManager.convertToWin(path: tf.stringValue)
            // Winテキストをセット
            winPath.stringValue = text
            // 変換
            text = PathManager.convertToMac(path: text)
            // Winテキストをセット
            openPath.stringValue = text
        }
        // フレーム変更（デフォルトフレームで更新）
        self.setViewFrame(frame: defaultFrame)
        // ボタンの状態指定
        open.isEnabled = (text.count > 0)
        bookmark.isEnabled = open.isEnabled
    }
    /**
     * 入力コマンドのイベント発火時
     */
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool
    {
        // 実行されたコマンドが文字確定でないEnterの場合
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // 開くボタンが有効状態の場合はじFinderを開く
            if (open.isEnabled) { self.openFinder() }
            // ハンドル通知
            return true
        }
        // return true if the action was handled; otherwise false
        return false
    }
    
    // MARK: ActionFunctions
    
    /**
     * ファインダーを開く
     */
    @objc func openFinder()
    {
        // 設定値を取得
        let config = PathManager.openPath(path: openPath.stringValue, select: select.titleOfSelectedItem!)
        // パスを開く
        if (PathManager.open(type: config.type, open: config.open, input: config.input)) {
            
            // 履歴を登録
            if (PathManager.addHistory(type: config.type, open: config.open, input: config.input) == false) {
                // エラーを出力
                self.error(message: Const.historyName + "の保存に失敗しました", button: "OK")
            }
            
        } else {
            // エラーを出力
            self.error(message: "ご指定の" + Const.pathName + "は開けませんでした。", button: "OK")
        }
        
    }
    /**
     * ブックマーク追加
     */
    @objc func addBookmark()
    {
        // ブックマーク処理が可能な場合
        if (bookmark.isEnabled) {
            // アラート生成
            let bookmarkAlert = NSAlert()
            // アラートスタイル指定
            bookmarkAlert.alertStyle = .informational
            // メッセージ設定
            bookmarkAlert.messageText = Const.bookmarkName + "の保存名を入力してください。"
            // ブックマーク名のテキスト
            let bookmarkName = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 20))
            // プレースフォルダー
            bookmarkName.placeholderString = Const.bookmarkName + "名";
            // アクセサリーに指定
            bookmarkAlert.accessoryView = bookmarkName
            // 登録
            bookmarkAlert.addButton(withTitle: "登録")
            // キャンセル
            bookmarkAlert.addButton(withTitle: "キャンセル")
            // ブックマークアラート表示
            let res = bookmarkAlert.runModal()
            bookmarkAlert.accessoryView?.becomeFirstResponder()
            // レスポンス判定
            if res == NSApplication.ModalResponse.alertFirstButtonReturn { // OK
                // ブックマーク名を取得
                let name = (bookmarkAlert.accessoryView as! NSTextField).stringValue
                // ブックマーク名を確認
                if (name.count > 0) { // 指定時
                    // 設定値を取得
                    let config = PathManager.openPath(path: openPath.stringValue, select: select.titleOfSelectedItem!)
                    // ブックマークを登録
                    if (BookmarkManager.addBookmark(name: name, type: config.type, open: config.open, input: config.input) == false) {
                        // エラーを出力
                        self.error(message: Const.bookmarkName + "に失敗しました。", button: "OK")
                    }
                    // ブックマーク追加
                    
                } else {
                    // 未指定時はエラー
                    self.error(message: Const.bookmarkName + "の保存名が入力されていません。", button: "閉じる")
                }
            }
        }
    }
    
    // MARK: SettingFunctions
    
    /**
     * ビューをセットする
     */
    private func setSelfView()
    {
        // Delegate を設定
        winPath.delegate = self
        // プレースホルダー
        winPath.placeholderString = "Windowsのパスを入力"
        // 背景色
        //winPath.backgroundColor = NSColor.white
        // タグをセット
        winPath.tag = 1;
        // 画面に追加
        self.addSubview(winPath)
        // Delegate を設定
        openPath.delegate = self
        // プレースホルダー
        openPath.placeholderString = "Macのパスを入力"
        // 背景色
        //openPath.backgroundColor = NSColor.white
        // タグをセット
        openPath.tag = 2;
        // 画面に追加
        self.addSubview(openPath)
        // 画像をセット
        bookmark.title = "+"
        // フォント指定
        bookmark.font = NSFont.systemFont(ofSize: 20.0)
        // アクション指定
        bookmark.action = #selector(addBookmark)
        // スタイル指定
        bookmark.bezelStyle = .texturedSquare
        // 無効状態
        bookmark.isEnabled = false
        // 追加
        self.addSubview(bookmark)
        // アイテムを追加
        select.addItems(withTitles: ["smb:", "afp:"])
        // タイトル指定
        open.title = "Finderで開く"
        // アクション指定
        open.action = #selector(openFinder)
        // スタイル指定
        open.bezelStyle = .texturedSquare
        // 無効状態
        open.isEnabled = false
        // 画面に追加
        self.addSubview(open)
    }
    /**
     * ビューのフレームをセットする
     */
    public func setViewFrame(frame: CGRect)
    {
        // スペースサイズの取得
        let spaceSize = frame.size
        var height: CGFloat = spaceSize.height
        // 現在高さ
        height -= Const.margin
        // 自身のサイズを指定
        self.frame = CGRect(x: 0, y: 0, width: spaceSize.width, height: spaceSize.height)
        // 固定幅
        let width9 = spaceSize.width * 0.9
        
        // Windowsパス
        winPath.frame.size = CGSize(width: width9, height: spaceSize.height * 0.3)
        height -= winPath.frame.size.height
        winPath.alignCenter(wrapWidth: spaceSize.width, y: height)
        height -= Const.margin
        
        // 開くパス
        openPath.frame.size = CGSize(width: width9, height: spaceSize.height * 0.3)
        height -= openPath.frame.size.height
        openPath.alignCenter(wrapWidth: spaceSize.width, y: height)
        height -= Const.margin
        
        // ボタンサイズ
        open.frame.size = CGSize(width: 250, height: 30)
        height -= open.frame.size.height
        open.alignCenter(wrapWidth: spaceSize.width, y: height)
        
        bookmark.image?.size = CGSize(width: 15, height: 15)
        // ブックマークボタン
        bookmark.frame.size = CGSize(width: 30, height: 30)
        open.insertMarginRight(margin: bookmark.frame.size.width + Const.margin)
        bookmark.positionedRight(target: open.frame, margin: Const.margin)
        
        // パスを確認
        if (openPath.stringValue.hasPrefix("//")) {
            // 画面に追加
            self.addSubview(select)
            // オープンパス入力画面の表示位置を取得
            let origin = openPath.frame.origin
            // 左側に余白を追加
            openPath.insertMarginLeft(margin: Const.margin + 90)
            // 表示位置とサイズを指定
            select.frame.size = CGSize(width: 90, height: 24)
            select.frame.origin = CGPoint(x: origin.x, y: origin.y + openPath.frame.size.height - select.frame.size.height)
        } else {
            // 削除
            select.removeFromSuperview()
        }
        // フレームの更新
        self.defaultFrame = frame
    }
    
}
