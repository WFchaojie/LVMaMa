//
//  Network.h
//  LVMaMa
//
//  Created by 武超杰 on 15/11/8.
//  Copyright © 2015年 LVmama. All rights reserved.
//

#ifndef Network_h
#define Network_h

#define ADURL @"http://m.lvmama.com/bullet/index.php?s=/Api/getBootScreen&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"
//限时抢购
#define LIMITBJ @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=NSY&tagCodes=NSY_MS&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.07992241&globalLongitude=116.39527007&debug=false&format=json"
#define HOT_WORD_SEARCH @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=SY&tagCodes=SY_RMSS&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.1&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08166971&globalLongitude=116.39560973&debug=false&format=json"

#define LIMIT_MORE @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getHotCollections&version=2.0.0&page=%d&pageSize=10&stationName=%%E5%%8C%%97%%E4%%BA%%AC&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08144871&globalLongitude=116.39561624&debug=false&format=json"

#define LIMIT_INFO @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getGroupbuyOrSecKillDetail&version=1.0.0&productId=%@&suppGoodsId=%@&branchType=%@&fromPlaceId=1&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08150284&globalLongitude=116.39547618&debug=false&format=json"

#define LIMIT_INFO_COMMENT @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.cmt.getCmtCommentList&version=1.0.0&currentPage=1&isELong=N&pageSize=10&productId=%@&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=8e60ae86-701f-4a7b-99c3-fae5ecf54118&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08149594&globalLongitude=116.39566856&debug=false&format=json"

//用户输入的搜索词语
#define USER_SEARCH_WORD @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.home.homeSearch&version=1.0.0&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.1&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08166971&globalLongitude=116.39560973&debug=false&format=json"
//驴悦亲子

#define ACTIVITY @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=NSY&tagCodes=NSY_ACTION_L,NSY_ACTION_R,TJHD&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"

//景点邮票及按钮
#define BUTTONURL @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=NSY&tagCodes=NSY_BA,NSY_SA&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"
//顶部滚动视图
#define SCROLLURL @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=NSY&tagCodes=NSY_BANNER&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"
//小编推荐

#define RECOMMENDBJ @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=JDMP&tagCodes=XBTJ&page=1&pageSize=10&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08075070&globalLongitude=116.39528103&debug=false&format=json"

//主题
#define TICKET_TOPIC @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=JDMP&tagCodes=ZTSS&checkVersion=True&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.1&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08165768&globalLongitude=116.39561650&debug=false&format=json"
//景点门票顶部滚动视图
#define BUTTONINFOTOP @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=JDMP&tagCodes=JDMP_BANNER&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08075070&globalLongitude=116.39528103&debug=false&format=json"
#define BUTTONINFOACTIVITY @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=JDMP&tagCodes=TJHD&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08075070&globalLongitude=116.39528103&debug=false&format=json"
//热词搜索
#define HOTWORD @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=JDMP&tagCodes=JDMP_RMDJ&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08075070&globalLongitude=116.39528103&debug=false&format=json"

//度周末度长假
#define INFOURL @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=NSY&tagCodes=NSY_ZM,NSY_CJ&page=%d&pageSize=6&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"
//按主题查找
#define TOPICSEARCH @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=JDMP&tagCodes=ZTSS&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08075070&globalLongitude=116.39528103&debug=false&format=json"
//用户点评
#define USER_COMMENT @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.comment.getCmtComment&version=1.0.0&objectId=%@&objectType=ROUTE&page=1&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.1&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"
//限时抢购
#define LiMiTURL @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=SH&channelCode=NSY&tagCodes=NSY_MS&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"

#define TOURTOPURL @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.client.focus&version=1.0.0&objectType=trip&objectId=index&identity=tripfocus&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08167249&globalLongitude=116.39552913&debug=false&format=json"

#define TOURRECORD @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.note.hot&version=1.0.0&pageIndex=%d&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08167249&globalLongitude=116.39552913&debug=false&format=json"

#define TOURDestinationTop @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.client.focus&version=1.0.0&objectType=lvyou&objectId=index&identity=trip_dest_focus&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08167249&globalLongitude=116.39552913&debug=false&format=json"

#define TOURDestinationINFOURL @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.client.hotdests&version=1.0.0&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08167249&globalLongitude=116.39552913&debug=false&format=json"

#define NearBy @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.search.searchHotel&version=1.0.0&arrivalDate=2015-06-05&departureDate=2015-06-06&pLatitude=40.080570&pLongitude=116.395264&pRadius=10&pageIndex=%d&pageSize=20&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08057118&globalLongitude=116.39526491&debug=false&format=json"

