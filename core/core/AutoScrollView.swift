//
//  AutoScrollView.swift
//  puer
//
//  Created by lin on 13/02/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation
import LinCore
import LinUtil


public class AutoScrollView : UIScrollView{
    fileprivate var views = [UIView]();
    
    public enum Dir{
        case Vertical
        case Horizontal
    }
    public var dir = Dir.Vertical;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        Queue.asynThread(self.thread);
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func addSubview(_ view: UIView) {
        super.addSubview(view);
        views.append(view);
    }
    
    private func size()-> CGRect {
        var rect:CGRect!;
        var scount = 0;
        //        if self.showsHorizontalScrollIndicator {
        //            scount += 2;
        //        }
        //        if self.showsVerticalScrollIndicator {
        //            scount += 2;
        //        }
        for n in 0 ..< self.views.count - scount {
            let view = self.views[n];
            if view.isHidden {
                continue;
            }
            let srect = view.convert(view.bounds, to: self);
            
            if rect == nil {
                rect = srect;
            }else{
                rect = mergeRect(srect,rect2: rect);
            }
        }
        if rect == nil {
            return CGRect(x: 0, y: 0, width: 0, height: 0);
        }
        return rect;
    }
    
    private func mergeRect(_ rect1:CGRect,rect2:CGRect)->CGRect{
        var result = CGRect(x: 0, y: 0, width: 0, height: 0);
        result.origin.x = rect1.origin.x > rect2.origin.x ? rect2.origin.x : rect1.origin.x;
        
        result.origin.y = rect1.origin.y > rect2.origin.y ? rect2.origin.y : rect1.origin.y;
        
        var maxX = rect2.width + rect2.origin.x;
        if maxX < rect1.width + rect1.origin.x {
            maxX = rect1.width + rect1.origin.x
        }
        
        result.size.width = maxX - result.origin.x;
        
        var maxY = rect2.height + rect2.origin.y;
        if maxY < rect1.height + rect1.origin.y {
            maxY = rect1.height + rect1.origin.y
        }
        
        result.size.height = maxY - result.origin.y;
        
        return result;
    }
    
    private var run = true;
    private func thread(){
        while(run){
            Thread.sleep(forTimeInterval: 0.6);
            if(isHidden){
                continue;
            }
            self.resetContentSize();
            //            Queue.mainQueue(self.resetContentSize);
        }
    }
    
    deinit {
        run = false;
    }
    
    private func resetContentSize(){
        var rect = self.size();
        
        let bounds = self.bounds;
        
        if dir == Dir.Vertical{
            if rect.height <= self.bounds.height + 1 {
                rect.size.height = bounds.height + 1;
            }
            rect.size.width = bounds.width;
        }else{
            if rect.width <= self.bounds.width + 1 {
                rect.size.width = bounds.width + 1;
            }
            rect.size.height = bounds.height;
        }
        
        self.contentSize = rect.size;
    }
}
