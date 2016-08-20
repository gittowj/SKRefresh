//
//  ViewController.m
//  SKRefresh
//
//  Created by 魏娟 on 16/8/20.
//  Copyright © 2016年 魏娟. All rights reserved.
//

#import "ViewController.h"
#import "SKPopRefreshView.h"
#import "SKPullToRefreshController.h"
#import "SKInfiniteScrollingView.h"

@interface ViewController ()

@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SKPopRefreshView *popRefreshView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SKPullToRefreshController *myRefreshControl;
@property (nonatomic, strong) SKInfiniteScrollingView *infiniteScrollingView;
@property (nonatomic, strong) SKPopRefreshView *infinitePopRefreshView;
@property (nonatomic, strong) NSMutableArray *source;
@end


@implementation ViewController

- (void)addRefreshView{
    
    self.popRefreshView = [[SKPopRefreshView alloc] initWithFrame:CGRectZero];
    self.infinitePopRefreshView = [[SKPopRefreshView alloc] initWithFrame:CGRectZero];
    
    _myRefreshControl = [[SKPullToRefreshController alloc] initInScrollView:self.tableView activityIndicatorView:self.popRefreshView];
    //_myRefreshControl.backgroundColor = [UIColor redColor];
    [_myRefreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    _infiniteScrollingView = [[SKInfiniteScrollingView alloc] initInScrollView:self.tableView activityIndicatorView:self.infinitePopRefreshView];
    
    __block typeof(SKPullToRefreshController *) blockMyRefreshControl = _myRefreshControl;
    __weak typeof(ViewController *) weakSelf = self;
    _myRefreshControl.refreshingBlock = ^{
        if (weakSelf.infiniteScrollingView.refreshing) {
            blockMyRefreshControl.refreshing = NO;
        }
    };
    
    _myRefreshControl.beginRefreshingCompletionBlock = ^{
        //[weakSelf refresh];
    };
    
    __block typeof(SKInfiniteScrollingView *) blockInfiniteScrollingView = _infiniteScrollingView;
    _infiniteScrollingView.refreshingBlock = ^{
        if (weakSelf.myRefreshControl.refreshing) {
            blockInfiniteScrollingView.refreshing = NO;
        }
    };
    
    _infiniteScrollingView.beginRefreshingCompletionBlock = ^{
        //[weakSelf refreshMore];
    };
    
    [_myRefreshControl placeSubviews];
    [_infiniteScrollingView placeSubviews];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 60, 40)];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *endbtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 64, 60, 40)];
    [endbtn setTitle:@"end" forState:UIControlStateNormal];
    [endbtn setBackgroundColor:[UIColor orangeColor]];
    [endbtn addTarget:self action:@selector(end:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endbtn];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = 114;
    frame.size.height -= 114;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self addRefreshView];
    [self refresh];
}

- (void)refresh{
    self.source = [[NSMutableArray alloc] init];
    for (int i; i < 10; i++) {
        [self.source addObject:[NSString stringWithFormat:@"dsafda_%d", i]];
    }
    
    [self.myRefreshControl endRefreshing];
    [self.tableView reloadData];
}

-(void)start:(id)sender{
    [self.myRefreshControl beginRefreshing];
    //[_infiniteScrollingView beginRefreshing];
}

-(void)end:(id)sender{
    [self.myRefreshControl endRefreshing];
    [_infiniteScrollingView endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshMore{
    int count = self.source.count;
    for (int i = count; i < count + 10; i++) {
        [self.source addObject:[NSString stringWithFormat:@"dsafda_%d", i]];
    }
    
    [self.tableView reloadData];
    [self.infiniteScrollingView endRefreshing];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.source[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
@end