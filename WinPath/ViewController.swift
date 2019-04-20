//
//  ViewController.swift
//  WinPath
//
//  Created by Apple on 2018/11/10.
//  Copyright © 2018 Kazumi Watanabe. All rights reserved.
//
import Cocoa

class ViewController: NSViewController, NSTabViewDelegate {
    
    // MARK: GlobalVariables
    
    enum ACTIVE_MODE {
        case PATH
        case BOOKMARK
        case HISTORY
    }
    
    let menuTabs = NSTabView()
    let workspace = NSView()
    var activeMode: ACTIVE_MODE = .PATH
    var pathView:PathView!
    var bookmarkView:BookmarkView!
    var historyView:HistoryView!
    
    // MARK: ApplicationEvents
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PathManager.configure()
        self.setNotification()
        self.setSelfView()
        self.setMode(mode: .PATH)
        self.setViewFrame()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    /**
     * アプリケーションアクティブ時
     */
    @objc func appBecomeActive()
    {
        // モード判定
        switch self.activeMode {
        case .BOOKMARK:
            // アクティブメソッド
            bookmarkView.appBecomeActive()
            break;
        case .HISTORY:
            // アクティブメソッド
            historyView.appBecomeActive()
            break;
        default:
            // アクティブメソッド
            pathView.appBecomeActive()
            break;
        }
    }
    /**
     * ウィンドウリサイズ時
     */
    @objc func windowResized()
    {
        self.setViewFrame()
    }
    
    // MARK: DelegateFunctions
    
    @objc func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?)
    {
        // テキストを取得
        let text = tabViewItem?.label ?? ""
        // 判定
        switch text {
        case Const.bookmarkMenu:
            self.setMode(mode: .BOOKMARK)
            break;
        case Const.historyMenu:
            self.setMode(mode: .HISTORY)
            break;
        default:
            self.setMode(mode: .PATH)
            break;
        }
    }
    
    
    // MARK: SettingFunctions
    
    /**
     * アクティブなモードを変更する
     */
    private func setMode(mode: ACTIVE_MODE)
    {
        // モードを更新
        self.activeMode = mode
        // フレーム取得
        let frame = workspace.frame
        // サブビューを削除
        workspace.removeSubviews()
        // モード判定
        switch self.activeMode {
        case .BOOKMARK:
            // view生成
            bookmarkView = BookmarkView(frame: frame)
            // ワークスペースに追加
            workspace.addSubview(bookmarkView)
            break;
        case .HISTORY:
            // view生成
            historyView = HistoryView(frame: frame)
            // ワークスペースに追加
            workspace.addSubview(historyView)
            break;
        default:
            // view生成
            pathView = PathView(frame: frame)
            // ワークスペースに追加
            workspace.addSubview(pathView)
            break;
        }
        
    }
    /**
     * ビューをセットする
     */
    private func setSelfView()
    {
        // パス変換タブ
        let tabConvert = NSTabViewItem()
        // テキスト指定
        tabConvert.label = Const.pathMenu
        // アイテムを追加
        menuTabs.addTabViewItem(tabConvert)
        
        // パス変換タブ
        let tabBookmark = NSTabViewItem()
        // テキスト指定
        tabBookmark.label = Const.bookmarkMenu
        // アイテムを追加
        menuTabs.addTabViewItem(tabBookmark)
        
        // パス変換タブ
        let tabHistory = NSTabViewItem()
        // テキスト指定
        tabHistory.label = Const.historyMenu
        // アイテムを追加
        menuTabs.addTabViewItem(tabHistory)
 
        // デリゲート指定
        menuTabs.delegate = self
        // サブビュー指定
        menuTabs.addSubview(workspace)
        // ビューを追加
        self.view.addSubview(menuTabs)
    }
    /**
     * ビューのフレームをセットする
     */
    private func setViewFrame()
    {
        //ウィンドウ取得
        let window = NSApplication.shared.windows.first
        // ウィンドウサイズを取得
        let windowWidth = window?.frame.size.width ?? self.view.frame.size.width
        let windowHeight = window?.frame.size.height ?? self.view.frame.size.height
        // サイズ指定
        menuTabs.frame.size = CGSize(width: windowWidth * 0.98, height: windowHeight * 0.9)
        // 表示位置指定
        menuTabs.frame.origin = CGPoint(x: (windowWidth * 0.02) / 2, y: (windowHeight * 0.02) / 2)
        // ワークスペースのViewサイズ指定
        workspace.frame.size = CGSize(width: menuTabs.frame.size.width * 0.95, height: menuTabs.frame.size.height * 0.8)
        workspace.frame.origin = CGPoint(x: (menuTabs.frame.size.width * 0.05) / 2, y: (menuTabs.frame.size.height * 0.25) / 2)
        // モード判定
        switch self.activeMode {
        case .BOOKMARK:
            bookmarkView.setViewFrame(frame: workspace.frame)
            break;
        case .HISTORY:
            historyView.setViewFrame(frame: workspace.frame)
            break;
        default:
            pathView.setViewFrame(frame: workspace.frame)
            break;
        }
    }
    /**
     * イベント通知を設定する
     */
    private func setNotification()
    {
        // アプリケーションアクティブ時
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appBecomeActive),
            name:NSApplication.didBecomeActiveNotification,
            object: nil)
        // ウィンドウリサイズ時
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowResized),
            name: NSWindow.didResizeNotification,
            object: nil)
    }
    
}

