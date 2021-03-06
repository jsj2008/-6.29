//
//  RequestInterface.m
//  SalesHelper_C
//
//  Created by summer on 14/11/3.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "RequestInterface.h"
#import "URLRequest.h"
#import "NSString+StringTpye.h"
#import <CommonCrypto/CommonDigest.h>


@implementation RequestInterface

#pragma mark Request Data With URL

-(void)requestGetInterfaceWithUrlString:(NSString *)urlString HTTPBodyDict:(NSDictionary *)bodyDict
{
    
    URLRequest *request = [[URLRequest alloc]init];
    request.cachDisk = self.cachDisk;
    [request startAsynchronizeGetRequestWithUrlString:urlString HTTPBodyDict:(NSDictionary *)bodyDict IsJsonAnalysis:YES];
    [request getReceivedData:^(id data)
     {
         if (_getRequestBlock!=nil)
         {
             _getRequestBlock(data);
         }
     } Fail:^(NSError *error)
     {
         if (_failRequestBlock!=nil)
         {
             _failRequestBlock(error);
         }
     }];
    
}

-(void)requestPostInterfaceWithUrlString:(NSString *)urlString HTTPBodyDict:(NSDictionary *)bodyDict
{
    URLRequest *request = [[URLRequest alloc]init];
    request.cachDisk = self.cachDisk;
    [request startAsynchronizePostRequestWithUrlString:urlString HTTPBodyDict:(NSDictionary *)bodyDict IsJsonAnalysis:YES];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [request getReceivedData:^(id data)
    {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        if (_getRequestBlock!=nil)
        {
            _getRequestBlock(data);
        }
    } Fail:^(NSError *error)
    {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        if (_failRequestBlock!=nil)
        {
            _failRequestBlock(error);
        }
    }];
    
}

-(void)getInterfaceRequestObject:(GetRequestBlock)getRequestBlock Fail:(FailRequstBlock)failRequestBlock
{
    _getRequestBlock = getRequestBlock;
    _failRequestBlock = failRequestBlock;
}

#pragma mark - request detail    每个请求的实现方法
#pragma mark 版本检测
-(void)requestUpGrateAppInterface
{
    [ProjectUtil showLog:@"---------版本检测----------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"http://app.hfapp.cn/VersionUpdate/CheckVersion?"];
    [self requestGetInterfaceWithUrlString:urlStr HTTPBodyDict:@{@"app_name":@"salehelper_referee_ios"}];
}

#pragma mark 活动图片接口
-(void)requestMGetAdsNWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------活动图片接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/ads/queryAds.do",REQUEST_SERVER_URL];
    
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}


#pragma mark  所有的  发送短信 获得  验证码接口
-(void)requestRegisterSendSMSWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------注册短信验证码------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/getSmsCode.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 注册接口
-(void)requestRegisterWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------注册接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/registered.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
#pragma mark - 搜索界面 大小价格等数组查询
-(void)requestGetSearchIDWithParam:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/property/getHouseAttribute.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}


#pragma mark 从服务端获取，是否显示邀请赚钱、分享赚钱
-(void)ShowZhuanQian{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/issigned.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:[[NSDictionary alloc] init]];
}

#pragma mark 登录接口
-(void)requestLoginWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------登录接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/loginReferee.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 忘记密码发送验证码接口
-(void)requestForgetpwdSendSMSWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------忘记密码短信验证码------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/getSmsCodeByuserName.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}


#pragma mark 设置新密码接口
-(void)requestSetpwdWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------设置新密码接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/saveUserPwd.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 楼盘信息接口
-(void)requestGetPropertyInfosWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------楼盘信息接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/property/GetPropertyInfos.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 查询推荐记录接口 客户 我要申诉 里面的
-(void)requestGetRecRecordByCWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查询推荐记录接口------------"];
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/queryRecByToken.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 面积、价格标题接口
-(void)requestGetHouseAttributeWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------区域、面积、价格接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/property/GetHouseAttribute.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 区域接口
-(void)requestGetDistrictWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------区域接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/GetDistrict.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 推荐接口
-(void)requestAddRecWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查询推荐信息接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/addPropertyInfos.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}