#define NearBy2 @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.search.searchHotel&version=2.0.0&arrivalDate=2015-10-12&departureDate=2015-10-13&distance=10&hotelStar=104,105,102,103,100,101&latitude=40.081421&longitude=116.395546&pageIndex=%d&pageSize=20&uuid=CEE6A27B-891D-425F-A528-680533ADC502&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.3.1&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08141940&globalLongitude=116.39554806&debug=false&format=json&lvkey=3021d298de173586290542c4386127b2"


//首页周边游cell
#define NEAR_BUTTON_INFO @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=ZBY&tagCodes=XL_TJ&page=%d&pageSize=6&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08159382&globalLongitude=116.39546967&debug=false&format=json"
//周边热门推荐
#define NEAR_RECOMMEND @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=ZBY&tagCodes=PDSS&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08159382&globalLongitude=116.39546967&debug=false&format=json"
//
#define NEAR_BANNER @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=ZBY&tagCodes=XL_BANNER&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08159382&globalLongitude=116.39546967&debug=false&format=json"

#define NEAR_ACTIVITY @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=ZBY&tagCodes=TJHD&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08159382&globalLongitude=116.39546967&debug=false&format=json"
//特卖产品
#define DOMESTIC_SPECIALACTIVITY @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=GNY&tagCodes=TMCP&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.5&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08167122&globalLongitude=116.39561650&debug=false&format=json"

#define DOMESTIC_BANNER @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=GNY&tagCodes=XL_BANNER&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.5&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08167122&globalLongitude=116.39561650&debug=false&format=json"



//特卖产品详情 382631
#define DOMESTIC_SPECIAL_DETAIL @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getGroupbuyOrSecKillDetail&version=1.0.0&productId=%@&suppGoodsId=%@&branchType=PROD&fromPlaceId=0&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.1&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"

//热门搜索
#define DOMESTIC_HOTACTIVITY @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=GNY&tagCodes=TJHD&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.5&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08167122&globalLongitude=116.39561650&debug=false&format=json"
//cell
#define DOMESTIC_CELL @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=GNY&tagCodes=XL_TJ&page=%d&pageSize=6&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.5&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08167122&globalLongitude=116.39561650&debug=false&format=json"

#define ABROAD_HOT @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=CJY&tagCodes=PDSS&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164641&globalLongitude=116.39553666&debug=false&format=json"
#define ABROAD_BANNER @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=CJY&tagCodes=XL_BANNER&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164641&globalLongitude=116.39553666&debug=false&format=json"
#define ABROAD_SPECIAL @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=CJY&tagCodes=TMCP&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164641&globalLongitude=116.39553666&debug=false&format=json"
#define ABROAD_ACTIVITY @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=CJY&tagCodes=TJHD&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164641&globalLongitude=116.39553666&debug=false&format=json"

#define ABROAD_CELL @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=CJY&tagCodes=XL_TJ&page=%d&pageSize=6&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164641&globalLongitude=116.39553666&debug=false&format=json"

#define SHIP_BANNER @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=YL&tagCodes=YL_BANNER&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164641&globalLongitude=116.39553666&debug=false&format=json"

#define SHIP_LINE @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=YL&tagCodes=YL_HX&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164641&globalLongitude=116.39553666&debug=false&format=json"

#define SHIP_COMPANY @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=YL&tagCodes=YL_GS&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164641&globalLongitude=116.39553666&debug=false&format=json"
//邮轮推荐
#define SHIP_CELL @"http://m.lvmama.com/bullet/index.php?s=/Api/getInfos&stationCode=BJ&channelCode=YL&tagCodes=YL_TJ&page=%d&pageSize=6&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164641&globalLongitude=116.39553666&debug=false&format=json"
//火车票
#define TRAIN @"http://m.lvmama.com/train/?udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164014&globalLongitude=116.39553297&debug=false&format=json"
//定制游
#define HOME_TOUR @"http://m.lvmama.com/company/?udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164629&globalLongitude=116.39553569&debug=false&format=json"

#define HOME_TEP @"http://zt1.lvmama.com/main/templateb/298?udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08104841&globalLongitude=116.39512300&debug=false&format=json"
//自驾游
#define HOME_TRIP_MYSLEF  @"http://zt1.lvmama.com/main/templateb/212?udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08104841&globalLongitude=116.39512300&debug=false&format=json"

