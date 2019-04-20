//
//  NSView.swift
//  WInPath
//
//  Created by Apple on 2018/11/10.
//  Copyright © 2018年 Kazumi Watanabe. All rights reserved.
//

import Cocoa

extension NSView {

    /**
     * 背景色をセットする
     */
    @IBInspectable var backgroundColor: NSColor? {
        get {
            guard let layer = layer, let backgroundColor = layer.backgroundColor else {return nil}
            return NSColor(cgColor: backgroundColor)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    /**
     * サブビューを削除する
     */
    public func removeSubviews()
    {
        // サブビュー分繰り返し
        for view in self.subviews {
            // サブビューの破棄
            view.removeFromSuperview()
        }
    }
    /**
     * エラーアラートを表示する
     */
    public func error(message: String, button: String)
    {
        let alert = NSAlert()
        alert.messageText = "Error!!";
        alert.informativeText = message;
        alert.addButton(withTitle: button)
        alert.runModal()
    }
    /**
     * 表示領域に対して左右中央寄せにする
     */
    public func aliginCenter(wrapWidth: CGFloat, y: CGFloat)
    {
        let x = (wrapWidth / 2) - (self.frame.size.width / 2)
        self.frame.origin = CGPoint(x: x, y: y)
    }
    /**
     * 表示領域を変えず左に余白を入れる
     */
    public func insertMarginLeft(margin: CGFloat)
    {
        self.frame = CGRect(x: self.frame.origin.x + margin, y: self.frame.origin.y, width: self.frame.size.width - margin, height: self.frame.size.height)
    }
    /**
     * 表示領域を変えず右に余白を入れる
     */
    public func insertMarginRight(margin: CGFloat)
    {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width - margin, height: self.frame.size.height)
    }
    /**
     * 対象の右に配置する
     */
    public func positionedRight(target: CGRect, margin: CGFloat)
    {
        self.frame.origin = CGPoint(x: target.origin.x + target.size.width + margin, y: target.origin.y)
    }
}
