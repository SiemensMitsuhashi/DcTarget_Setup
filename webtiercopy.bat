IF EXIST C:\\Apps\\Siemens\\Teamcenter\\tc_root\\web\\Teamcenter1\\deployment\\tc.war (
	copy /Y C:\\Apps\\Siemens\\Teamcenter\\tc_root\\web\\Teamcenter1\\deployment\\tc.war %CATALINA_BASE%\\webapps
)
IF EXIST C:\\Apps\\Siemens\\Teamcenter\\tc_root\\aws2\\stage\\out\\awc.war (
	copy /Y C:\\Apps\\Siemens\\Teamcenter\\tc_root\\aws2\\stage\\out\\awc.war %CATALINA_BASE%\\webapps
)