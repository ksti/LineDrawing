//
//  SearchViewController.m
//  TheNewThreeBoard
//
//  Created by GJ on 16/6/12.
//  Copyright © 2016年 forp. All rights reserved.
//

#import "SearchViewController.h"

#import "CollectionImagesModel.h"
#import "IQKeyboardManager.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField *_txfSearch;
    NSString *_strKeyword;
    NSArray *_arrHistoryList;
    NSMutableArray *_arrShowDataSource;
    UILabel *lblHeader;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadNavigationBarItems];
    [self loadDefaultValue];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
-(void)loadNavigationBarItems{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UITextField *txfSearch = [[UITextField alloc] initWithFrame:CGRectMake(0, 0,size.width-2*70, 30)];
    [txfSearch setBackgroundColor:[UIColor whiteColor]];
    txfSearch.layer.cornerRadius = 3;
    
    txfSearch.placeholder = @"请输入任务关键字";
    
    txfSearch.delegate = self;
    txfSearch.returnKeyType = UIReturnKeySearch;
    [txfSearch setFont:[UIFont systemFontOfSize:15.0]];
    self.navigationItem.titleView = txfSearch;
    
    UIView *viewRight =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *imgRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    [imgRight setFrame:CGRectMake(10, 5, 20, 20)];
    [viewRight addSubview:imgRight];
    [txfSearch setLeftView:viewRight];
    [txfSearch setLeftViewMode:UITextFieldViewModeAlways];
    [txfSearch setClearButtonMode:UITextFieldViewModeWhileEditing];
    [txfSearch setBorderStyle:UITextBorderStyleRoundedRect];
    _txfSearch = txfSearch;
    
    UIBarButtonItem *itemRight =[[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(btnSearchAction:)];
    self.navigationItem.rightBarButtonItem = itemRight;
}
-(void)loadDefaultValue{
    NSArray *arrHistory = [[NSUserDefaults standardUserDefaults] objectForKey:CONFIG_SEARCH_HISTORY];
    _arrHistoryList =arrHistory;
    
    [_tableView reloadData];
    
}
-(void)btnClearAction:(UIButton *)sender{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CONFIG_SEARCH_HISTORY];
    _arrHistoryList = nil;
    [_tableView reloadData];
}
-(void)btnSearchAction:(UIButton *)sender{
    if (_txfSearch.text.length == 0) {
        [SVProgressHUD showAlterMessage:@"您还没有输入关键字"];
        return;
    }
    
    [_txfSearch resignFirstResponder];
    [self requestToSearchWithKeyword:_txfSearch.text];
}
#pragma mark - tableview delegate/datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_txfSearch.text.length>0) {
        return _arrShowDataSource.count;
    }else{
        return _arrHistoryList.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * strId = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strId];
    }
    if (_txfSearch.text.length>0) {
        CollectionImagesModel *cellModel = _arrShowDataSource[indexPath.row];
        [cell.textLabel setText:cellModel.strTitle];
    }else{
        [cell.textLabel setText:_arrHistoryList[indexPath.row]];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_txfSearch.text.length<=0 || _arrShowDataSource.count>0){
        return 40;
    }else{
        return tableView.frame.size.height;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_txfSearch.text.length>0 && _arrShowDataSource.count==0) {
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableView.frame.size.height)];
        UIButton *btnResult =[UIButton buttonWithType:UIButtonTypeCustom];
        [btnResult setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [btnResult setTitle:@"未搜索到相关结果" forState:UIControlStateNormal];
        [btnResult setTitleColor:kColorTextGray forState:UIControlStateNormal];
        [btnResult.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [btnResult setUserInteractionEnabled:NO];
        [btnResult setFrame:CGRectMake(60, ScreenWidth/2.0-100, 200, 20)];
//        UILabel *lblResult=[[UILabel alloc] initWithFrame:CGRectMake(60, ScreenWidth/2.0-100, 200, 20)];
//        [lblResult setText:@"🔍未搜索到相关结果"];
        [view addSubview:btnResult];
        return view;
    }else{
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
        [lblText setTextColor:kColorBlue];
        [lblText setFont:[UIFont systemFontOfSize:14.0]];
        [view addSubview:lblText];
        if (_txfSearch.text.length<=0) {
            [lblText setText:@"最近"];
        }else{
            [lblText setText:[NSString stringWithFormat:@"共搜到%zd条相关任务",_arrShowDataSource.count]];
        }
        return view;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_txfSearch.text.length>0) {
        return nil;
    }else{
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        [lblText setText:@"清除历史纪录"];
        [lblText setTextColor:kColorBlue];
        [lblText setFont:[UIFont systemFontOfSize:14.0]];
        [view addSubview:lblText];
        
        UIButton *btnClear =[UIButton buttonWithType:UIButtonTypeCustom];
        [btnClear setFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [btnClear addTarget:self action:@selector(btnClearAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnClear];
        
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_txfSearch.text.length>0) {
        return 1;
    }else{
        return 40;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_txfSearch.text.length>0) {
        //插入新的搜索记录
        NSArray *arrHistory = [[NSUserDefaults standardUserDefaults] objectForKey:CONFIG_SEARCH_HISTORY];
        NSMutableArray *arrMul = [NSMutableArray arrayWithArray:arrHistory];
        NSString *strNewWord = _txfSearch.text;
        
        if (arrHistory && arrHistory.count>0) {
            NSInteger index = [arrHistory indexOfObject:strNewWord];
            DebugLog(@"index:%zd",index);
//#warning 判断是否有重复的关键字
            if (index>=0 && index<10) {
                [arrMul removeObjectAtIndex:index];
            }else if(arrHistory.count==10){
                [arrMul removeObjectAtIndex:9];
            }
        }
        [arrMul insertObject:_txfSearch.text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:arrMul forKey:CONFIG_SEARCH_HISTORY];
        
        [_txfSearch resignFirstResponder];
        
    }else{
        NSString *strHistory =_arrHistoryList[indexPath.row];
        _txfSearch.text = strHistory;
        [self requestToSearchWithKeyword:strHistory];
    }
}

#pragma mark - textField
-(void)textFieldTextDidChangeNotification{
    DebugLog(@"textField.text:%@",_txfSearch.text);
    if (_txfSearch.text.length<=0) {
        //en
        NSArray *arrHistory = [[NSUserDefaults standardUserDefaults] objectForKey:CONFIG_SEARCH_HISTORY];
        DebugLog(@"arrHistory:%@",arrHistory);
        _arrHistoryList = arrHistory;
        [_tableView reloadData];
        return;
    }
    UITextRange *textRange =_txfSearch.markedTextRange;
    UITextPosition *position = [_txfSearch positionFromPosition:textRange.start offset:0];
    if (position) {
        //有高亮选择的字符串，即有正在输入的拼音
        return;
    }else{
        //没有高粱选择的字，则对一输入的字进行查询
//        [self requestToSearchWithKeyword:_txfSearch.text];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        [SVProgressHUD showAlterMessage:@"您还没有输入关键字"];
        return YES;
    }
    [textField resignFirstResponder];
    [self requestToSearchWithKeyword:textField.text];
    return YES;
}
#pragma mark - http request
-(void)requestToSearchWithKeyword:(NSString *)keyword{
    
    if ([_strKeyword isEqualToString:keyword]) {
        return;
    }else{
        _strKeyword = keyword;
    }
    
    NSString *urlStr=[NSString stringWithFormat:@"%@/Api/WorkTask/WorkTask/GetDatas",API_SERVER_URL];
    NSDictionary *dicParam = @{@"taskTitle":keyword,
                               };
    DebugLog(@"dicParam:%@",dicParam);
    
    [SVProgressHUD show];
    [QLHttpTool postWithBaseUrl:urlStr parameters:dicParam withCookie:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"任务：%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dicResponse = (NSDictionary *)responseObject;
            
            if ([responseObject[@"code"] boolValue]) {
                
                [SVProgressHUD dismiss];
                
                NSArray *arrResponse = dicResponse[@"data"];
                NSMutableArray *arrMul =[NSMutableArray array];
                for (NSDictionary *dicRowData in arrResponse) {
                    CollectionImagesModel *model = [[CollectionImagesModel alloc] initWithDictionary:dicRowData];
                    [arrMul addObject:model];
                }
                _arrShowDataSource = arrMul;
                [_tableView reloadData];
            }else{
                [SVProgressHUD showAlterMessage:dicResponse[@"msg"]];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"数据格式错误,请重试"];
        }
    } whenFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error===");
        [SVProgressHUD showAlterMessage:error.localizedDescription];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
