//
//  PersonalInforViewController.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/6.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "PersonalInforViewController.h"
#import "PersonalInforTableViewCell.h"
#import <BRPickerView.h>
#import "HeaderViewController.h"

@interface PersonalInforViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UIImageView *_headerView;
    
    UITableView *_myTableView;
    NSMutableArray *_listArr;
    
    NSString *_avatar;
    NSString *_imageUrl;
}

@end

@implementation PersonalInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _avatar = @"";
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    _listArr = [NSMutableArray array];
    [self createTableView];
    
    [self loadingWithText:@"加载中"];
    [self getLoginUserInfo];
}

- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.bounces = YES;
    if (@available(iOS 11.0, *)) {
        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_myTableView];
    
    
    [self createHeaderView];
    
}

- (void)createHeaderView
{
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 80)];
    headerBgView.backgroundColor = [UIColor whiteColor];
    _myTableView.tableHeaderView = headerBgView;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 80)];
    label1.text = @"头像";
    label1.textColor = [MyTool colorWithString:@"333333"];
    label1.font = [UIFont systemFontOfSize:15];
    [headerBgView addSubview:label1];
    
    UIImageView *arrowsImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 15 - 6, 35, 6, 10)];
    arrowsImage.image = [UIImage imageNamed:@"箭头"];
    [headerBgView addSubview:arrowsImage];
    
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 15 - 6 - 5 - 40, 20, 40, 40)];
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius = 40 / 2;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    _headerView.backgroundColor = [UIColor clearColor];
    [headerBgView addSubview:_headerView];
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction:)];
    [headerBgView addGestureRecognizer:headTap];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 79.5, kScreenW - 30, 0.5)];
    line.backgroundColor = [MyTool colorWithString:@"e1e1e1"];
    [headerBgView addSubview:line];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[PersonalInforTableViewCell class] contentViewWidth:kScreenW];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PersonalInforTableViewCell";
    PersonalInforTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PersonalInforTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.dataDic = _listArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_listArr[indexPath.row][@"titleName"] isEqualToString:@"昵称"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"修改昵称" message:@"长度限制: 1-10个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *txtName = [alertView textFieldAtIndex:0];
        txtName.placeholder = @"请输入昵称";
        txtName.text = _listArr[indexPath.row][@"detail"];
        alertView.tag = 1000;
        txtName.delegate = self;
        [txtName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        txtName.tag = 1000;
        [alertView show];
    } else if ([_listArr[indexPath.row][@"titleName"] isEqualToString:@"生日"]) {
        NSString *defaultSelValue = @"";
        if (![_listArr[indexPath.row][@"detail"] isEqualToString:@"请选择"]) {
            defaultSelValue = _listArr[indexPath.row][@"detail"];
        }
        [BRDatePickerView showDatePickerWithTitle:@"" dateType:BRDatePickerModeYMD defaultSelValue:defaultSelValue minDate:nil maxDate:nil isAutoSelect:NO themeColor:nil resultBlock:^(NSString *selectValue) {
            [self getSaveUserInfoWithKey:@"birthday" Value:selectValue];
        }];
    } else if ([_listArr[indexPath.row][@"titleName"] isEqualToString:@"性别"]) {
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        action.tag = 2000;
        [action showInView:self.view];
    } else if ([_listArr[indexPath.row][@"titleName"] isEqualToString:@"个性签名"]) {
        NSString *txtStr = @"";
        if (![_listArr[indexPath.row][@"detail"] isEqualToString:@"请填写"]) {
            txtStr = _listArr[indexPath.row][@"detail"];
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"修改个性签名" message:@"长度限制: 30个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *txtName = [alertView textFieldAtIndex:0];
        txtName.placeholder = @"请输入个性签名";
        txtName.text = txtStr;
        alertView.tag = 2000;
        txtName.delegate = self;
        [txtName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        txtName.tag = 2000;
        [alertView show];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == 1000) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (textField.text.length >= 10) {
            textField.text = [textField.text substringToIndex:10];
            return NO;
        }
    } else if (textField.tag == 2000) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (textField.text.length >= 30) {
            textField.text = [textField.text substringToIndex:30];
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    CGFloat maxLength = textField.tag == 1000 ? 10 : 30;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

#pragma mark - 点击代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (alertView.tag == 1000) {
            [self getSaveUserInfoWithKey:@"username" Value:textField.text];
        } else {
            [self getSaveUserInfoWithKey:@"signature" Value:textField.text];
        }
    }
}