#define HOME_SUMMER @"http://zt1.lvmama.com/main/templateb/319?udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164474&globalLongitude=116.39553494&debug=false&format=json"
//驴悦亲子
#define HOME_ACTIVITY @"http://m.lvmama.com/lvyue/?udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08164474&globalLongitude=116.39553494&debug=false&format=json"
//特卖会
#define HOME_SALE @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getGroupbuyIndex&version=1.0.0&stationCode=BJ&stationName=%E5%8C%97%E4%BA%AC&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"
//一元门票
#define HOME_ONE_PRICE @"http://zt1.lvmama.com/main/yiyuantemplate/51?v=1234&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08101384&globalLongitude=116.39509922&debug=false&format=json"
//秒杀详情
#define HOME_KILL_DETAIL @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getGroupbuyOrSecKillDetail&version=1.0.0&productId=442073&suppGoodsId=442073&branchType=PROD&fromPlaceId=0&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08100893&globalLongitude=116.39509584&debug=false&format=json"
//爆款
#define HONE_HOT_PRODUCT @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getHotCollections&version=1.0.0&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08100893&globalLongitude=116.39509584&debug=false&format=json"

#define HOME_CELL_INFO @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.ticket.product.getDetails&version=1.0.0&productId=%@&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08100893&globalLongitude=116.39509584&debug=false&format=json"

//主页票
#define HOME_CELL_TICKET @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.ticket.goods.getGoods&version=2.0.0&productId=%@&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08100893&globalLongitude=116.39509584&debug=false&format=json"

//主页点评
#define HOME_CELL_COMMENT @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.comment.getCmtComment&version=1.0.0&objectId=%@&objectType=PLACE&page=1&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08100893&globalLongitude=116.39509584&debug=false&format=json"

#define TOUR_RECORD_DETAIL @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.note.details&version=1.0.0&tripId=%@&userNo=(null)&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08159377&globalLongitude=116.39547157&debug=false&format=json"

//国内目的地选择
#define IN_LAND_AREA @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.client.areadests&version=1.0.0&objectType=in_land_area&pageIndex=1&pageSize=15&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08149382&globalLongitude=116.39556509&debug=false&format=json"

#define OUT_LAND_AREA @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.client.areadests&version=1.0.0&objectType=out_land_area&pageIndex=1&pageSize=15&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08149382&globalLongitude=116.39556509&debug=false&format=json"

//照片墙
#define TOUR_PHOTO @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.dest.pic&version=1.0.0&destId=3735&pageIndex=1&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08168587&globalLongitude=116.39551890&debug=false&format=json"
//游记
#define TOUR_TEXT @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.dest.note&version=1.0.0&destId=%@&pageIndex=1&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08168587&globalLongitude=116.39551890&debug=false&format=json"
//简介
#define TOUR_SHOW @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.dest.details&version=1.0.0&destId=%@&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08168587&globalLongitude=116.39551890&debug=false&format=json"
//点评
#define TOUR_COMMENT @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.dest.comments&version=1.0.0&destId=%@&pageIndex=1&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.0&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08168587&globalLongitude=116.39551890&debug=false&format=json"
//评论游记
#define TOUR_RECORD_COMMENT @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.comment.list&version=1.0.0&objectType=trip&tripId=%@&pageIndex=%d&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.0.1&osVersion=8.1.2&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08166524&globalLongitude=116.39560744&debug=false&format=json"
#define PRODUCT_URL @"https://api.weibo.com/2/short_url/shorten.json?source=87692682&url_long=http://m.lvmama.com/download?ch=fenxiang&url_long=http://m.lvmama.com/clutter/product/%@/?lvfrom=VST"
#define WIDTH 8

//特卖会借口接口
#define PINDAO_AROUND @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getArroundIndexList&version=2.0.0&stationName=%E5%8C%97%E4%BA%AC&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"

#define PINDAO_CHINA @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getChinaIndexList&version=2.0.0&stationName=%E5%8C%97%E4%BA%AC&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"

#define PINDAO_ABROAD @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getAbroadIndexList&version=2.0.0&stationName=%E5%8C%97%E4%BA%AC&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"

#define PINDAO_TICKET @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getTicketIndexList&version=2.0.0&stationName=%E5%8C%97%E4%BA%AC&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"

#define PINDAO_SHIP @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getShipIndexList&version=2.0.0&stationName=%E5%8C%97%E4%BA%AC&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"

#define PINDAO_GROUP @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getGroupbuyIndex&version=2.0.0&stationName=%E5%8C%97%E4%BA%AC&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"

#define PINDAO_GROUP_MORE @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.groupbuy.getHotCollections&version=2.0.0&page=1&pageSize=10&stationName=%E5%8C%97%E4%BA%AC&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.1.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=&globalLongitude=&debug=false&format=json"

#define COMMENT_URL @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.cmt.getCmtCommentList&version=1.0.0&currentPage=%d&isELong=N&pageSize=10&placeIdType=PLACE&productId=172316&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08153262&globalLongitude=116.39570631&debug=false&format=json"

#define NEAR_HEAE_URL @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.product.getProductDetail&version=1.0.0&arrivalDate=2015-09-18&departureDate=2015-09-19&productId=70847&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08150985&globalLongitude=116.39567161&debug=false&format=json"

