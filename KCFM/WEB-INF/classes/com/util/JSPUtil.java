/** ############################################################### */
/** Program ID   : JSPUtil.java                                     */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package com.util;

import java.io.Reader;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import com.beans.CodeBean;

/**
 * .jsp에서 사용하기 위한 Util모음
 * CommUtil을 사속 받았습니다.
 * 
 * @version 1.0    //Doc Base 주석
 * @author
 * 
 */
public class JSPUtil extends CommUtil 
{

    public static final DecimalFormat dfDate = new DecimalFormat("00");
    public static final DecimalFormat dfWon  = new DecimalFormat("###,##0");

    public static String sID = "";
    
    public static void log(String str)
    {
    	try
    	{
    		System.out.println(logtime() + str);
    	}
    	catch(Exception e)
    	{
    		
    	}
    	
    	return;
    	
    }
    
    public static String logtime() 
    throws Exception
    {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.KOREA);
		return format.format(new Date()) + "-" +sID+"> ";
	}
    
//    /**
//     * 입력된 값으로 Options를 만들어 냅니다.
//     * 입력은 CodeBean의 List만을 받습니다.
//     * 
//     * @param strClassCode (대분류 코드) 예) 'GM_MAIL_SVR'
//     * @param strValue (selected가 찍힐 value를 셋팅합니다.)
//     * @return 옵션들 "<option value="CODE">NAME</option><option value="CODE">NAME</option>"
//     */
//    public static String getOptions(String strClassCode, String  strValue){
//    	CodeDao codeDao = new CodeDao();
//    	try{
//    		return getOptions( codeDao.selectCode(strClassCode), strValue);
//    	}catch(Exception e){
//    		return "";
//    	}
//    }
//
//    /**
//     * 입력된 값으로 Options를 만들어 냅니다.
//     * 입력은 CodeBean의 List만을 받습니다.
//     * 
//     * @param strClassCode (대분류 코드) 예) 'GM_MAIL_SVR'
//     * @param strValue (selected가 찍힐 value를 셋팅합니다.)
//     * @param bCode true  코드 비교 , false는 명칭 비교
//     * @return 옵션들 "<option value="CODE">NAME</option><option value="CODE">NAME</option>"
//     */
//    public static String getOptions(String strClassCode, String  strValue, boolean bCode){
//    	CodeDao codeDao = new CodeDao();
//    	try{
//    		return getOptions( codeDao.selectCode(strClassCode), strValue, bCode);
//    	}catch(Exception e){
//    		return "";
//    	}
//    }
//
//
//    /**
//     * 입력된 값으로 Options를 만들어 냅니다.
//     * 입력은 CodeBean의 List만을 받습니다.
//     * 
//     * 
//     * @param strClassCode (대분류 코드) 예) 'GM_MAIL_SVR'
//     * @param strValue (selected가 찍힐 value를 셋팅합니다.)
//     * @param strWhere WHERE 절 추가.
//     * @param bCode true  코드 비교 , false는 명칭 비교
//     * @return 옵션들 "<option value="CODE">NAME</option><option value="CODE">NAME</option>"
//     */
//    public static String getOptions(String strClassCode, String  strValue, boolean bCode, String strWhere){
//    	CodeDao codeDao = new CodeDao();
//    	try{
//    		return getOptions( codeDao.selectCode(strClassCode, strWhere), strValue, bCode);
//    	}catch(Exception e){
//    		return "";
//    	}
//    }
    
    /**
     * 입력된 값으로 Options를 만들어 냅니다.
     * 입력은 CodeBean의 List만을 받습니다.
     * 
     * @param listData (CodeBean의 List를 입력으로 받습니다.)
     * @param strValue (selected가 찍힐 value를 셋팅합니다.) 
     * @return 옵션들 "<option value="CODE">NAME</option><option value="CODE">NAME</option>"
     */
    public static String getOptions(List listData, String  strValue)
    {
    	
    	String  strRtn = "";
    	CodeBean codeBean = new CodeBean();
    	
    	try
    	{
	    	if( listData == null || listData.size() == 0 ) { return ""; }
	    	
	    	for( int i = 0; i < listData.size(); i++ )
	    	{
	    		codeBean = (CodeBean)listData.get(i);
	    		if( codeBean.getStrCode().equals(strValue) )
	    		{
					strRtn = strRtn + "<option selected value=" + codeBean.getStrCode() + ">" + codeBean.getStrCodeName() + "</options>";
				}
	    		else
	    		{
					strRtn = strRtn + "<option value=" + codeBean.getStrCode() + ">" + codeBean.getStrCodeName() + "</options>";
				}
	    	}
    	}
    	catch(Exception e)
    	{
    		System.out.println("JSPUtil.getOptions Error : " + e.getMessage());
    		strRtn = "";
    	}
    	
    	return strRtn;
    	
    }
    
    /**
     * 입력된 값으로 Options를 만들어 냅니다.
     * 입력은 CodeBean의 List만을 받습니다.
     * 
     * @param listData (CodeBean의 List를 입력으로 받습니다.)
     * @param strValue (selected가 찍힐 value를 셋팅합니다.)
     * @param bCode true  코드 비교 , false는 명칭 비교
     * @return 옵션들 "<option value="CODE">NAME</option><option value="CODE">NAME</option>"
     */
    public static String getOptions(List listData, String  strValue, boolean bCode)
    {
    	
    	String  strRtn = "";
    	CodeBean codeBean = new CodeBean();
    	
    	try
    	{
	    	if( listData == null || listData.size() == 0 ) { return ""; }
	    	
	    	for( int i = 0; i < listData.size(); i++ )
	    	{
	    		codeBean = (CodeBean)listData.get(i);
	    		if( bCode )
	    		{
		    		if( codeBean.getStrCode().equals(strValue) )
		    		{
						strRtn = strRtn + "<option selected value=" + codeBean.getStrCode() + ">" + codeBean.getStrCodeName() + "</options>";
					}
		    		else
		    		{
						strRtn = strRtn + "<option value=" + codeBean.getStrCode() + ">" + codeBean.getStrCodeName() + "</options>";
					}
	    		}
	    		else
	    		{
		    		if( codeBean.getStrCodeName().equalsIgnoreCase(strValue) )
		    		{
						strRtn = strRtn + "<option selected value=" + codeBean.getStrCode() + ">" + codeBean.getStrCodeName() + "</options>";
					}
		    		else
		    		{
						strRtn = strRtn + "<option value=" + codeBean.getStrCode() + ">" + codeBean.getStrCodeName() + "</options>";
					} 
	    		}
	    	}
    	}
    	catch(Exception e)
    	{
    		System.out.println("JSPUtil.getOptions Error : " + e.getMessage());
    		strRtn = "";
    	}
    	
    	return strRtn;
    	
    }

    /**
     * 셀렉트 박스에 들어갈 옵션들을 생성.
     * 
     * @param strFr 시작숫자
     * @param strTo 종료숫자
     * @param strCurrent 현제 숫자 (선택숫자)
     * @param length 길이 4 => "000" 식으로 반환
     * @return 옵션목록 <option></option>
     */
    public static String getOptions(String strFr, String strTo, String strCurrent, int length)
    {
    	
    	int nFr = 0;
    	int nTo = 0;
    	int nCurrent = 0; 
    	
    	nFr = chkNullInt(strFr);
    	nTo = chkNullInt(strTo);
    	nCurrent = chkNullInt(strCurrent);
    	
    	return  getOptions(nFr, nTo, nCurrent, length);
    	
    }
    
    /**
     * 셀렉트 박스에 들어갈 옵션들을 생성.
     * 
     * @param nFr 시작숫자
     * @param nTo 종료숫자
     * @param nCurrent 현제 숫자 (선택숫자)
     * @param length 길이 4 => "000" 식으로 반환
     * @return 옵션목록 <option></option>
     */
	public static String getOptions(int nFr, int nTo, int nCurrent, int length)
	{
		
		String strRtn =  "";
		String strCnt = "";
		int nTemp = 0;
		if( nFr > nTo )  
		{ 
			nTemp = nFr;
			nFr   = nTo;
			nTo   = nTemp;
		}
		
		// make list of Options.
		for( int i = nFr; i <= nTo; i++ )
		{
			strCnt = getLeftFilledString("" + i , "0", length);
			
			if( i == nCurrent )
			{
				strRtn = strRtn + "<option selected value=" + strCnt + ">" + strCnt + "</options>";
			}
			else
			{
				strRtn = strRtn + "<option value=" + strCnt + ">" + strCnt + "</options>";
			}
		}
		
		return strRtn;
		
    }
    
	public static String testUtil()
	{
		
		return "Test OK. (JSPUtil)";
		
	}

    /**
     * replace ' with ''(when db insert/update).
     * @param String source
     * @return String
     * @exception none
     */
    public static String formatSingleQuote(String source) 
    {
    	
        if( source == null || source.trim().length() == 0 ) { return ""; }
		if( source.indexOf("\'") != -1 ) 
		{
			StringBuffer buf = new StringBuffer();
			for( int i = 0; i < source.length(); i++ ) 
			{
				char c = source.charAt(i);
				if( c != '\'') 
				{ 
					buf.append(c);
				} 
				else 
				{
					buf.append("\'\'");
				}
			}
			
			return buf.toString();
		}
		
		return source;
		
    }

    /**
     * return CHECKED when values of two parameters are same
     * (for radio button and check box)
     * @param String value1
     * @param String value2
     * @return String
     * @exception none
     */     
    public static String isChecked(String value1, String value2) 
    {

        if( value1 == null || value2 == null ) { return ""; }

        return value1.equals(value2) ? "CHECKED" : "";
        
    }

    /**
	 * return SELECTED when values of two parameters are same
     * (for listbox)    
     * @param String value1
     * @param String value2
     * @return String
     * @exception none
     */
    public static String isSelected(String value1, String value2) 
    {

        if( value1 == null || value2 == null ) { return ""; }

        return value1.equals(value2) ? "SELECTED" : "";
        
    }

    /**
     * return DISABLED when values of two parameters are same
     * @param String value1
     * @param String value2
     * @return String
     * @exception none
     */
    public static String isDisabled(String value1, String value2) 
    {

        if( value1 == null || value2 == null ) { return ""; }

        return value1.equals(value2) ? "DISABLED" : "";
        
    }

    /**
     * return READONLY when values of two parameters are same
     * @param String value1
     * @param String value2
     * @return String
     * @exception none
     */
    public static String isReadonly(String value1, String value2) 
    {

        if( value1 == null || value2 == null ) { return ""; }

        return value1.equals(value2) ? "READONLY" : "";
        
    }

    /**
     * check whether enctype of HTML form is multipart/form-data type or not
     * @param HttpServletRequest request
     * @return boolean
     * @exception none
     */
	public static boolean isMultipart(HttpServletRequest request) 
	{

		String type = request.getContentType();
		if( type == null || !type.toLowerCase().startsWith("multipart/form-data") ) { return false; }
		
		return true;
		
	}

    /**
     * create <OPTION> tag(년,월,일,시,분 on list box)
     * @param int start - initial value
     * @param int end - final value
     * @param String selected - the value which is expected to be selected
     * @return String
     */
    public static String makeDateListBox(int start, int end, String selected) 
    {

        StringBuffer list = new StringBuffer();
        for( int i = start; i <= end; i++ ) 
        {
            list.append("<OPTION VALUE=\"" + dfDate.format(i) + "\" " +
                        isSelected(dfDate.format(i),selected) + ">" +
                        dfDate.format(i) + "</OPTION>\n");
        }
        
        return list.toString();
        
    }
    
	/**
	 * refine XML data to prevent every class which handles XML from XSLT error
     * @param String source
     * @return String
     * @exception none	 
	 */
	public static String purifyAmp(String source) 
	{
		
		String purifiedXml = "";
		purifiedXml = replace(source, "&", "&amp;");
		
		return purifiedXml;
		
	}
	
	/**
	 * create <random number> 
	 * @param int n
	 * @return
	 */
	public static int randomNumber() 
	{
	
		int n = (int) (Math.random() * 9) + 1;
		
		return n;
		
	}
	
	/**
	 * 입력값을 분해해서 인덱스값을 받음.
	 * CommUtil의 Parser를 이용함.
	 * "-" 으로 딜리미터 고정
	 * 
	 * @param strSrc 입력 문자열 
	 * @param nIndex 인덱
	 * @return
	 */
	public static String getData(String strSrc, int nIndex)
	{
		
		String strTemp = "";
		String strs[];
		
		try
		{
			if( strSrc == null ) { return ""; }
			 
			strs = getParser(strSrc, "-");
			if( strs.length > nIndex )
			{
				strTemp = strs[nIndex];
			}
			else
			{
				strTemp = "";
			}
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage() );
		}
		
		return strTemp;
		
	}

	/**
	 * 입력값을 분해해서 인덱스값을 받음.
	 * CommUtil의 Parser를 이용함.
	 * 입력된 값으로 분리함니다.
	 * 
	 * @param strSrc 입력 문자열 
	 * @param strDil 구분자 
	 * @param nIndex 인덱
	 * @return
	 */
	public static String getData(String strSrc, String strDil, int nIndex)
	{
		
		String strTemp = "";
		String strs[];
		
		try
		{
			if( strDil == null || strSrc == null ) { return ""; }
			
			if( "".equals(strDil) ) { strDil = "-"; }
			
			strs = getParser(strSrc, strDil);
			if( strs.length > nIndex )
			{
				strTemp = strs[nIndex];
			}
			else
			{
				strTemp = "";
			}
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage() );
		}
		
		return strTemp;
		
	}

	/**
	 * 입력값을 길이로 분리해서 인덱스 값을 가져옵니다.<br>
	 * 예) '123456', 3, 0 = '123'<br>
	 *     '123456', 2, 1 = '34'<br>
	 *     
	 * @param strSrc 입력문자열 null은 "" 리
	 * @param nLength 컷팅할 길이 0은 ""만 리턴
	 * @param nIndex 배열의 인덱스
	 * @return 컷팅된값의 인덱스의 스트링
	 */
	public static String getData(String strSrc, int nLength, int nIndex)
	{
		
		String strTemp = "";
		
		try
		{
			if( strSrc == null ) { return ""; }
			if( nLength == 0 ) { return ""; }
			
			if( strSrc.length() >= nLength * (nIndex + 1) ) 
			{
				strTemp = strSrc.substring( nLength  *  (nIndex), nLength  *  (nIndex + 1));
			}
			else
			{
				strTemp = "";
			}
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage() );
		}
		
		return strTemp;
		
	}
	
	 /**
     * <pre>
     * 시스템 날짜를 구한다.
     * <p>
     */
    public static String currentDate(String pattern) 
    {
    	
        return new SimpleDateFormat(pattern, Locale.KOREA).format(new Date());
        
    }
	
	/**
     * <pre>
     * 날짜형("yyyyMMdd") 데이터의 delimiter 추가
     * "20030909"  ==> "2003/09/09"
     * "20030909"  ==> "2003.09.09"
     * </pre>
     *
     * @param date 날짜형 문자열("yyyyMMdd")
     * @param deli 구분자
     *
     * @return 포맷팅된 결과 문자열 ("yyyy?MM?dd")
     * @throws Exception
     */
	public static String stringToDate(String date, String deli) throws Exception 
	{

        String convert = new String();
        if( chkNull(date).equals("") || date.length() != 8 ) { return date; }

        convert = date.substring(0, 4) + deli + date.substring(4, 6) + deli +
                  date.substring(6, 8);

        return convert;
        
    }
	
	/**
     * <pre>
     * 날짜형("yyyyMMdd") 데이터의 delimiter 추가
     * "20030909"  ==> "2003/09/09"
     * "20030909"  ==> "2003.09.09"
     * </pre>
     *
     * @param date 날짜형 문자열("yyyyMMdd")
     * @param deli 구분자
     *
     * @return 포맷팅된 결과 문자열 ("yyyy?MM?dd")
     * @throws Exception
     */
	public static String stringToDate2(String date, String deli) throws Exception 
	{

        String convert = new String();
        if( chkNull(date).equals("") || date.length() != 6 ) { return date; }

        convert = date.substring(0, 2) + deli + date.substring(2, 4) + deli +
                  date.substring(4, 6);

        return convert;
        
    }
	
    /**
     * 현재일을 2자리로 리턴한다.
     *
     * @return String
     */
    static public String getDay() 
    {
    	
        Calendar cal = Calendar.getInstance();
        String day = String.valueOf(cal.get(Calendar.DAY_OF_MONTH));

        if( cal.get(Calendar.DAY_OF_MONTH) < 10)
        {
        	day = "0" + String.valueOf(cal.get(Calendar.DAY_OF_MONTH));
        }
        else
        {
        	day = String.valueOf(cal.get(Calendar.DAY_OF_MONTH));
        }

        return day;
        
    }
    
    /**
     * 현재년도를 4자리로 리턴한다.
     *
     * @return String
     */
    static public String getYear() 
    {
    	
        Calendar cal = Calendar.getInstance();

        return String.valueOf(cal.get(Calendar.YEAR));
        
    }

    /**
     * 현재월을 2자리로 리턴한다.
     *
     * @return String
     */
    static public String getMonth() 
    {
    	
        Calendar cal = Calendar.getInstance();
        String month = String.valueOf(cal.get(Calendar.MONTH) + 1);

        if( (cal.get(Calendar.MONTH) + 1) < 10 )
        {
        	month = "0" + String.valueOf((cal.get(Calendar.MONTH) + 1));
        }
        else
        {
        	month = String.valueOf((cal.get(Calendar.MONTH) + 1));
        }

        return month;
        
    }
    
	public static String makeOptionSelect_day(String selDayStr)
	{
		
		DecimalFormat dformat = new DecimalFormat("00");
		int day = Integer.parseInt(getDay());
		int selDay = 0;
		
		if( selDayStr == null || (selDayStr != null && selDayStr.equals("")) )
		{
			selDay = day;
		}
		else
		{
			selDay = Integer.parseInt(selDayStr);
		}
 
		StringBuffer buf = new StringBuffer();
		for( int i = 1; i < 32; i++ )
		{
			if( selDay == i )
			{
				buf.append("<option value='" + i + "' selected>" + getLeftFilledString(Integer.toString(i), "0", 2) + "</option>");
			} 
			else
			{
				buf.append("<option value='" + i + "'>" + getLeftFilledString(Integer.toString(i), "0", 2) + "</option>");
			}
		} //end-for

		return buf.toString();
		
	}
	
	public static String makeOptionSelect_month(String selMonthStr)
	{
		
		DecimalFormat dformat = new DecimalFormat("00");
		int month = Integer.parseInt(getMonth());
		int selMonth = 0;
		
		if( selMonthStr == null || (selMonthStr != null && selMonthStr.equals("")) )
		{
			selMonth = month;
		}
		else
		{
			selMonth = Integer.parseInt(selMonthStr);
		}
 
		StringBuffer buf = new StringBuffer();
		for( int i = 1; i < 13; i++ )
		{
			if( selMonth == i )
			{
				buf.append("<option value='" + i + "' selected>" + getLeftFilledString(Integer.toString(i), "0", 2) + "</option>");
			}
			else
			{
				buf.append("<option value='" + i + "'>" + getLeftFilledString(Integer.toString(i), "0", 2) + "</option>");
			}
		} //end-for

		return buf.toString();
		
	}
	
	public static String makeOptionSelect_year(String selYearStr, boolean ascending)
	{
		
	    int year = Integer.parseInt(getYear());
	    int selYear = 0;
	        
	    if( selYearStr == null || (selYearStr != null && selYearStr.equals("")) )
	    {
	      	selYear = year;
	    }
	    else
	    {
	       	selYear = Integer.parseInt(selYearStr);
	    }
	        
		int start = 0;
	    StringBuffer buf = new StringBuffer();
	    int curYear = 0;
	    for( int i = start; i < 10; i++ )
	    {
	       	if( ascending == true )
	       	{
	       		curYear = year + (i);
	       	}
	       	else
	       	{
	       		curYear = year - (i);
	       	}
	        	
	        if( selYear == curYear )
	        {
	            buf.append("<option value='" + curYear + "' selected>" + curYear + "</option>");
	        }
	        else
	        {
	            buf.append("<option value='" + curYear + "'>" + curYear + "</option>");
	        }
	    } //end-for

	    return buf.toString();
	        
	 }
	 
	 /**
	 * result를 대문자컬럼명에 컬럼데이터로 HashMap에 넣는다.
	 * @param HashMap
	 * @param ResultSet
	 * @throws Exception
	 */
    public static void resultToHashmap(HashMap result, ResultSet rset) throws Exception 
    {
    	
		try 
		{
			ResultSetMetaData rsmd = rset.getMetaData();
			StringBuffer output	= new StringBuffer();
			Reader input = null;
			char[] buffer = null;
			int byteRead = 0;
			
			for( int i = 0; i < rsmd.getColumnCount(); i++ ) 
			{
				/* CLOB	타입 데이타	Select Start */
				if( rsmd.getColumnTypeName(i+1).equals("CLOB") )
				{ 
					input = rset.getCharacterStream(rsmd.getColumnName(i+1).toUpperCase());
					buffer = new char[1024];
					byteRead = 0;
					if( input != null ) 
					{
						while( (byteRead=input.read(buffer,0,1024)) != -1 )
						{
							output.append(buffer,0,byteRead);
						}
						input.close();
						result.put(rsmd.getColumnName(i+1).toUpperCase(),output.toString());	
					} 
					else 
					{
						result.put(rsmd.getColumnName(i+1).toUpperCase(), "");						
 					}
				}
				else
				{
					result.put(rsmd.getColumnName(i+1).toUpperCase(), (rset.getString(i+1) == null) ? "" : rset.getString(i+1).trim());
				}
			}
		} 
		catch (Exception e) 
		{
			throw e;
		}
		
	}
    
    /**
     * code, name짝으로 이루어진 ArrayList를 받아
     * <option value="_code">_name_</option>의 조합을 String으로 넘긴다.
     * @param list
     * @param selStr
     * @return
     */   
    public static String makeOptionSelect(ArrayList list, String selStr)
    {
    	
        if( list == null || list.size() == 0 ) { return ""; }

        StringBuffer buf = new StringBuffer();     
        HashMap hm = null;
     
        //buf.append("<option value=''>선택</option>");
         
        for( int i = 0; i < list.size(); i++ )
        {
        	hm = (HashMap)list.get(i);
           
	        if( (selStr != null) && (((String)hm.get("CODE")).equals(selStr)) )
	        {
	            buf.append("<option value='" +(String) hm.get("CODE") + "' selected>" +(String) hm.get("NAME") + "</option>");
            }
            else
            {
	            buf.append("<option value='" +  (String) hm.get("CODE") + "'>" +(String) hm.get("NAME")  + "</option>");
            }
        }
        
        return buf.toString();
        
    }
    
    /**
     * 입력된 숫자문자열을 금액표시 형태로 포맷팅 한다. (소숫점 자리 지정)
     *
     * @param str 숫자 문자열
     * @param dpoint 소숫점이하 자리수 ( 허용범위 : 0 ~ 5 )
     *
     * @return 포맷된 금액 문자열
     */
    public static String moneyStr(String str, int dpoint) 
    {
    	
        String dformat = null;
        switch (dpoint) {
        case 0:
            dformat = "###,###,###.###";
            break;
        case 1:
            dformat = "###,###,###,##0.0";
            break;
        case 2:
            dformat = "###,###,###,##0.00";
            break;
        case 3:
            dformat = "###,###,###,##0.000";
            break;
        case 4:
            dformat = "###,###,###,##0.0000";
            break;
        case 5:
            dformat = "###,###,###,##0.00000";
            break;
        default:
            dformat = "###,###,###.###";
            break;
        }

        String temp = null;
        if( str == null || str.trim().equals("") ) 
        {
            temp = "0";
        } 
        else 
        {
            double change = Double.valueOf(str).doubleValue();
            DecimalFormat decimal = new DecimalFormat(dformat);
            temp = decimal.format(change);
        }
        
        return temp;
        
    }
    
    /**
     * 전화번호 자릿수
     * @param text
     * @return
     */
    public static String phoneStr(String text)
    {
    	int textLength = text.length();
    	String textOut ="";

    	if( textLength >= 9 )
    	{
    		int startIndex=0;
    		if( "02".equals(text.substring(0,2)) )
    		{
    			textOut+="02";
    			startIndex+=2;
    		}
    		else
    		{
    			textOut+=text.substring(0,3);
    			startIndex+=3;
    		}
    		textOut+="-"+text.substring(startIndex,textLength-4);
    		textOut+="-"+text.substring(textLength-4,textLength);    
    	}
    	
    	return textOut;
    	
    }
    
    /**
     * 지정한 년월의 마지막일을 얻는다.
     *
     * @param year 년도
     * @param month 월
     *
     * @return 마지막 일자
     */
    public static int getLastDay(int year, int month) 
    {
    	
        int arrDay[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

        if( (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 ) 
        {
            arrDay[1] = 29;
        }
        
        return arrDay[month - 1];
        
    }
    
    /**
     * <pre>
     * 입력한 기준 날짜에 해당하는 요일에 대한 Index 를 리턴한다.
     * 1=일요일,2=월요일,3=화요일,4=수요일,5=목요일,6=금요일,7=토요일
     * </pre>
     *
     * @param date 기준 날짜 ("yyyyMMdd" 포맷)
     *
     * @return 요일 Index 값 ( 1 ~ 7 )
     */
    public static int getDayOfWeekInNumber(String date) 
    {

        int yyyy = Integer.parseInt(date.substring(0, 4));
        int mm = Integer.parseInt(date.substring(4, 6)) - 1;
        int dd = Integer.parseInt(date.substring(6, 8));

        Calendar cal = Calendar.getInstance();
        cal.set(yyyy, mm, dd);

        return cal.get(Calendar.DAY_OF_WEEK);
        
    }
    
    /**
     * 입력된 기준 날짜에 입력된 달을 더했을 때의 날짜를 구한다.
     *
     * @param date 기준 날짜 ("yyyyMMdd" 포맷)
     * @param plusMonths 더해질 달 수
     *
     * @return 계산된 날짜 ("yyyyMMdd" 포맷)
     * @throws Exception
     */
    public static String getAfterMonths(String date, int plusMonths) throws Exception 
    {
    	
        try 
        {
            Calendar tempCal = Calendar.getInstance();
            tempCal.set(Integer.parseInt(date.substring(0, 4)),
                        Integer.parseInt(date.substring(4, 6)) - 1,
                        Integer.parseInt(date.substring(6, 8)));
            tempCal.add(Calendar.MONTH, plusMonths);

            return String.valueOf(tempCal.get(Calendar.YEAR) * 10000 +
                                  (tempCal.get(Calendar.MONTH) + 1) * 100 +
                                  tempCal.get(Calendar.DATE));
        } 
        catch (Exception ex) 
        {
            return "";
        }
        
    }

    /**
     * 카드번호 16자리가 들어온다.
     * @param card_no
     * @return
     * @throws Exception
     */
    public static String toTransCardNo(String card_no) throws Exception 
    {
    	
    	String re_card_no = "";
    	
    	try
    	{
    		if( card_no.length() != 16 ) 
    		{
    			return card_no;
    		} 
    		else 
    		{
    			re_card_no = card_no.substring(0,4)+"-"+card_no.substring(4,8)+"-"+card_no.substring(8,9);
    			re_card_no+= "*"+card_no.substring(10,11)+"*"+"-"+card_no.substring(12,13)+"**"+card_no.substring(15);
    			return re_card_no;
    		}
    	}
    	catch(Exception ex)
    	{
    		return card_no;
    	}
    	
    }
    
    /**
     * <pre>
     * HTML과 관련하여 일부 특수문자를 반환한다.
     *
     * &amp; --->> &amp;amp;
     * &lt; --->> &amp;lt;
     * &gt; --->> &amp;gt;
     * &acute; --->> &amp;acute;
     * &quot; --->> &amp;quot;
     * &brvbar; --->> &amp;brvbar;
     * \n\r --->> <BR>
     * </pre>
     *
     * @param str 원문 문자열
     *
     * @return String
     */
    public static String getSpecialCharacters(String str) 
    {
    	
    	str = replace(str, "&#", "{*$@*}"); //&# 임시변환
        str = replace(str, "&", "&amp;");
        str = replace(str, "{*$@*}", "&#"); //&# 복구

        str = replace(str, "<", "&lt;");
        str = replace(str, ">", "&gt;");
        str = replace(str, "'", "&acute;");
        str = replace(str, "\"", "&quot;");
        str = replace(str, "|", "&brvbar;");

        str = replace(str, "\n", "<BR>");
        str = replace(str, "\r", "");

        return str;
        
    }
    
    /**
     * <pre>
     * HTML과 관련하여 일부 특수문자를 변환한다. (Reverse)
     *
     * &amp;amp;--->> &amp;
     * &amp;lt;--->> &lt;
     * &amp;gt;--->> &gt;
     * &amp;acute;--->> &acute;
     * &amp;quot;--->> &quot;
     * &amp;brvbar;--->> &brvbar;
     * </pre>
     *
     * @param str 원문 문자열
     *
     * @return String
     */
    public static String getReverseSpecialCharacters(String str) 
    {
    	
        str = replace(str, "&amp;", "&");
        str = replace(str, "&lt;", "<");
        str = replace(str, "&gt;", ">");
        str = replace(str, "&acute;", "'");
        str = replace(str, "&quot;", "\"");
        str = replace(str, "&brvbar;", "|");

        str = replace(str, "<BR>", "\n" );
        str = replace(str, "", "\r" );
        
        return str;
        
    }
    
    public static String getDateTime() 
    {
    	
    	String str = "";
        str = 	getDateTimeNow();    	
        
        return str;
        
    }
    
    /* 만 나이 계산 */
    public static int calculateManAge(String ssn)
    {
    	String today = ""; //오늘 날짜
    	int manAge = 0; //만 나이

    	SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");

    	today = formatter.format(new Date()); //시스템 날짜를 가져와서 yyyyMMdd 형태로 변환

    	//today yyyyMMdd
    	int todayYear = Integer.parseInt( today.substring(0, 4) );
    	int todayMonth = Integer.parseInt( today.substring(4, 6) );
    	int todayDay = Integer.parseInt( today.substring(6, 8) );

    	int ssnYear = Integer.parseInt( ssn.substring(0, 4) );
    	int ssnMonth = Integer.parseInt( ssn.substring(4, 6) );
    	int ssnDay = Integer.parseInt( ssn.substring(6, 8) );

    	manAge = todayYear - ssnYear;

    	//생년월일 "월"이 지났는지 체크
    	if( todayMonth < ssnMonth )
    	{ 
    		manAge--;
    	}
    	//생년월일 "일"이 지났는지 체크
    	else if( todayMonth == ssnMonth )
    	{ 
    		if( todayDay < ssnDay )
    		{
    			manAge--; //생일 안지났으면 (만나이 - 1)
    		}
    	}
    	
    	return manAge;
    	
    }
    
    /* JSON value 특수문자 처리 */
    public static String convertJSON(String str)
    {
    	
    	return str.replace("\\", "\\\\")
    			   .replace("\'", "\\\'")
    			   .replace("\"", "\\\"")
    			   .replace("\r\n", "\\n")
                   .replace("\n", "\\n");
    	
    }
    
}