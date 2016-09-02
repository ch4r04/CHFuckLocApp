//
//  CHGoViewController.m
//  CHFuckLocApp
//
//  Created by hya on 16/8/29.
//  Copyright © 2016年 ch4r0n. All rights reserved.
//
// Baidu key:K3TiCdQeYmrPDX5syKmHm1NBasHSOWm8

#import "CHGoViewController.h"
#import "LocModel.h"
#import "MyAnnotation.h"
#import "UIScrollView+CHTouch.h"
#import "AMViralSwitch.h"
#import <CoreLocation/CoreLocation.h>
#import "CHButton.h"
#import <MapKit/MapKit.h>
#import <dlfcn.h>
#define k_w [UIScreen mainScreen].bounds.size.width
#define k_h [UIScreen mainScreen].bounds.size.height
#define TWEAK_PATH    "/Library/MobileSubstrate/DynamicLibraries/CHFuckLoc.dylib"
#define KEY_ON        @"SWITCH_ON"

@interface CHGoViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UIScrollView           *scrollView;        //主页是scrollview
@property (nonatomic,strong) UITextField            *longiTextField;   //纬度
@property (nonatomic,strong) UITextField            *latituTextField;   //经度

@property (nonatomic,strong) AMViralSwitch          *switchBtn;//开关按钮
@property (nonatomic,strong) UILabel                *tipLabel;  //提示标签
@property (nonatomic,strong) CHButton               *updateBtn;//刷新按钮

@property (nonatomic,strong) CLLocationManager      *locationManager;

@property (nonatomic,strong) MKMapView              *mapView;//地图view
@property (nonatomic,strong) UITapGestureRecognizer * mTap;//地图手势

@property (nonatomic,strong) MKPinAnnotationView    * annotationView;//地图标注


@end

@implementation CHGoViewController


#pragma mark - UI START ---
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.contentSize = CGSizeMake(k_w, k_h + 5);
        _scrollView.bounces = YES;
        
    }
    return _scrollView;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        self.locationManager                 = [[CLLocationManager alloc] init];
        _locationManager.delegate            = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter  = 50;

    }
    return _locationManager;

}