#pragma mark 添加提现账户接口   添加银行卡
-(void)requestAddWithdWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------添加提现账户接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/withdrawToken/saveRefereeUserBank.do?",REQUEST_SERVER_URL];
    
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 获取全部 银行卡
-(void)requestGetAllbankWithParam:(NSDictionary* )dic
{
    NSString* urlstr=[NSString stringWithFormat:@"%@/withdrawToken/queryBanks.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlstr HTTPBodyDict:dic];
    
    
    
}





#pragma mark 查询提现账户接口   我的银行卡接口
-(void)requestGetWithdWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查询提现账户接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/withdrawToken/queryRefereeUserBanks.do?",REQUEST_SERVER_URL];
    
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 修改支付宝账户接口
-(void)requestModWithdWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------修改支付宝账户接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/ModWithd.do?",REQUEST_SERVER_URL];
    
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark  删除绑定银行卡信息
-(void)requestDeleteWithdWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------删除绑定银行卡信息------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/withdrawToken/delRefereeUserBankById.do?",REQUEST_SERVER_URL];
    
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
#pragma mark 提现接口
-(void)requestSubWithdWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------提现接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/reward/saveRecord.do?",REQUEST_SERVER_URL];
    
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 查询佣金信息接口  ye也就是佣金 明细
-(void)requestGetRewardByRWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查询总佣金信息接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/reward/queryRewardInfos.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}


#pragma mark 查询佣金 类型 接口
-(void)requestRewardTypeWithparam:(NSDictionary* )dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/reward/queryRewardInfoTypes.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
    
    
    
}


#pragma mark 查询客户推荐进度接口
-(void)requestGetRecRecordPWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查询客户推荐进度接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/GetRecRecordP.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}



#pragma mark 查询客户接口
- (void)requestGetCustomerPropertyWithParam:(NSDictionary *)dic
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/properToken/nQueryRecStages.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];

}

- (void)requestGetCustomerQueryRecWithParam:(NSDictionary *)dic
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/properToken//queryRecByRefereePhone.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
    
}
#pragma mark 投诉建议接口
-(void)requestAddVadvWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------投诉建议接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/AddVadv.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 修改 登录 密码接口
-(void)requestUpdatePwdWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------修改密码接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/updateUserPwd.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

//#pragma mark 修改 登录 密码接口
//
//-(void)requestUpDateLoginPswWithPrarm:(NSDictionary* )dic
//{
//
//    [ProjectUtil showLog:@"------------修改密码接口------------"];
//    
//    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/updateWithdrawals.do?",REQUEST_SERVER_URL];
//    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
//
//
//}

#pragma mark 查询佣金明细接口
-(void)requestGetRewardDByRWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查询佣金明细接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/GetRewardDByR.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}


#pragma mark 设置提现密码接口
-(void)requestSetWithdPwdWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------设置提现密码接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/saveWithdrawals.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}


#pragma mark 修改 提现 密码接口
-(void)requestModWithdPwdWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------修改提现密码接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/updateWithdrawals.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 忘记提现密码接口
-(void)requestforgetWithpwdWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------忘记提现密码接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/forgetWithpwd.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 分享加钱接口

-(void)requestShareAddWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------分享加钱接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/ShareAdd.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 查询提现记录接口

-(void)requestGetWithdRecordWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查询提现记录------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/GetWithdRecord.do?",REQUEST_SERVER_URL];
    
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}


#pragma mark 申述接口

-(void)requestSubAppealWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------申述接口------------"];
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/saveAppeal.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 查看申述记录接口 li历史申诉 记录
-(void)requestGetAppealRecByCWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查看申述记录接口------------"];
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/queryAppeals.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}


#pragma mark 查看 分享 列表  接口
-(void)requestGetShareListWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查看分享列表接口------------"];
    NSString  *urlStr = [NSString stringWithFormat:@"%@/zbp/queryZbpPosts.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
    
}


#pragma mark 退出接口
-(void)requestLogOutWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------退出接口------------"];
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/outLongManager.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

