//
//  WMConstants.h
//  Wheelmap
//
//  Created by Michael Thomas on 14.01.13.
//  Copyright (c) 2013 Sozialhelden e.V. All rights reserved.
//

#ifndef Wheelmap_WMConstants_h
#define Wheelmap_WMConstants_h

#define LastRunVersion			@"LastRunVersion"
#define InstallId				@"installId"

#define WheelMapTermsURL		@"http://blog.wheelmap.org/was-ist-wheelmap/terms/"
#define WheelMapDataTermsURL	@"http://blog.wheelmap.org/was-ist-wheelmap/privacy/"

#define FORGOT_PASSWORD_LINK	@"/users/password/new"
#define WEB_LOGIN_LINK			@"/users/auth/osm"
#define WM_REGISTER_LINK		WEB_LOGIN_LINK

#define OSM_URL					@"http://www.openstreetmap.org/"
#define ODBL_URL				@"http://opendatacommons.org/licenses/odbl/"

// WMConfig

#define WM_CONFIG_FILENAME							[[NSBundle mainBundle] objectForInfoDictionaryKey:@"WMConfigFilename"]
#define WM_CONFIG									[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:WM_CONFIG_FILENAME ofType:nil]]

#define K_MBX_TOKEN									WM_CONFIG[@"mbxAccessToken"]
#define K_MBX_MAP_ID								WM_CONFIG[@"mbxMapID"]
#define K_HOCKEY_APP_ID								WM_CONFIG[@"hockeyAppId"]
#define K_API_KEY									WM_CONFIG[@"appAPIKey"]
#define K_API_BASE_URL								WM_CONFIG[@"apiBaseURL"]
#define K_GOOGLE_ANALYTICS_ID						WM_CONFIG[@"googleAnalytics"]
#define K_PROBLEM_REPORT_MAIL						WM_CONFIG[@"problemReportMail"]

// ETags aren't working et the moment. If you enable ist, please check if they are sent valid from the backend
#define K_USE_ETAGS				NO

#define K_UD_INTRO_ALREADY_SEEN						@"introAlreadySeen"

#define K_UD_POI_WHEELCHAIR_STATE_YES_KEY			@"WheelchairFilterStatusYes"
#define K_UD_POI_WHEELCHAIR_STATE_LIMITED_KEY		@"WheelchairFilterStatusLimited"
#define K_UD_POI_WHEELCHAIR_STATE_NO_KEY			@"WheelchairFilterStatusNo"
#define K_UD_POI_WHEELCHAIR_STATE_UNKNOWN_KEY		@"WheelchairFilterStatusUnkown"

#define K_UD_POI_TOILET_STATE_YES_KEY				@"ToiletFilterStatusYes"
#define K_UD_POI_TOILET_STATE_LIMITED_KEY			@"ToiletFilterStatusLimited"
#define K_UD_POI_TOILET_STATE_NO_KEY				@"ToiletFilterStatusNo"
#define K_UD_POI_TOILET_STATE_UNKNOWN_KEY			@"ToiletFilterStatusUknown"

#define K_POPOVER_VIEW_WIDTH						320.0f
#define K_POPOVER_VIEW_HEIGHT						547.0f

#define K_NAVIGATION_BAR_HEIGHT						44.0f
#define K_NAVIGATION_BAR_SEARCH_OFFSET				5.0f

#define K_TOOLBAR_BAR_HEIGHT						49.0f
#define K_TOOLBAR_BUTTONS_WITH						58.0f
#define K_TOOLBAR_TOOGLE_BUTTON_OFFSET				5.0f

#define K_POI_STATE_FILTER_BUTTON_DOTS_WIDTH		6.0f
#define K_POI_STATE_FILTER_BUTTON_DOTS_X_OFFSET		2.0f

#define K_POI_STATUS_FILTER_POPOVER_VIEW_HEIGHT		65.0f
#define K_POI_STATUS_FILTER_POPOVER_BUTTON_WIDTH	50.0f
#define K_POI_STATUS_FILTER_POPOVER_MARKER_X_OFFSET	32.0f

#define K_TOOLBAR_WHEELCHAIR_STATUS_OFFSET			4.0f

#define K_ANIMATION_DURATION_SHORT					0.3f

#define K_REPORT_BOTTOM_MARGIN						20