- (UITextField *)longiTextField{
    if (!_longiTextField) {
        self.longiTextField                             = [[UITextField alloc] initWithFrame:(CGRect){ (k_w - 150) / 2, k_h - 150, 150, 30}];
        _longiTextField.placeholder                     = @"longitude";
        _longiTextField.borderStyle                     = UITextBorderStyleRoundedRect;
        //设置键盘的类型
        _longiTextField.keyboardType = UIKeyboardTypeDecimalPad;

        //键盘代理
        _longiTextField.delegate = self;
        //键盘弹出通知
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //注册通知
        //键盘弹出
        [nc addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //键盘取消
        [nc addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return _longiTextField;
}

- (UITextField *)latituTextField{
    if (!_latituTextField) {
        self.latituTextField = [[UITextField alloc] initWithFrame:(CGRect){ (k_w - 150) / 2, k_h - 200, 150, 30}];
        _latituTextField.placeholder = @"latitude";
        _latituTextField.borderStyle = UITextBorderStyleRoundedRect;
        //设置键盘类型
        _latituTextField.keyboardType = UIKeyboardTypeDecimalPad;
        //键盘代理
        _latituTextField.delegate = self;
        //键盘弹出通知
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //注册通知
        //键盘弹出
        [nc addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //键盘取消
        [nc addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardDidHideNotification object:nil];
    }
    return _latituTextField;
}

- (AMViralSwitch *)switchBtn{
    if (!_switchBtn) {
        self.switchBtn = [[AMViralSwitch alloc] initWithFrame:(CGRect){
            _longiTextField.frame.origin.x,
            _longiTextField.frame.size.height + _longiTextField.frame.origin.y + 20,
            70,
            20}];
        
        [self.switchBtn addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
        //设置颜色触发效果
        [_switchBtn setOnTintColor:[UIColor colorWithRed:131 /255.f green:175 / 255.f blue:155 / 255.f alpha:1]];
        //设置另外的标签
        
//        取值 初始化on
        NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
        NSInteger myInteger = [userDef integerForKey:KEY_ON];
        if (myInteger == 0) {
            _switchBtn.on = NO;
        }else{
            _switchBtn.on = YES;
        }
    }
    return _switchBtn;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        
        self.tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"位置刷新:";
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.font = [UIFont systemFontOfSize:17];
        //设置自适应宽度
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],};
        CGSize labelSize = [_tipLabel.text boundingRectWithSize:CGSizeMake(100, 34) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        //重计算坐标与大笑
        [_tipLabel setFrame:CGRectMake(_switchBtn.frame.origin.x + _switchBtn.frame.size.width + 50, _longiTextField.frame.origin.y + _longiTextField.frame.size.height + 30, labelSize.width, labelSize.height)];
        
        
    }
    return _tipLabel;
}

- (CHButton *)updateBtn{
    if (!_updateBtn) {
        self.updateBtn = [[CHButton alloc] initWithFrame:(CGRect){
                        _tipLabel.frame.size.width + _tipLabel.frame.origin.x ,
                        _switchBtn.frame.origin.y ,
                        34,
                        34}];
        [_updateBtn setImage:[UIImage imageNamed:@"caihong"] forState:UIControlStateNormal];
        
        //按钮切圆
        _updateBtn.layer.cornerRadius = 17;
        _updateBtn.layer.masksToBounds = YES;
        _updateBtn.backgroundColor = [UIColor lightGrayColor];
        
        //监听方法
        [_updateBtn addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //默认隐藏
        _updateBtn.enabled = NO;
        
        
    }
    return _updateBtn;
}

- (MKMapView *)mapView{
    if (!_mapView) {
        self.mapView      = [[MKMapView alloc] initWithFrame:(CGRect){ 0, 20, k_w, k_h -250 }];
        _mapView.mapType  = MKMapTypeStandard;
        _mapView.delegate = self;
        
        [self.mapView setShowsUserLocation:YES];
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        //地图添加手势
        [_mapView addGestureRecognizer:self.mTap];
        
    }
    return _mapView;
}

- (UITapGestureRecognizer *)mTap{
    if (!_mTap) {
        self.mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    }
    return _mTap;
}


#pragma mark - UI END ---

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化布局
    [self setUI];
    //初始化地理位置
    [self.locationManager startUpdatingLocation];
    //读取文件位置
    [self readLocation];
    NSString *path = NSHomeDirectory();//主目录
    NSLog(@"NSHomeDirectory:%@",path);

}


#pragma mark - UI初始化
- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [_scrollView addSubview:self.longiTextField];
    [_scrollView addSubview:self.latituTextField];
    [_scrollView addSubview:self.switchBtn];
    [_scrollView addSubview:self.tipLabel];
    [_scrollView addSubview:self.updateBtn];
    [_scrollView addSubview:self.mapView];
 
}

#pragma mark - 读取上次的位置
- (void)readLocation{
    NSDictionary *dic         = [LocModel getDicFromPlist];
    self.longiTextField.text = dic[@"longitude"];
    self.latituTextField.text = dic[@"latitude"];
}

#pragma mark - 地理位置改变时触发 真实位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *current       = [locations lastObject];
    self.longiTextField.text = [NSString stringWithFormat:@"%f",current.coordinate.longitude];
    self.latituTextField.text = [NSString stringWithFormat:@"%f",current.coordinate.latitude];

    [self.locationManager stopUpdatingLocation];
}


#pragma mark - 开关按钮事件
- (void)swChange:(AMViralSwitch *)sw{
    @autoreleasepool {
        //    写入偏好设置
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:@(sw.on) forKey:KEY_ON];
        //    如果打开开关 则将信息写入到文件
        if (sw.on == YES) {
            NSDictionary *dic = @{@"longitude":self.longiTextField.text,@"latitude":self.latituTextField.text,@"isOpen":@YES};
            [LocModel writeToPlist:dic];
            
            //对UI的控制
            _tipLabel.textColor = [UIColor yellowColor];
            _updateBtn.enabled = YES;
            //动态加载库 更新
            [self upDateTweak];
            
        }else{
            //        否则不进行hook
            NSDictionary *dic = @{@"longitude":self.longiTextField.text,@"latitude":self.latituTextField.text,@"isOpen":@NO};
            [LocModel writeToPlist:dic];
            
            //对UI 的控制
            _tipLabel.textColor = [UIColor blackColor];
            _updateBtn.enabled = NO;
            
            //动态加载库 更新
            [self upDateTweak];
        }
        
    }
}