-(void)requestGetLocationCityWithParam:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/ads/getCtiyID.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 请求上传头像接口   之前后面加三个参数 %@&token=%@&user_version=%@  ,RequestKey,token,user_version
-(void)requestUploadAvatarInterfaceWithImage:(UIImage *)image token:(NSString *)token user_version:(NSString *)user_version
{
    boundary = @"----------V2ymHFg03ehbqgZCaKO6jy";
    NSString *urlStr = [NSString stringWithFormat:@"%@/upload/uploadImages.do?", REQUEST_SERVER_URL];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
   
    URLRequest *request = [[URLRequest alloc]init];
    [request startAsynchronizePostRequestWithUrlString:urlStr HTTPBodyData:[self prepareBodyDataForUploadWithUIImage:image token:token user_version:user_version] HTTPHeaderField:contentType IsJsonAnalysis:YES];
    [request getReceivedData:^(id data)
     {
         if (_getRequestBlock!=nil)
         {
             _getRequestBlock(data);
         }
     } Fail:^(NSError *error)
     {
         if (_failRequestBlock!=nil)
         {
             _failRequestBlock(error);
         }
     }];
}

#pragma mark 请求上传铃声 %@&token=%@&user_version=%@  ,RequestKey,token,user_version
-(void)requestUploadAvatarInterfaceWithNSData:(NSData *)recordData{
   
    boundary = @"----------V2ymHFg03ehbqgZCaKO6jy";
    NSString *urlStr = [NSString stringWithFormat:@"%@/upload/uploadVoice.do?",REQUEST_SERVER_URL];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    URLRequest *request = [[URLRequest alloc]init];
    [request startAsynchronizePostRequestWithUrlString:urlStr HTTPBodyData:[self prepareBodyDataForUploadRecordAccFileData:recordData] HTTPHeaderField:contentType IsJsonAnalysis:YES];
    [request getReceivedData:^(id data)
     {
         if (_getRequestBlock!=nil)
         {
             _getRequestBlock(data);
         }
     } Fail:^(NSError *error)
     {
         if (_failRequestBlock!=nil)
         {
             _failRequestBlock(error);
         }
     }];
}



//#pragma mark 图片上传   这个没用 可以注释了
//-(void)requestUploadHeadImagewithImage:(UIImage* )image
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@/upload/uploadImages.do?",REQUEST_SERVER_URL];
//    URLRequest *request = [[URLRequest alloc]init];
//    [request startAsynchronizePostRequestWithUrlString:urlStr BodyString:nil IsJsonAnalysis:YES];
//    [request getReceivedData:^(id data)
//     {
//         if (_getRequestBlock!=nil)
//         {
//             _getRequestBlock(data);
//         }
//     } Fail:^(NSError *error)
//     {
//         if (_failRequestBlock!=nil)
//         {
//             _failRequestBlock(error);
//         }
//     }];
//}


#pragma mark 上传头像成功之后 保存用户信息

//(NSString* )token name:(NSString *)name sex:(NSString* )sex face:(UIImage* )image
-(void)requestsaveMyInfoWithtoken:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------上传头像成功之后 保存用户信息------------"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/referee/saveUser.do?",REQUEST_SERVER_URL];
    
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
    
}




#pragma mark 获取运营城市接口
-(void)requestyunyingCitywithdic:(NSDictionary* )dic
{
    [ProjectUtil showLog:@"查看运营城市接口==="];
    NSString* urlstr=[NSString stringWithFormat:@"%@/property/queryDistricts.do",REQUEST_SERVER_URL];
    
    [self requestPostInterfaceWithUrlString:urlstr HTTPBodyDict:dic];
    
}




