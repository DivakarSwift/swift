//
//  RAC.swift
//  demo
//
//  Created by lin on 09/11/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import UIKit
import CessCore
import CessUtil
import ReactiveSwift
import ReactiveCocoa
import CessRac

//public func <~ <Value>(target: CocoaAction<Value>, action: (()->())) {

//public class LinCocoaAction<Sender> : CocoaAction<Sender>{
////    private func addExecuteOverlayImpl(view:UIView,message:String = "正在加载数据...",errorMessage e:String!,showError:Bool){
////        
////        var progressView:MRProgressOverlayView? = MRProgressOverlayView();
////        let s = self.executionListener;
////        
////        s.subscribeNext { (v) in
////            if v is Int{
////                let code = v as! Int;
////                if code == 1 {
////                    progressView? = MRProgressOverlayView();
////                    progressView?.mode = MRProgressOverlayViewMode.IndeterminateSmallDefault;
////                    progressView?.titleLabelText = message;
////                    view.addSubview(progressView!);
////                    progressView?.show(true);
////                }else  if code == 2 {
////                    progressView?.dismiss(true);
////                }
////            }else if showError {
////                progressView?.dismiss(true);
////                if let e = e {
////                    AlertView.show(e);
////                }else if v is NSError{
////                    let error = v as! NSError;
////                    AlertView.show(error.toHttpErrorString())
////                }
////            }
////        }
////    }
//}

//extension NSString : Equatable{
//    public static func ==(lhs: NSString, rhs: NSString) -> Bool{
//        return lhs.isEqual(to: rhs as String)
//    }
//}
public class RACViewController2 : UIViewController,BaseView{
    
    private lazy var vm:RACVM = {
        var _vm = RACVM();
        _vm.view = self;
        return _vm;
    }();
    
    @IBOutlet var button:UIButton?;
    @IBOutlet var label:UILabel?;
    @IBOutlet var text:UITextField?;
    
//    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.initFromXIB();
//    }
    
//    public override func loadView() {
//        let bundle = Bundle(for: RACViewController2.self)
//        
//        let nib = UINib(nibName: "RACViewController2", bundle: bundle)
//        
//        let contView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
//        
////        contView.frame = self.view.bounds
//        
//        self.view = contView;
//    }
//    func initFromXIB() {
////        
//        let bundle = Bundle(for: self.classForCoder)
////
//        let nib = UINib(nibName: "RACViewController2", bundle: bundle)
////
//        let contView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
////
////        contView.frame = self.view.bounds
//        
////        self.view.addSubview(contView)
//        
//    }
   