#define NEAR_CELL_URL @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.goods.getGoodsList&version=2.0.0&arrivalDate=2015-09-18&departureDate=2015-09-19&onlineFlag=Y&pageIndex=1&pageSize=50&productId=70847&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08150985&globalLongitude=116.39567161&debug=false&format=json"

#define NEAR_CELL_URL2 @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.search.searchHotel&version=2.0.0&arrivalDate=2015-10-15&departureDate=2015-10-16&distance=10&hotelStar=104,105,102,103,100,101&latitude=40.081390&longitude=116.395737&pageIndex=1&pageSize=20&uuid=85F879E1-5784-4352-A65B-FE0E7FEB8481&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.3.1&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08134239&globalLongitude=116.39581741&debug=false&format=json&lvkey=2ba03af4aeaef33d3189d037705f8de0"

//自由行
#define TOUR_RECOMMEND_FREE @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.note.products&version=1.0.0&destId=206835&fromDest=%%E5%%8C%%97%%E4%%BA%%AC&destName=%%E6%%96%%B0%%E5%%8C%%97%%E5%%B8%%82&productType=FREETOUR&pageIndex=%d&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08150985&globalLongitude=116.39567161&debug=false&format=json"

//跟团游
#define TOUR_GROUP @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.note.products&version=1.0.0&destId=206835&fromDest=%%E5%%8C%%97%%E4%%BA%%AC&destName=%%E6%%96%%B0%%E5%%8C%%97%%E5%%B8%%82&productType=ROUTE&pageIndex=%d&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08150985&globalLongitude=116.39567161&debug=false&format=json"

//景点门票
#define TOUR_TICKET @"http://api3g2.lvmama.com/trip/router/rest.do?method=api.com.trip.note.products&version=1.0.0&destId=206835&fromDest=%%E5%%8C%%97%%E4%%BA%%AC&destName=%%E6%%96%%B0%%E5%%8C%%97%%E5%%B8%%82&productType=TICKET&pageIndex=%d&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08150985&globalLongitude=116.39567161&debug=false&format=json"

//产品详情
#define PRODUCT_INFO @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.route.product.getRouteDetails&version=1.0.0&productId=%d&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08155639&globalLongitude=116.39569071&debug=false&format=json"

//产品评论
#define PRODUCT_COMMENT @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.cmt.getCmtCommentList&version=1.0.0&productId=%d&currentPage=1&pageSize=10&isELong=N&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.2.0&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08155639&globalLongitude=116.39569071&debug=false&format=json"

//周边banner
#define NEAR_DETAIL_BANNER @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.product.getProductDetail&version=1.0.0&arrivalDate=2015-10-10&departureDate=2015-10-11&productId=%@&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.3.1&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08144069&globalLongitude=116.39561515&debug=false&format=json&lvkey=925fc8c16589cd8df0b963bc5a8a1196"

#define NEAR_DETAIL_BANNER2 @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.product.getProductDetail&version=1.0.0&arrivalDate=2015-10-15&departureDate=2015-10-16&productId=%@&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.3.1&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08138923&globalLongitude=116.39573391&debug=false&format=json&lvkey=d8ea448a7c85d61fe5f74f2e7d618d80"//http://api3g2.lvmama.com/api/router/rest.do?method=api.com.product.getProductDetail&version=1.0.0&arrivalDate=2015-10-15&departureDate=2015-10-16&productId=70847&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.3.1&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08138923&globalLongitude=116.39573391&debug=false&format=json&lvkey=d8ea448a7c85d61fe5f74f2e7d618d80

//周边cell
#define NEAR_CELL @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.goods.getGoodsList&version=2.0.0&arrivalDate=2015-10-10&departureDate=2015-10-11&onlineFlag=Y&pageIndex=%d&pageSize=50&productId=%@&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.3.1&osVersion=8.4&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08144069&globalLongitude=116.39561515&debug=false&format=json&lvkey=525d313ddd7d1162048a2676c46392bf"

//地图的接口
#define MAP @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.search.searchHotel&version=2.0.0&arrivalDate=2015-11-22&departureDate=2015-11-23&distance=10&hotelStar=104,105,102,103,100,101&latitude=40.081448&longitude=116.395737&pageIndex=1&pageSize=20&uuid=827DE15A-D8D0-421B-88BA-1552E380A395&udid=9a15896e-ffed-4e28-908f-7fdd282a2a68-uuid&lvsessionid=&firstChannel=IPHONE&secondChannel=APPSTORE&lvversion=7.3.2&osVersion=9.1&deviceName=iPhone7,1&netWorkType=46001&globalLatitude=40.08144597&globalLongitude=116.39573683&debug=false&format=json&lvkey=ef1fc565c301d7ef8b596e0a050179cb"

#endif /* Network_h */
