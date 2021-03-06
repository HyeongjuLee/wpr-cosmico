<%
    '/* ============================================================================== */
    '/* =   PAGE : 결제 정보 환경 설정 PAGE                                          = */
    '/* = -------------------------------------------------------------------------- = */
    '/* =   Copyright (c)  2010   KICC Inc.   All Rights Reserved.                   = */
    '/* ============================================================================== */


    '/* ============================================================================== */
    '/* =   01. 지불 데이터 셋업 (업체에 맞게 수정)                                  = */
    '/* = -------------------------------------------------------------------------- = */
    '/* = ※ 주의 ※                                                                 = */
    '/* = * cert_file 변수 설정                                                      = */
    '/* = pg_cert.pem 파일의 절대 경로 설정(파일명을 포함한 경로로 설정)             = */
    '/* =                                                                            = */
    '/* = * log_dir 변수 설정                                                        = */
    '/* = log 디렉토리 설정                                                          = */
    '/* = * log_level 변수 설정                                                      = */
    '/* = log 레벨 설정                                                              = */
    '/* = -------------------------------------------------------------------------- = */

    g_cert_file  = "D:\PG\KICCP\"&DKCONF_SITE_PATH&"\cert\pg_cert.pem"
    g_log_dir    = "D:\PG\KICCP\"&DKCONF_SITE_PATH&"\log"
    g_log_level  = 1
	print g_cert_file
    '/* ============================================================================== */
    '/* =   02. 쇼핑몰 지불 정보 설정                                                = */
    '/* = -------------------------------------------------------------------------- = */
    g_gw_url    = PGURL  ' Gateway URL ( gw.easypay.co.kr )
    g_gw_port   = "80"                    ' 포트번호(변경불가) */

    g_mall_id   = PGIDS              ' 리얼 반영시 KICC에 발급된 mall_id 사용
    g_mall_name = DKCONF_SITE_TITLE
    '/* ============================================================================== */
%>