#pragma mark 查看推荐人信息
-(void)requestGetReferInfoWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------修改推荐人信息接口------------"];
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/getUserInfo.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 修改推荐人信息   
-(void)requestUpdateReferInfoWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------修改推荐人信息接口------------"];
    NSString  *urlStr = [NSString stringWithFormat:@"%@/updateReferInfo.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}



#pragma mark 查看分享明细接口
-(void)requestGetShareRecWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查看分享列表接口------------"];
    NSString  *urlStr = [NSString stringWithFormat:@"%@/zbp/queryZbpPosts.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 分享赚钱
-(void)requestAddShareRecWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------查看分享列表接口------------"];
    NSString  *urlStr = [NSString stringWithFormat:@"%@/zbp/saveShare.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 公告接口
-(void)requestGetAnnounceListWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------公告接口------------"];
    NSString  *urlStr = [NSString stringWithFormat:@"%@/xbgaogong/queryxbgaogongposts.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 推送registrationID
-(void)requestGetSetRegistIDWithParam:(NSDictionary *)dic
{
    [ProjectUtil showLog:@"------------推送registrationID------------"];
    NSString  *urlStr = [NSString stringWithFormat:@"%@/setRegistID.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#pragma mark 楼盘信息接口
-(void)requestGetPropertyInfosWithPropertyInfoID:(NSString *)infoID
{
    NSDictionary * dic = @{
                           @"id":infoID,
                           };
    NSString  *urlStr = [NSString stringWithFormat:@"%@/property/getGetPropertyInfo.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
-(NSData*)prepareBodyDataForUploadWithUIImage:(UIImage *)image token:(NSString *)token user_version:(NSString *)user_version
{
    NSMutableData *body = [NSMutableData data];
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadimg\"; filename=\"avatar.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/zip\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

- (NSData *)prepareBodyDataForUploadRecordAccFileData:(NSData *)accData
{
    NSMutableData *body = [NSMutableData data];
    if (accData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadimg\"; filename=\"luyin.m4a\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/zip\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:accData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

#pragma mark 查询物业类型
-(void)requestGetEstateState
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/property/getEstateStates.do",REQUEST_SERVER_URL];
//    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:nil];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:nil];
}

- (void)requestGetBulletinWithDic:(NSDictionary *)param
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/xbgaogong/queryxbgaogongposts.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:param];

}
#pragma mark -推荐记录明细
- (void)requestGetqueryRecStageInfos:(NSDictionary *)param
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/queryRecStageInfos1_4.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:param];
}


#pragma mark 省钱电话拨打电话
-(void)freePhoneCallWithCallKey:(NSString *)key Called:(NSString *)called Token:(NSString *)token
{
    NSString *urlStr = [NSString stringWithFormat:@"%@call?",FreePhoneRequestHost];
    NSString *bodyStr = [NSString stringWithFormat:@"&agent_id=%@&key=%@&called=%@&token=%@",FreePhoneId,key,called,token];
    [self requestInterfaceWithUrlString:urlStr BodyString:bodyStr];
}
#pragma mark -首页轮播图
- (void)requestGetqueryHeads:(NSDictionary *)param;
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@//info/queryHeads.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:param];
}
#pragma mark -发现首页数据接口
-  (void)requestGEtDisCover
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/login/queryShieldings.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:nil];
}
#pragma mark - 我的界面 邀请赚钱读取字符串
- (void)requestForMoney
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/login/getShieldingYQ.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:nil];
}
#pragma  mark - 申请带看
- (void)requestTakeLookWithParam:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/takeLook.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
#pragma mark - 机构解绑 绑定
- (void)requestOrgCodeWithParam:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/bindingOrRelieve1_4.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
#pragma mark - 我的团队首页- 我的下线
- (void)requestMyTeamWithParam:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/teamList.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
#pragma mark - 我的团队 - 推荐记录
- (void)requestMyTeamCustmerWithParam:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/teamInfo.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

#warning 3.2.0迭代客户接口
#pragma mark -- 客户主页客户数量查询
- (void)requestMyCustmorsHomePageCustmorCounts:(NSString *)token
{
    NSDictionary * dic = @{
                           @"token":token,
                           };
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/sumRec.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
//查询客户列表
- (void)requestMyCustmorsManagerWithToken:(NSString *)token
{
    NSDictionary * dic = @{
                           @"token":token,
                           };
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/queryRecCust.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
//新增客户
- (void)addClientsWithInfos:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/addRecCust.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
//修改客户信息
- (void)requestEditClientsWithInfos:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/updateRecCust.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
//搜索
- (void)requestMyCustmorSearchWith:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/searchRecCust.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

//查询跟进记录
- (void)requestFollowUpDatasWith:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/queryFollowRecord.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
//新增跟进记录
- (void)requestAddFollowUpWithDict:(NSDictionary *)dic{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/addFollowRecord.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}
//消息记录列表
-(void)requestMessageListWithDict:(NSDictionary *)dic
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/queryPushMsg.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dic];
}

////地图大头针搜索楼盘
//-(void)requestPropertiesFromAnnotationSearch:(NSString*)cityID{
//    
//    
//    NSString* urlStr = [NSString stringWithFormat:@"%@/property/getAddressByCityId.do",REQUEST_SERVER_URL];
//    NSDictionary* dict = @{@"districtPId":cityID};
//    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
//    
//}



#pragma mark --添加搜索 推荐记录
- (void)requestSearchRecommentWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/properToken/nSearchRecStages.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}