    public override func viewDidLoad() {
        
        var arr:[NSString] = ["a","b","c"]
        print(arr);
        
        var ext = arr.ext.remove("b")
        print(arr)
        
        
//        let s:NSString
        //arr.ext.
//        self.initFromXIB();
        self.ext.initFromXIB("RACViewController2");
        vm.start();
//        let a = Action.init { (a) -> SignalProducer<_;, _> in
//            return SignalProducer<(),NSError>.init(value: ());
//        }
//        Action.init(<#T##execute: (Input) -> SignalProducer<Output, Error>##(Input) -> SignalProducer<Output, Error>#>)
//        let action = CocoaAction.init(Action.init { () -> SignalProducer<Void, NSError> in
//            
//        });
//        let a = Action<(), (), NSError>.init { () -> SignalProducer<(), NSError> in
//            print("===");
//            return SignalProducer.init(value: ());
//        }
//        let action = CocoaAction<UIButton>.init(a)
//        a.events.observe(){event in
//            switch event {
//            case let .value(results):
//            print("Search results: \(self.vm.text)")
//                
//            
////            case let .error(error):
////            print("Search error: \(error)")
//            
//            case .completed, .interrupted:
//            break
//            default:
//                break;
//            }
//        }
////        button?.pressed = action;
////        button.pressed
////        button?.press
//        button?.reactive.pressed = action;
//        button?.reactive.pressed = vm.action(action: vm.test);
//        let (signal,observer) = Signal<Bool,NoError>.pipe();
//        button!.reactive.isEnabled <~ SignalProducer(signal:signal);
//        observer.send(value: false);
        
        
//        button <~ vm.test;
        
//        button?.reactive.pressed = CocoaAction.(action: { (v, action) in
//            
//        }, inputTransform: { (base) -> Int in
//            return 1;
//        })
//        button?.tag = Int(arc4random());
        button?.reactive.pressed = CocoaAction<UIButton>.from(action: vm.test){ (button) -> Int in
            return Int(arc4random());
        }
//        button <~ vm.test
        button?.reactive.pressed?.addOverlay(self);
//        button?.reactive.pressed?.isEnabled2
        
//        button?.reactive.trigger(for: UIControlEvents.touchUpOutside).signal.observe({value in
//            print(value);
//            print("======")
//        })
        //        button?.reactive.trigger(for: UIControlEvents.touchUpOutside) <~ vm.test2
        
//        button!.reactive.touchUpOutside = vm.bind.action(action: vm.test2);
        //button!.reactive.touchUpOutside = ~vm.test2;
        
//        button!.reactive.touchUpOutside = vm.bind.action(action: vm.test2);
        
        //CocoaAction<Base>
        
//        self.bind();
        
//        text!.reactive.text <~ vm.bind.producer(keyPath: "text");
        //text!.reactive.text <~ vm.bind.property(keyPath: "text");
//        label!.reactive.text <~ vm.bind.property(keyPath: "text");
        
//        vm.bind.target(keyPath: "text") <~ text!.reactive.textValues;
        //vm.bind.target(keyPath: "text") <~ text!.reactive.continuousTextValues;
//        vm.bind.bind(signal: text!.reactive.textValues, keyPath: "text");
//        vm.bind.set(keyPath: "text", ofSignal: text?.reactive.textValues);
    }
    
    private func bind(){
//        text?.reactive.continuousTextValues
//        button?.reactive.trigger(for: <#T##UIControlEvents#>)
//        text?.reactive.text.lifetime.
//        let a:BindingTarget?? = nil;
//        vm.reactive.values(forKeyPath: "text") <~ label?.reactive.text;
//        let t = label!.reactive.text;
//        let s = vm.reactive.values(forKeyPath: "text");
//        let (pipeSignal, observer) = Signal<String, NoError>.pipe()
//        button!.reactive.title <~ SignalProducer(signal: pipeSignal)
//        
//        observer.send(value: "ok");
//        let s:DynamicProperty<String> = DynamicProperty.init(object: vm, keyPath: "text");
//        
//        text!.reactive.text <~ s.producer;
//        
//        
//        let b = BindingTarget<String?>(on: UIScheduler(), lifetime: vm.reactive.lifetime) { value in
////            if let base = base {
////                action(base, value)
////            }
////            self.vm.text = value ?? "";
//            //self.vm.setValue(value, forKey: "text");
//        }
//        
//        let ss = text!.reactive.textValues;
//        b <~ ss;
        
//        s.take(during: t.lifetime)
//            .observeValues {value in
////                setter(value)
//                
//        }
        text?.reactive.continuousTextValues.observe(){event in
            switch event{
            case let .value(v):
                print(v);
            default:
                break;
            }
        }
    }
    
    
//    @discardableResult
//    public static func <~ <Source: CocoaAction<Value>>(target: Self, producer: Source) -> Disposable where Source.Value == Value, Source.Error == NoError {
//        var disposable: Disposable!
//        
//        producer
//            .take(during: target.lifetime)
//            .startWithSignal { signal, signalDisposable in
//                disposable = signalDisposable
//                target <~ signal
//        }
//        
//        return disposable
//    }
    deinit {
        print("deinit...");
    }
}
