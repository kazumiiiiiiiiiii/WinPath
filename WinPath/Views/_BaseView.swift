//
//  _BaseView.swift
//  WinPath
//
//  Created by Apple on 2018/11/11.
//  Copyright © 2018 Kazumi Watanabe. All rights reserved.
//

import Cocoa

class _BaseView: NSView {

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
        
    }
    
    // MARK: DelegateFunctoins
    
    
    
    // MARK: SettingFunctions
    
    /**
     * ビューをセットする
     */
    private func setSelfView()
    {
        
    }
    /**
     * ビューのフレームをセットする
     */
    public func setViewFrame(frame: CGRect)
    {
        
    }
    
}