#pragma mark --二手房下拉列表
- (void)requestTwohandSubTabWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/second/quearyallTerm.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}

#pragma mark --二手房首页列表
- (void)requestTwohandMainTabWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/second/queryAllSecondHouse.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}

#pragma mark --地图大头针搜索楼盘
-(void)requestPropertiesFromAnnotationSearch:(NSString*)cityID
{
    
    
    NSString* urlStr = [NSString stringWithFormat:@"%@/property/getAddressByCityId.do",REQUEST_SERVER_URL];
    NSDictionary* dict = @{@"districtPId":cityID};
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
    
}

#pragma mark --二手房详情页面
- (void)requestTwohandDetailWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/second/SecondHouseDetail.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}

#pragma mark --二手房热门搜索关键词
- (void)requestTwohandSearchHotWord
{
    NSString *url = [NSString stringWithFormat:@"%@/second/hotLabel.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:nil];
}

#pragma mark --二手房搜索
- (void)requestTwohandSearchWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/second/searchSecond.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}

#pragma mark --申请到访记录
- (void)requestVisitHostoryWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/properToken/applyList.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}

#pragma mark --申请到访 选择列表
- (void)requestVisitSelectClientWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/properToken/applyCustomerList.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}

#pragma mark --申请到访 提交申请
- (void)requestVisitSendApplyWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/properToken/saveapplyCustomer1_4.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}

#pragma mark --申请到访 提交申请
- (void)requestSharedSuccessWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/zbp/saveShare.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}

#pragma mark - 邦会个人中心
- (void)requestBHPersonalCenterWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getInfo", BANGHUI_URL];
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/getInfo";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会个人中心关注
- (void)requestBHGuanZhuWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/setFcous", BANGHUI_URL];
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/setFcous";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会个人中心我的粉丝
- (void)requestBHMyFansWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/geyMyFans", BANGHUI_URL];
    
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/geyMyFans";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会个人信息我的关注
- (void)requestBHMyFocusWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/geyMyFocus", BANGHUI_URL];
    
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/geyMyFocus";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会个人信息我的回复
- (void)requestBHReplyWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getMyreply", BANGHUI_URL];
    
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/getMyreply";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会个人信息我的发帖
- (void)requestBHPostsWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getMyposts2", BANGHUI_URL];
    
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/getMyposts";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会左边抽屉的数据
- (void)requestBHLeftDataWith:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getCircle", BANGHUI_URL];
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/getCircle";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会赞过的人的数据
- (void)requestLikeListWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/likeList", BANGHUI_URL];
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/likeList";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会首页列表
- (void)requestBHFirstListWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getIndex2", BANGHUI_URL];
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/getIndex";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会关注的人
- (void)requestBHGuanzhuListWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getFocusPosts2", BANGHUI_URL];
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/getFocusPosts";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会圈子帖子列表
- (void)requestBHCircleListWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getCirclePosts2", BANGHUI_URL];
    
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/getCirclePosts";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会话题列表
- (void)requestBHHuaTiListWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getCirclePosts", BANGHUI_URL];
    
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/getCirclePosts";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会评论列表
- (void)requestBHGongGaoWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/postsComment", BANGHUI_URL];
    
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/postsComment";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会帖子公告话题详情页
- (void)requestBHDetailWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/postsWeb2", BANGHUI_URL];
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/postsWeb";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会搜索好友
- (void)requestBHSeachWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getSearch", BANGHUI_URL];
    //    NSString *url = @" http://192.168.1.199/index.php/Apis/Forum/getSearch";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
}
#pragma mark - 邦会消息
- (void)requestMessageWithDict:(NSDictionary *)dic
{
    
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/getUserPrompt";
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getUserPrompt", BANGHUI_URL];
    
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
    
    
}
#pragma mark - 邦会消息提醒数据
- (void)requestBHMessageWithDic:(NSDictionary *)dic{
    
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getpromptStatus", BANGHUI_URL];

    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
    
}