#pragma mark - 点击地图手势事件
- (void)tapPress:(UIGestureRecognizer *)gestureRec{
    @autoreleasepool {
        
    //获取坐标
    CGPoint touchPoint = [gestureRec locationInView:_mapView];
    //坐标转地理位置
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    //设置地理位置
    self.latituTextField.text = [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
    self.longiTextField.text = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
    //先删除地图上的所有标注
    [_mapView removeAnnotations:self.mapView.annotations];
    //添加大头针
    MyAnnotation * annotation = [[MyAnnotation alloc] initWithCoordinates:touchMapCoordinate title:@"到这儿" subTitle:@"就是这儿"];
    [self.mapView addAnnotation:annotation];
   
    }
    
}

#pragma mark - 添加地图标注
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    @autoreleasepool {
        
    MKAnnotationView * result = nil;
    if([annotation isKindOfClass:[MyAnnotation class]] == NO)
    {
        return result;
    }
    
    if([mapView isEqual:self.mapView] == NO)
    {
        return result;
    }
    
    
    static NSString *annoIdentifier = @"ANNOIDENTI";
    MyAnnotation * senderAnnotation = (MyAnnotation *)annotation;
    self.annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annoIdentifier];
    if( _annotationView == nil)
    {
        _annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:annoIdentifier];
        
        [_annotationView setCanShowCallout:NO];
    }
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    _annotationView.rightCalloutAccessoryView = button;
    
    _annotationView.opaque = NO;
    _annotationView.animatesDrop = YES;
    _annotationView.draggable = YES;
    _annotationView.selected = YES;
    _annotationView.calloutOffset = CGPointMake(15, 15);
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
    _annotationView.leftCalloutAccessoryView = imageView;
    
    result = _annotationView;
    return result;
        
    }
}

#pragma mark - 打开tweak 动态库
- (void)upDateTweak{
    //打开tweak dylib库
    void *handle = dlopen(TWEAK_PATH, RTLD_LAZY);
    if (handle) {
        NSLog(@"handle OK");
    }
    else{
        NSLog(@"can not open handle");
        dlclose(handle);
    }
}
#pragma mark - mapview的代理方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
        MKCoordinateSpan span     = MKCoordinateSpanMake(0.01, 0.01);
        MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
        [_mapView setRegion:region animated:true];
}

#pragma mark - 点击其他事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.longiTextField resignFirstResponder];
    [self.latituTextField resignFirstResponder];
}

#pragma mark - 键盘弹出时触发的通知
- (void)keyBoardWillShow:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"%f,%f",kbSize.width,kbSize.height);
    _scrollView.contentOffset = CGPointMake(0, kbSize.height);
    
}
#pragma mark - 键盘收起来时触发的通知
- (void)keyBoardWillHidden:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"%f,%f",kbSize.width,kbSize.height);
    [UIView animateWithDuration:0.1 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];

}
#pragma mark - textfield代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 更新按钮点击事件
- (void)updateBtnClick:(UIButton *)sender{
    NSDictionary *dic = @{@"longitude":self.longiTextField.text,@"latitude":self.latituTextField.text,@"isOpen":@YES};
    
    [LocModel writeToPlist:dic];
    //动态加载库 更新
    [self upDateTweak];
    
    [self.updateBtn startTransformWithDuration:0.4];
    
}





@end