- (void)headTapAction:(UITapGestureRecognizer *)tap
{
    if (![_avatar isEqualToString:@""]) {
        HeaderViewController *headerVC = [[HeaderViewController alloc] init];
        headerVC.imageUrl = _imageUrl;
        [self.navigationController pushViewController:headerVC animated:YES];
    } else {
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        action.tag = 1000;
        [action showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 0) {
            [self getImageFromIpcWithCamera:YES];
        } else if (buttonIndex == 1) {
            [self getImageFromIpcWithCamera:NO];
        }
    } else {
        if (buttonIndex == 0) {
            [self getSaveUserInfoWithKey:@"sex" Value:@"1"];
        } else if (buttonIndex == 1) {
            [self getSaveUserInfoWithKey:@"sex" Value:@"2"];
        }
    }
}

// 获取系统相册图片
- (void)getImageFromIpcWithCamera:(BOOL)isCamera
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    if (isCamera) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 设置图片
    _headerView.image = info[UIImagePickerControllerOriginalImage];
    
    
    [self uploadImage:info[UIImagePickerControllerOriginalImage]];
}

#pragma mark -- 上传图片
- (void)uploadImage:(UIImage *)image
{
    [self loadingWithText:@"上传图片中"];
    NSString *urlStr = [NetRequest ImageUpload];
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //2.上传文件
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken]};
    [manager POST:urlStr parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // UIImagePNGRepresentation(image)
        NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
        [formData appendPartWithFileData:imageData name:@"images" fileName:@"images.png" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKeyNotNull:@"error"] integerValue] == 0) {
            [self getSaveUserInfoWithKey:@"avatar" Value:responseObject[@"data"][@"id"][0]];
        } else {
            [self endLoading];
            [MyTool showHUDWithStr:responseObject[@"msg"]];
        }
        NSLog(@"请求成功：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self endLoading];
        NSLog(@"请求失败：%@",error);
    }];
}

- (void)getLoginUserInfo
{
    NSString *urlStr = [NetRequest LoginUserInfo];
    NSDictionary *paramsDic = @{};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        if ([JSON[@"error"] integerValue] == 0) {
            _avatar = JSON[@"data"][@"avatar"];
            _imageUrl = JSON[@"data"][@"avatar_url"];
            NSString *sex = @"请选择";
            if ([JSON[@"data"][@"sex"] isEqualToString:@"1"]) {
                sex = @"男";
            } else if ([JSON[@"data"][@"sex"] isEqualToString:@"2"]) {
                sex = @"女";
            }
            _listArr = [NSMutableArray arrayWithArray:@[@{@"titleName": @"昵称", @"detail":JSON[@"data"][@"username"]}, @{@"titleName": @"生日", @"detail":JSON[@"data"][@"birthday"]}, @{@"titleName": @"性别", @"detail":sex}, @{@"titleName": @"个性签名", @"detail":JSON[@"data"][@"signature"]}]];
            [_headerView sd_setImageWithURL:[NSURL URLWithString:_avatar] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            [_myTableView reloadData];
        }
        [self endLoading];
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

- (void)getSaveUserInfoWithKey:(NSString *)key Value:(NSString *)value
{
    [self loadingWithText:@"修改中"];
    NSString *urlStr = [NetRequest SaveUserInfo];
    NSDictionary *paramsDic = @{key:value};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        if ([JSON[@"error"] integerValue] == 0) {
            [self getLoginUserInfo];
        }
        [MyTool showHUDWithStr:JSON[@"msg"]];
        [self endLoading];
    } failure:^(NSError *error) {
        [self endLoading];
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