#pragma mark - 邦会圈子菜单按钮显示与关闭
- (void)requestBHQuanZiShoworHiddenWithDic:(NSDictionary *)dic
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getCircleOff", BANGHUI_URL];
    //    NSString *url = @"http://192.168.1.199/index.php/Apis/Forum/getCircleOff";
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dic];
    
}

#pragma mark -- 帮会搜索人名
-(void)requestBangHuiSearchUsername:(NSDictionary*)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getSearchUser", BANGHUI_URL];

    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}
#pragma mark -- 帮会搜索机构
-(void)requestBangHuiSearchOrgName:(NSDictionary*)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getSearchOrg", BANGHUI_URL];

    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}
#pragma mark -- 帮会搜索帖子
-(void)requestBangHuiSearchContents:(NSDictionary*)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getSearchPosts2", BANGHUI_URL];

    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}
#pragma mark - 邦会首页话题列表
- (void)requestBHListHuaTi:(NSDictionary *)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getHuatiList", BANGHUI_URL];
    
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}

#pragma mark - 邦会首页公告列表
- (void)requestBHListGongGao:(NSDictionary *)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getGonggaoList", BANGHUI_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}
#pragma mark - 邦会首页邦学院列表
- (void)requestBHListBangXueYuan:(NSDictionary *)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getCollegeList", BANGHUI_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}
#pragma mark - 邦会首页列表
- (void)requestBHListTopic:(NSDictionary *)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/Apis/Forum/lists", BANGHUI_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}



- (NSString *)returnBodyStr:(NSDictionary *)dict
{
    NSMutableString *bodyStr = [NSMutableString stringWithFormat:@""];
    for (id dataStr in dict) {
        NSString *headStr = [NSString stringWithFormat:@"&%@=%@",dataStr,dict[dataStr]];
        bodyStr = (NSMutableString *)[bodyStr stringByAppendingString:headStr];
    }
    return bodyStr;
}

#pragma mark -- 积分签到
-(void)requestAwardPointRefereeSignWith:(NSDictionary*)dict
{
    
    NSString *url = [NSString stringWithFormat:@"%@/awardPoint/refereeSign.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}
#pragma mark -- 会员等级
-(void)requestAwardPointQueryAP:(NSDictionary *)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/awardPoint/queryAP.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}

#pragma mark -- 验证码验证接口
-(void)requestVertifyCodeWith:(NSDictionary*)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/referee/checkSmsCode.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}

#pragma mark -- 查询机构码解绑绑定状态
-(void)requestOrgCodeStateWithParam:(NSDictionary*)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/referee/getOrgCode.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}

