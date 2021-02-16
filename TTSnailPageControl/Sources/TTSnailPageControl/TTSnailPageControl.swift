import UIKit

public class SnailPageControl: UIView {
    
    var spacing:CGFloat { return configuration.spacing }
    var itemWidth:CGFloat { return configuration.itemSize.width }
    var itemHeight:CGFloat { return configuration.itemSize.height }
    var itemsCount:Int { return configuration.itemsCount }
    
    var layers:[CALayer] = []
    var currentSelectionLayer:CALayer!
    
    var lastContentOffset: CGPoint?
    private var observation:NSKeyValueObservation!
    
    var needsRedraw: Bool = true
    
    public var configuration: Configuration = Configuration() {
        didSet {
            self.needsRedraw = true
            self.invalidateIntrinsicContentSize()
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    
    public var fittingSize:CGSize {
        return CGSize.init(width: (itemWidth * (CGFloat(itemsCount) + 1)) + (CGFloat(itemsCount) * spacing) , height: itemHeight)
    }
    
    var selectionWidth:CGFloat {
        return itemWidth * 2 + spacing
    }
    
    weak public var scrollView: UIScrollView! {
        didSet {
            listenScrollView()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return fittingSize
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Init
    
    init(origin:CGPoint) {
        super.init(frame: CGRect.zero)
        self.frame = CGRect(origin: origin, size: fittingSize)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.frame.size = fittingSize
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Draw
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if needsRedraw {
            reconfigure()
            needsRedraw = false
        }
    }
    
    public override func setNeedsDisplay() {
        super.setNeedsDisplay()
    }
    
    private func listenScrollView() {
        guard let scrollView = self.scrollView else {
            return
        }
        self.observation = scrollView.observe(\.contentOffset, options: .new) { (scrollView, change) in
            if self.currentSelectionLayer != nil {
                self.lastContentOffset = change.newValue
                self.updateProgress()
            }
        }
    }
    
    //MARK: - Configuration
    
    func reconfigure() {
        self.layer.sublayers?.forEach({ $0.removeFromSuperlayer()})
        var contextPoint = CGPoint.zero
        for index in 0...itemsCount {
            let pageLayer = createLayer()
            configuration._layerConfiguration(pageLayer, index)
            pageLayer.frame.size = CGSize(width: itemWidth, height: itemHeight)
            pageLayer.frame.origin = CGPoint(x: contextPoint.x , y: contextPoint.y)
            self.layer.addSublayer(pageLayer)
            contextPoint.x += pageLayer.frame.size.width + spacing
        }
        currentSelectionLayer = createLayer()
        configuration._selectionLayerConfiguration(currentSelectionLayer)
        currentSelectionLayer.frame.size = CGSize(width: selectionWidth, height: itemHeight)
        currentSelectionLayer.frame.origin = CGPoint.zero
        self.layer.addSublayer(currentSelectionLayer)
        if self.lastContentOffset != nil {
            self.updateProgress()
        }
    }
    
    func createLayer() -> CALayer {
        let pageLayer = CALayer()
        pageLayer.backgroundColor = UIColor.gray.cgColor
        pageLayer.cornerRadius = 2.0
        pageLayer.masksToBounds = true
        return pageLayer
    }
    
    func updateProgress() {
        let globalProgress = scrollView.contentOffset.x / scrollView.frame.width
        let _localProgress = localProgress(in: scrollView)
        animate(progress: _localProgress, globalProgres: globalProgress)
    }
    
    func localProgress(in scrollView:UIScrollView) -> CGFloat {
        let width = scrollView.frame.width
        let contenOffset = scrollView.contentOffset.x
        let value = contenOffset.truncatingRemainder(dividingBy: width) / width
        return min(1,max(0,value))
    }
    
    func animate(progress:CGFloat, globalProgres:CGFloat) {
        let strechProgress = min(1,progress / 0.5)
        let reliefProgress = max(0,min(1,(progress - 0.5) / 0.5))
        if progress < 0.5 {
            currentSelectionLayer.frame.size.width = selectionWidth + strechProgress * (itemWidth + spacing)
            currentSelectionLayer.frame.origin.x = floor(globalProgres) * (itemWidth + spacing)
        } else {
            currentSelectionLayer.frame.size.width = selectionWidth + (1 - reliefProgress) * (itemWidth + spacing)
            let targePosition = floor(globalProgres) * (itemWidth + spacing)
            currentSelectionLayer.frame.origin.x = targePosition + (reliefProgress * (itemWidth + spacing))
        }
    }
}

extension SnailPageControl {
    public struct Configuration {
        public var spacing: CGFloat = 5.0
        public var itemSize: CGSize = CGSize(width: 8.0, height: 4.0)
        public var itemsCount: Int = 4
        
        var _layerConfiguration: (CALayer, Int) -> () = { _,_  in }
        var _selectionLayerConfiguration: (CALayer) -> () = { _ in }
        
        mutating public func layerConfiguration(_ callback:@escaping (CALayer, Int) -> ()) {
            self._layerConfiguration = callback
        }
        
        mutating public func selectionLayerConfiguration(_ callback:@escaping (CALayer) -> ()) {
            self._selectionLayerConfiguration = callback
        }
    }
}