#define K_DEFAULT_LATITUDE							52.513
#define K_DEFAULT_LONGITUDE							13.388

#define K_REGION_LONGITUDE							120
#define K_REGION_LATITUDE							100

#define K_BYTES_PREFFIX_DIVISION					1024.0

#define K_DATA_KEY_ETAGS							@"eTags"

#define K_DB_KEY_CATEGORY_LOCALIZED_NAME			@"localized_name"

#define K_STATE_UNKNOWN								@"unknown"
#define K_STATE_LIMITED								@"limited"
#define K_STATE_YES									@"yes"
#define K_STATE_NO									@"no"

#define K_POIS_LIST_TABLE_VIEW_CELL_IDENTIFIER		@"WMPOIsListTableViewCell"
#define K_POI_DETAIL_GALLERY_BUTTON_CELL_IDENTIFIER	@"galleryButtonCell"
#define K_POI_DETAIL_GALLERY_IMAGE_CELL_IDENTIFIER	@"galleryImageCell"
#define K_CATEGORY_FILTER_CELL						@"categoryFilterCell"

#define K_MAIL_TEMPLATE_FILE						[[NSBundle mainBundle] pathForResource:@"ProblemMailTemplate" ofType:@"html"]
#define K_MAIL_TEMPLATE_TEXT						[NSString stringWithContentsOfFile:K_MAIL_TEMPLATE_FILE encoding:NSUTF8StringEncoding error:nil]
#define K_MAIL_FIELD_DESCRIPTION					@"USER_DESCRIPTION"
#define K_MAIL_FIELD_DATA_TITLE						@"DATA_TITLE"
#define K_MAIL_FIELD_APP_VERSION					@"APP_VERSION_TITLE"
#define K_MAIL_FIELD_APP_VERSION_VALUE				@"APP_VERSION_VALUE"
#define K_MAIL_FIELD_USER							@"USER_TITLE"
#define K_MAIL_FIELD_USER_VALUE						@"USER_VALUE"
#define K_MAIL_FIELD_IOS_VERSION					@"IOS_VERSION_TITLE"
#define K_MAIL_FIELD_IOS_VERSION_VALUE				@"IOS_VERSION_VALUE"
#define K_MAIL_FIELD_FREE_SPACE						@"FREE_SPACE_TITLE"
#define K_MAIL_FIELD_FREE_SPACE_VALUE				@"FREE_SPACE_VALUE"
#define K_MAIL_FIELD_GPS							@"GPS_TITLE"
#define K_MAIL_FIELD_GPS_VALUE						@"GPS_VALUE"

#define DEFAULT_SEARCH_SPAN_LAT 					0.005
#define DEFAULT_SEARCH_SPAN_LONG 					0.006

#define NODE_INDEX_GAP								2

typedef enum {
	kDotTypeYes,
	kDotTypeLimited,
	kDotTypeNo,
	kDotTypeUnknown
} DotType;

typedef enum {
	kWMPOIsListViewControllerUseCaseNormal,
	kWMPOIsListViewControllerUseCaseGlobalSearch,
	kWMPOIsListViewControllerUseCaseSearchOnDemand,
	kWMPOIsListViewControllerUseCaseContribute,
	kWMPOIsListViewControllerUseCaseCategory
} WMPOIsListViewControllerUseCase;

typedef enum {
	WMEditPOIStateUseCasePOICreation,
	WMEditPOIStateUseCasePOIUpdate
} WMEditPOIStateUseCase;

typedef enum {
	WMPOIStateTypeWheelchair,
	WMPOIStateTypeToilet
} WMPOIStateType;

typedef enum {
	kWMNavigationBarLeftButtonStyleDashboardButton,
	kWMNavigationBarLeftButtonStyleBackButton,
	kWMNavigationBarLeftButtonStyleCancelButton,
	kWMNavigationBarLeftButtonStyleNone
} WMNavigationBarLeftButtonStyle;

typedef enum {
	kWMNavigationBarRightButtonStyleCreatePOIButton,
	kWMNavigationBarRightButtonStyleEditButton,
	kWMNavigationBarRightButtonStyleSaveButton,
	kWMNavigationBarRightButtonStyleCancelButton,
	kWMNavigationBarRightButtonStyleNone
} WMNavigationBarRightButtonStyle;

#endif
