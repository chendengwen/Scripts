

// Playground - noun: a place where people can play


import Cocoa
import QuartzCore
import XCPlayground
import PlaygroundSupport


class PlaygroundIconView:NSView {  // <CALayerDelegate>
    
    let backgroundLayer=CAShapeLayer()
    
    let seesawBaseLayer=CAShapeLayer()
    
    let seesawLayer=CAShapeLayer()
    
    
    
    init(){
        
        super.init(frame:NSRect(x:0,y:0,width:568,height:568))
        
        
        
        backgroundLayer.frame=self.bounds
        
        seesawBaseLayer.frame=NSRect(x:254,y:124,width:60,height:111)
        
        seesawLayer.frame=NSRect(x:40,y:197, width:488,height:30)
        
        
        setUpBackgroundLayer()
        
        setUpSeesawBaseLayer()
        
        setUpSeesawLayer()
        
        
        self.wantsLayer=true
        
        self.layer?.addSublayer(backgroundLayer)
        
        self.layer?.addSublayer(seesawBaseLayer)
        
        self.layer?.addSublayer(seesawLayer)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUpBackgroundLayer(){
        
        let lineWidth = 9.0
        
        let backgroundPath=NSBezierPath(roundedRect:NSInsetRect(bounds, CGFloat(lineWidth)/2.0, CGFloat(lineWidth)/2.0), xRadius:35.0, yRadius:35.0)
        
        backgroundPath.lineWidth=CGFloat(lineWidth)
        
        
        backgroundLayer.strokeColor=NSColor.playgroundIconStrokeColor().cgColor
        
        backgroundLayer.fillColor=NSColor.playgroundIconFillColoer().cgColor
        
        backgroundLayer.lineWidth=CGFloat(lineWidth)
        
        backgroundLayer.path=CGPathFromNSBezierPath(nsPath: backgroundPath)
        
    }
    
    
    
    func setUpSeesawBaseLayer(){
        
        let seesawBasePath=NSBezierPath()
        
        let rectHeight:Int=50;
        
        
        seesawBasePath.move(to: NSPoint(x:0,y:rectHeight))
        
        seesawBasePath.line(to: NSPoint(x:seesawBaseLayer.bounds.width/2,y:seesawBaseLayer.bounds.height))
        
        seesawBasePath.line(to: NSPoint(x:seesawBaseLayer.bounds.width,y:50))
        

        seesawBaseLayer.fillColor=NSColor.white.cgColor
        
        seesawBaseLayer.path=CGPathFromNSBezierPath(nsPath: seesawBasePath)
        
    }
    
    
    
    func setUpSeesawLayer(){
        
        let createChildLayer:()->CAShapeLayer={
            
            let childLayer=CAShapeLayer()
            
            let headPath=NSBezierPath(ovalIn:NSRect(x:60,y:150,width:49,height:49))
            
            let bodyPath=NSBezierPath()
            
            bodyPath.move(to: NSPoint(x:58,y:155))
            
            bodyPath.line(to: NSPoint(x:88,y:140))
            
            bodyPath.line(to: NSPoint(x:126,y:100))
            
            bodyPath.line(to: NSPoint(x:120,y:90))
            
            bodyPath.line(to: NSPoint(x:125,y:71))
            
            bodyPath.line(to: NSPoint(x:113,y:71))
            
            bodyPath.line(to: NSPoint(x:112,y:94))
            
            bodyPath.line(to: NSPoint(x:83,y:113))
            
            bodyPath.line(to: NSPoint(x:68,y:94))
            
            bodyPath.line(to: NSPoint(x:97,y:70))
            
            bodyPath.line(to: NSPoint(x:122,y:12))
            
            bodyPath.line(to: NSPoint(x:98,y:0))
            
            bodyPath.line(to: NSPoint(x:64,y:41))
            
            bodyPath.line(to: NSPoint(x:7,y:71))
            
            bodyPath.line(to: NSPoint(x:0,y:94))
            
            bodyPath.move(to: NSPoint(x:58,y:155))
            
            
            let childPath=NSBezierPath()
            
            childPath.append(headPath)
            
            childPath.append(bodyPath)
            
            childLayer.fillColor=NSColor.white.cgColor
            
            childLayer.path=CGPathFromNSBezierPath(nsPath: childPath)
            
            
            return childLayer
            
        }
        
        
        
        
        
        let leftChildLayer = createChildLayer()
        
        let rightChildLayer = createChildLayer()
        
        rightChildLayer.transform=CATransform3DMakeRotation(CGFloat(M_PI),0.0,0.0,1.0)
        
        rightChildLayer.isGeometryFlipped=true
        
        
        
        let benchLayer = CALayer()
        
        benchLayer.frame=NSRect(x:0,y:41,width:self.seesawLayer.bounds.width,height:30)
        
        benchLayer.backgroundColor=NSColor.white.cgColor
        
        
        leftChildLayer.frame=NSRect(x:25,y:0,width:126,height:200)
        
        rightChildLayer.frame=NSRect(x:488-(126+25),y:0,width:126,height:200)

        seesawLayer.addSublayer(leftChildLayer)
        
        seesawLayer.addSublayer(rightChildLayer)
        
        seesawLayer.addSublayer(benchLayer)
        
        
        seesawLayer.delegate = self
        
    }
    
    
    
    let maxSeesawAngle=M_PI / 12
    
    var currentSeesawAngle = 0.0
    
    var animate:Bool = false{
    
    
        didSet(oldAnimate){
            
            if animate != oldAnimate && animate {
                
                if currentSeesawAngle == 0  {
                    
                    //@Bailey
                    
                    // 设置捕捉动态记录和显示的参数
                    
                    XCPCaptureValue(identifier: "Left Seesaw Position",value: 0 )
                    
                    animateSeesawToAngle(angle: CGFloat(maxSeesawAngle),duration: 0.75)
                    
                }
                    
                else
                    
                {
                    
                    animateSeesawToAngle(angle: CGFloat(currentSeesawAngle) * -1.0)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    func animateSeesawToAngle(angle:CGFloat,duration:CFTimeInterval = 1.5 )-> CAAnimation{
        
        let angleAnimation = CABasicAnimation(keyPath:"transform")
        
        angleAnimation.fromValue=NSValue(caTransform3D:seesawLayer.transform)
        
        angleAnimation.toValue=NSValue(caTransform3D:CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0))
        
        angleAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        angleAnimation.duration = duration
        
        angleAnimation.delegate = self
        
        seesawLayer.add(angleAnimation, forKey: "transform")
        
        seesawLayer.transform=CATransform3DMakeRotation(angle,0.0, 0.0, 1.0)
        
        currentSeesawAngle=Double(angle)
        
        return angleAnimation
        
    }
    
}


extension PlaygroundIconView:CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        
        if flag && animate {
            
            //@Bailey
            
            // 设置捕捉动态记录和显示的参数
            
            XCPCaptureValue(identifier: "Left Seesaw Position",value: -currentSeesawAngle )
            
            animateSeesawToAngle(angle: CGFloat(currentSeesawAngle) * -1)
            
        }
        
    }
}


extension PlaygroundIconView:CALayerDelegate {

}

extension NSColor {
    
    class func playgroundIconFillColoer()->NSColor{
        
        return NSColor(red:12/255,green:65/255,blue:135/255,alpha:1.0)
        
    }
    
    class func playgroundIconStrokeColor()->NSColor{
        
        return NSColor(red:9/255,green:44/255,blue:91/255,alpha:1.0)
        
    }
    
}

func CGPathFromNSBezierPath(nsPath:NSBezierPath)->CGPath! {
    
    if nsPath.elementCount==0{
        return nil
    }
    
    
    let path=CGMutablePath()
    
    var didClosePath=false
    
    for i in 0 ..< nsPath.elementCount{
        
        var points=[NSPoint](repeating:NSZeroPoint,count:3)
        
        
        switch nsPath.element(at: i, associatedPoints: &points){
            
        case .moveToBezierPathElement:
            
//            CGPathMoveToPoint(path,nil,points[0].x,points[0].y)
            path.move(to: CGPoint.init(x: points[0].x, y: points[0].y))
            
            
        case .lineToBezierPathElement:
            
//            CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
            path.addLine(to: CGPoint.init(x: points[0].x, y: points[0].y))
            
            
        case .curveToBezierPathElement:
            
//            CGPathAddCurveToPoint(path,nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
            path.addCurve(to: CGPoint.init(x: points[0].x, y: points[0].y), control1: CGPoint.init(x: points[1].x, y: points[1].y), control2: CGPoint.init(x: points[2].x, y: points[2].y))
            
        case .closePathBezierPathElement:
            
            path.closeSubpath()
            
            didClosePath=true
            
        }
        
    }
    
    if !didClosePath{
        
        path.closeSubpath()
        
    }
    
    return path.copy()
    
}

let view=PlaygroundIconView()

view.animate=true

//@Bailey

//显示游乐场跷跷板动态图标以及时间轴用于程序计算回溯

XCPShowView(identifier: "20140605",view: view)
//PlaygroundPage.current.liveView

view