#pragma mark -- 机构码申请第二步
-(void)requestRefereeBindName:(NSDictionary*)dict
{
    NSString *url = [NSString stringWithFormat:@"%@/referee/bindnameandorgcode.do", REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:url HTTPBodyDict:dict];
}
#pragma mark -- 机构码申请第三步
-(void)requestApplyOrgCode:(NSDictionary*)dict
{
    
    NSString  *urlStr = [NSString stringWithFormat:@"%@/referee/applyOrgCode.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
    
}

#pragma mark -- 申请机构码上传图片
-(void)requestUploadPersonImgWithImage:(UIImage *)image
{
    boundary = @"----------V2ymHFg03ehbqgZCaKO6jy";
    NSString *urlStr = [NSString stringWithFormat:@"%@/upload/uploadImages.do?", REQUEST_SERVER_URL];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    URLRequest *request = [[URLRequest alloc]init];
    [request startAsynchronizePostRequestWithUrlString:urlStr HTTPBodyData:[self prepareBodyDataForUploadWithUIImage:image token:nil user_version:nil] HTTPHeaderField:contentType IsJsonAnalysis:YES];
    [request getReceivedData:^(id data)
     {
         if (_getRequestBlock!=nil)
         {
             _getRequestBlock(data);
         }
     } Fail:^(NSError *error)
     {
         if (_failRequestBlock!=nil)
         {
             _failRequestBlock(error);
         }
     }];
    
}

#pragma mark -- 各板块登录弹出广告接口
-(void)requestLoginAdPresentWithParam:(NSDictionary*)dict
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/login/getAlertForIndex.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
    
}

#pragma mark -- 客户反馈楼盘到销邦
-(void)requestClientRecommandPropertyToSaleHelperWithParam:(NSDictionary*)dict
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/uploadProperty.do?",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
    
}

#pragma  mark -- 销邦申请选择房源接口
-(void)requestAPPlySelectHouseResourceWithParam:(NSDictionary*)dict
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/selecthouse/queryAllhousexb.do",REQUEST_SERVER_URL];

    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
}

#pragma  mark -- 申请签约客户选择的认购房源
-(void)requestApplyClientSignHouseResourceWithParam:(NSDictionary*)dict
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/selecthouse/queryonehouse.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];

}

#pragma mark -- 我的售楼部楼盘数据请求
-(void)requestMySalesCentreBuildingSharedWithParam:(NSDictionary*)dict
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/queryMyRefereeHouse.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
}

#pragma mark -- 我的售楼部选择楼盘分享上传到服务器
-(void)requestMySalesOfficeToShareWithParam:(NSDictionary*)dict
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/setMyRefereeHouse.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
}

#pragma mark -- 我的售楼部楼盘删除操作
-(void)requestMySalesCentreDeleteBuildingWithParam:(NSDictionary*)dict
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/properToken/deleteMyRefereeHouse.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
}
#pragma  mark -- 我的团队
-(void)requestMyTeamDataWithParam:(NSDictionary*)dict
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/oteam/orgteamList.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
}

#pragma  mark -- 我的团队排行榜
-(void)requestMyTeamListDataWithParam:(NSDictionary*)dict
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/oteam/cityteamList.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
}


#pragma mark -- 申请信息详情
-(void)requestApplyInfomationDetailWithParam:(NSDictionary*)dict
{
    NSString  *urlStr = [NSString stringWithFormat:@"%@/setMyRefereeHouse.do",REQUEST_SERVER_URL];
    [self requestPostInterfaceWithUrlString:urlStr HTTPBodyDict:dict];
}


-(void)requestInterfaceWithUrlString:(NSString *)urlString BodyString:(NSString *)bodyString
{
    URLRequest *request = [[URLRequest alloc]init];
    [request startAsynchronizePostRequestWithUrlString:urlString BodyString:bodyString IsJsonAnalysis:YES];
    [request getReceivedData:^(id data)
     {
         if (_getRequestBlock!=nil)
         {
             _getRequestBlock(data);
         }
     } Fail:^(NSError *error)
     {
         if (_failRequestBlock!=nil)
         {
             _failRequestBlock(error);
         }
     }];
    
}


#pragma mark --积分商城
- (void)requestVisitCreditsShopWith:(NSDictionary *)dict
{
    NSString * url;
    if (dict[@"token"] ==nil)
    {
        url = [NSString stringWithFormat:@"%@/awardPoint/loginAwardPointShop.do?uuid=%@",REQUEST_SERVER_URL,dict[@"uuid"]];
    }else{
        url = [NSString stringWithFormat:@"%@/awardPoint/loginAwardPointShop.do?token=%@&redirect%@",REQUEST_SERVER_URL,dict[@"token"],dict[@"redirect"]];
        
    }
    [self requestGetInterfaceWithUrlString:url HTTPBodyDict:dict];
}
@end
