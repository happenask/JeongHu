/** ############################################################### */
/** Program ID   : CommUtil.java                                    */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package com.util;

import java.util.*; 
import java.lang.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.*;

import javax.servlet.http.HttpServletRequest;

/**
 * 데이터베이스에 접속하기 위한 클래스
 * @version 1.0    //Doc Base 주석
 * @author  
 * 
 */
public class CommUtil  
{
	
	public static String testUtil()
	{
		return "Test OK. (CommUtil)";
	}
	
	public static String testUtil2()
	{
		return "Test OK. (CommUtil)";
	}

    //입력시
    public static synchronized String cnvti(String inputStr) 
    {
    	
        try 
        {
        	String newChar;

			if( (inputStr == null) || (inputStr.length() == 0) ) 
			{
            	newChar = "";
			} 
			else 
			{
				newChar = new String(inputStr.getBytes("8859_1"),"euc-kr");
			}
			
			return newChar.trim();
        } 
        catch (Exception e) 
        {
        	return "";
        }
        
    }
    
    //조회시
    public static synchronized String cnvts(String inputStr) 
    {
    	
    	try 
    	{
    		String newChar;

			if( (inputStr == null) || (inputStr.length() == 0) ) 
			{
				newChar = "";
			} 
			else 
			{
				newChar = new String(inputStr.getBytes("euc-kr"),"8859_1");
			}
			
			return newChar.trim();
    	} 
    	catch (Exception e) 
    	{
    		return "";
        }
    	
    }
    
	/**
	 * 난수발생
	 * @return long형의 난수를 발생함.
	 */
	public static String getRandom()
	{
		
		Random rnd = new Random();
		long lngRnd = rnd.nextLong();
		
		return "" + lngRnd;
		
	}

	/**
	 * 인코딩을 한글로 변환해 줍니다.
	 * @param value  
	 * @return
	 */
    public static boolean isKo(String value)
    {
    	
        if( value == null ) { return false; }
        
        value = value.trim();
        String toEng = null;
        
        try
        {
            toEng = (new String(value.getBytes("8859_1"))).trim();
            byte temp[] = toEng.getBytes("8859_1");
            return value.length() == temp.length;
        }
        catch(Exception e)
        {
            return false;
        }
        
    }

    public static String ko(String value)
    {
    	
        String ko = null;
        
        try
        {
            if( isKo(value) )
            {
                ko = value;
            }
            else
            {
                ko = new String(value.getBytes("8859_1"), "KSC5601");
            }
        }
        catch(Exception exception) 
        { 
        	
        }
        
        return ko;
        
    }

    public static boolean isModified(String fileName, long lastModified) throws Exception
    {
    	
        boolean needUpdate = false;
        File file = new File(fileName);
        
        if( !file.canRead() ) { throw new Exception("Util Can't open file: " + fileName); }
        if( lastModified != file.lastModified() ) { needUpdate = true; }
        
        return needUpdate;
        
    }

    public static long getModified(String fileName)
    {
    	
        File file = new File(fileName);
        
        return file.lastModified();
        
    }

    public static String readFile(String path)
    {
    	
        StringBuffer sb = new StringBuffer();
        
        try
        {
            FileInputStream fis = new FileInputStream(path);
            int n;
            while((n = fis.available()) > 0) 
            {
                byte b[] = new byte[n];
                if( fis.read(b) == -1 ) { break; }
                sb.append(new String(b));
            }
            fis.close();
        }
        catch(FileNotFoundException e)
        {
            System.err.println("Could not find file " + path);
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }
        
        return sb.toString();
        
    }

    public static void writeFile(String path, String contents)
    {
    	
        try
        {
            File file = new File(path);
            FileWriter fw = new FileWriter(file);
            fw.write(contents);
            fw.close();
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }
        
    }
    
	/***************************************************************************
	 * 한글 인코딩 함수
	 **************************************************************************/
    public static String toKor(String str) 
    {
    	
		return toKorean(str);
		
	}
    
    public static String toKorean(String str) 
    {
    	
        String rtn = null;
        
        try 
        {
            if( str != null ) 
            {
                if( isKo(str) )
                {
                	rtn = str;
                }
                else
                {
                	rtn = new String(str.getBytes("Cp1252"), "EUC_KR");
                }
            }
        } 
        catch (java.io.UnsupportedEncodingException e) 
        {
        	
        }
        
        return rtn;
        
    }

	/***************************************************************************
	 * 한글 디코딩 함수 한글인코딩의 역순
	 **************************************************************************/
    public static String toEng(String str) 
    {
    	
		return toEnglish(str);
		
	}
    
    public static String toEnglish(String str) 
    {
    	
        String rtn = null;
        
        try 
        {
            if( str != null ) 
            { 
                if( isKo(str) )
                {
                	rtn = new String(str.getBytes("EUC_KR"), "Cp1252");
                }
                else
                {
                	rtn = str;
                }    
            }
        } 
        catch (java.io.UnsupportedEncodingException e) 
        {
        	
        }
        
        return rtn;
        
    }

	/** 
	 * @return 당해년도 4자리. 
	 */
	public static String getYear()
   	{
		
		Calendar calCurrentTime = Calendar.getInstance();
		String datetemp = new String();
		datetemp = Integer.toString(calCurrentTime.get(Calendar.YEAR));
		  
		return datetemp;
		
	}

	/** 
	 * @param int 가감 년도
	 * @return 년도 4자리 ( 년단위 계산 ) 
	 */
	public static String getYear_Cal( int intTemp )
   	{
		
		Calendar calCurrentTime = Calendar.getInstance();
		String datetemp = new String();
		datetemp = Integer.toString( calCurrentTime.get(Calendar.YEAR) +  intTemp );
		   
		return datetemp;
		
	}

	/** 
	 * @return 당월 2자리 
	 */
	public static String getMonth()
   	{
		
		Calendar calCurrentTime = Calendar.getInstance();
		String datetemp = new String();
		datetemp = Integer.toString(calCurrentTime.get(Calendar.YEAR)) + cvtOneToTwo((calCurrentTime.get(Calendar.MONTH)+1));
		  
		return datetemp;
		
	}

	/** 
	 * @return 당일 YYYYMMDD
	 */
	public static String getDate()
   	{
		
		Calendar calCurrentTime = Calendar.getInstance();
		String datetemp = new String();
		datetemp = Integer.toString(calCurrentTime.get(Calendar.YEAR)) + cvtOneToTwo((calCurrentTime.get(Calendar.MONTH)+1)) + cvtOneToTwo(calCurrentTime.get(Calendar.DAY_OF_MONTH));
		  
		return datetemp;
		
	}

	/** 
	 * @return 당일 YYYY-MM-DD
	 */
	public static String getDateHypen()
   	{
		
		Calendar calCurrentTime = Calendar.getInstance();
		String datetemp = new String();
		datetemp = Integer.toString(calCurrentTime.get(Calendar.YEAR)) + "-" + cvtOneToTwo((calCurrentTime.get(Calendar.MONTH)+1)) + "-" + cvtOneToTwo(calCurrentTime.get(Calendar.DAY_OF_MONTH));

		return datetemp;
		
	} 

	/** 
	 * @return 현재시간 HH:MM:SS
	 */
	public static String getTimeFormat(String str)
   	{
		
		String datetemp = "";
		if( str == null ) { datetemp = ""; }
		if( str.length() == 4 ) { datetemp = str.substring(0,2) + ":" + str.substring(2,4); }
		if( str.length() == 6 ) { datetemp = str.substring(0,2) + ":" + str.substring(2,4) + ":" + str.substring(4,6); }
		if( str.length() == 8 ) { datetemp = str.substring(0,2) + ":" + str.substring(2,4) + ":" + str.substring(4,6) + ":" + str.substring(6,8); }
		
		return datetemp;
		
	}

	/** 
	 * @return 현재시간 YYYY-MM-DD HH:MM:SS
	 */
	public static String getDateTimeHypen()
   	{
		
		Calendar calCurrentTime = Calendar.getInstance();
		String datetemp = new String();
		  
		datetemp = Integer.toString(calCurrentTime.get(Calendar.YEAR)) 
		         + "-" + cvtOneToTwo((calCurrentTime.get(Calendar.MONTH)+1)) 
		         + "-" + cvtOneToTwo(calCurrentTime.get(Calendar.DAY_OF_MONTH))
		         + " " + cvtOneToTwo(calCurrentTime.get(Calendar.HOUR_OF_DAY))
		         + ":" + cvtOneToTwo(calCurrentTime.get(Calendar.MINUTE))
		         + ":" + cvtOneToTwo(calCurrentTime.get(Calendar.SECOND));
		  
		return datetemp;
		  
	}
	
	/** 
	 * @return 현재시간 YYYYMMDDHHMMSS
	 */
	public static String getDateTimeNow()
   	{
		
		Calendar calCurrentTime = Calendar.getInstance();
		String datetemp = new String();
		  
		datetemp = Integer.toString(calCurrentTime.get(Calendar.YEAR)) 
		         + cvtOneToTwo((calCurrentTime.get(Calendar.MONTH)+1)) 
		         + cvtOneToTwo(calCurrentTime.get(Calendar.DAY_OF_MONTH))
		         + cvtOneToTwo(calCurrentTime.get(Calendar.HOUR_OF_DAY))
		         + cvtOneToTwo(calCurrentTime.get(Calendar.MINUTE))
		         + cvtOneToTwo(calCurrentTime.get(Calendar.SECOND));
		
		return datetemp;
		
	}

	/** 
	 * @return 현재시간 HHMMSS
	 */
	public static String getTime()
   	{
		
		Calendar calCurrentTime = Calendar.getInstance();
		String timetemp = new String();
		  
		timetemp = cvtOneToTwo(calCurrentTime.get(Calendar.HOUR_OF_DAY))
		         + cvtOneToTwo(calCurrentTime.get(Calendar.MINUTE))
		         + cvtOneToTwo(calCurrentTime.get(Calendar.SECOND));
		
		return timetemp;
		
	}

	/** 
	 * @return 0 -> "00"
	 */
	public static String cvtOneToTwo(int intcvttemp)
	{
		
		String strcvttemp = new String();
	  	strcvttemp = Integer.toString(intcvttemp);
	  
	  	if( strcvttemp.length() == 1 ) 
	  	{
			return ("0"+strcvttemp);
	  	} 
	  	else 
	  	{
			return strcvttemp;
	  	}
	  	
	}

	/** 
	 * 123 OK , abc not OK
	 * @return 
	 */
	public static boolean isNumeric(String num) 
	{
		
		boolean bool = true;
		char ch; 
		for( int i=0; i < num.length(); i++ ) 
		{ 
			ch = num.charAt(i) ; 
			if( !Character.isDigit(ch) ) 
			{
				bool = false;
				break;
			}
		}
		
		return bool;
		
	}

	/** 
	 * 날짜 계산
	 * type = 
	 * "YEAR" 년단위 계산 
	 * "MONTH" 월단위 계산
	 * "DAY" 일단위 계산
	 * 
	 * iValue = +- 정수
	 * 복합은 2번수행하기 바랍니다.
	 * 
	 * @return  
	 */
	public static String calDate(String strDate, String type, int iValue) 
	{
		
		if( (strDate == null) || (strDate.length() != 8) ) { return strDate; }
		
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.YEAR, Integer.parseInt(strDate.substring(0,4)));
		cal.set(Calendar.MONTH, (Integer.parseInt(strDate.substring(4,6))-1));
		cal.set(Calendar.DAY_OF_MONTH,Integer.parseInt(strDate.substring(6,8)));
	
		if( "YEAR".equals(type.toUpperCase()) ) 
		{
			cal.add(Calendar.YEAR,iValue);
		} 
		else if( "MONTH".equals(type.toUpperCase()) ) 
		{
			cal.add(Calendar.MONTH,iValue);
		} 
		else if( "DAY".equals(type.toUpperCase()) ) 
		{
			cal.add(Calendar.DAY_OF_MONTH,iValue);
		}
		
		return Integer.toString(cal.get(Calendar.YEAR))+
				cvtOneToTwo(cal.get(Calendar.MONTH)+1)+
				cvtOneToTwo(cal.get(Calendar.DAY_OF_MONTH));
		
	}		

	/** 
	 * "123456", "2-2"      = "123-456"
	 * "123456", "###-###"  = "123-456"
	 * 
	 * @return 
	 */
	public static String format(String str, String fmt) 
	{

		if( str == null ) { return ""; }
		if( fmt == null ) { return ""; }
		if( str.trim().length() == 0 ) { return ""; }
		
		StringBuffer result = new StringBuffer();
		int strIdx = 0;
		int etcCnt = 0;
	
		StringBuffer fmt2 = new StringBuffer();
		for( int i = 0; i < fmt.length(); i++ ) 
		{
			if( fmt.charAt(i) >= '1' && fmt.charAt(i) <= '9' ) 
			{
				for( int j = '0'; j < fmt.charAt(i); j++ ) 
				{
					fmt2.append("#");
				}
			} 
			else 
			{
				fmt2.append(String.valueOf(fmt.charAt(i)));
			}
		}
	
		return getFormattedStr(str, fmt2.toString());
		
	}
	

	/** 
	 * "123456", "###-###"  = "123-456"
	 * "123456", "####년 ##월"  = "1234년 56월"
	 * 
	 * @return 
	 */
	private static String getFormattedStr(String str, String fmt) 
	{
		
		StringBuffer result = new StringBuffer();
		int strIdx = 0;
		int etcCnt = 0;
	
		for( int i = 0; i < fmt.length(); i++ ) 
		{
			if( i >= (str.length() + etcCnt) )
			{
				result.append(String.valueOf(fmt.charAt(i)));
				etcCnt++;
				continue;
			}
			
			if( fmt.charAt(i) == '#' ) 
			{
				result.append(String.valueOf(str.charAt(strIdx)));
				strIdx++;
			} 
			else 
			{
				result.append(String.valueOf(fmt.charAt(i)));
				etcCnt++;
			}
		}
		
		return result.toString();
		
	}

	/** 
	 * "4", "0" ,4  = "0004" 
	 * @return 
	 */
	public static String getLeftFilledString(String str, String strFull, int i) 
	{
		
		if( str == null ) { return ""; }
		
		String fullStr = str.trim();
		String strTemp = "";
		int strLength = fullStr.length();
		int forI = i - strLength;

		if( forI == 0 ) 
		{
			return str;
		} 
		else 
		{
			for( int k = 1; k <= forI; k++ ) 
			{
				strTemp = strTemp + strFull;
			}
			
			return strTemp + fullStr;
		}
		
	}

	/** 
	 * "4", "0" ,4  = "4000" 
	 * @return 
	 */
	public static String getRightFilledString(String str, String strFull, int i) 
	{
		
		if( str == null ) { return ""; }
		
		String fullStr = str.trim();
		String strTemp = "";
		int strLength = fullStr.length();
		int forI = i - strLength;

		if( forI == 0 ) 
		{
			return str;
		} 
		else 
		{
			for(int k = 1; k <= forI; k++ ) 
			{
				strTemp = strTemp + strFull ;
			}
			
			return fullStr + strTemp;
		}
		
	}

	/** 
	 * 1234 -> "1,234" 
	 * @return 
	 */
	public static String getNumericString(int inttemp) 
	{
		
		DecimalFormat df = new DecimalFormat("##,###,###,##0");
		
		return df.format(inttemp);
		
	}

	/** 
	 * 1234.12 -> "1,234.12" 
	 * @return 
	 */
	public static String getNumericString(Double dbltemp) 
	{
		
		double dbl = dbltemp.doubleValue();
		DecimalFormat df = new DecimalFormat("##,###,###,##0.00");
		if( dbltemp == null ) { return "0"; }
		
		return df.format(dbl);
		
	}

	/** 
	 * 1234.12 -> "1,234.12" 
	 * @return 
	 */
	public static String getNumericString(double dbltemp) 
	{
		
		DecimalFormat df = new DecimalFormat("##,###,###,##0.00");
		
		return df.format(dbltemp);
		
	}

	/** 
	 * 1234.12, 1 -> "1,234.1"
	 * length 는 소수점 이하 자리 
	 * @return 
	 */
	public static String getNumericString(double dbltemp, int length) 
	{
		
		if( length < 0 ) { length = 0; }
		
		String strTemp = "";
		
		if( length == 0 )
		{
			strTemp = "#";
		}
		else
		{
			strTemp = "0.";
			for( int i = 0 ; i < length ; i++ )
			{
				strTemp += "0";
			}
		}
		
		DecimalFormat df = new DecimalFormat("##,###,###,##"+strTemp);
		
		return df.format(dbltemp);
		
	}

	/** 
	 * "1234.12", "#,###,###,###" -> "1,234" 
	 * 주의 입력이 문자 입니다. 
	 * @return 
	 */
	public static String getNumericString(String strtemp, String fmt) 
	{
		
		if( strtemp == null || "".equals(strtemp.trim()) ) { return ""; }

		double dbl;
		if( fmt == null || fmt.trim().length() == 0 ) { return strtemp; }
		if( strtemp == null || strtemp.length() == 0 ) 
		{
			dbl = 0;
		} 
		else 
		{
			dbl = new Double(strtemp.trim()).doubleValue();
		}
		DecimalFormat df = new DecimalFormat(fmt);

		return df.format(dbl);
		
	}

	/** 
	 * "12,12,12" -> str[] = {"12", "12", "12"} 
	 * @return 
	 */
	public static String[] getParser(String str, String sep) 
	{
		
		int count = 0;
		int index = 0;
		int index2 = 0;
		
		if( str == null ) { return null; }
		
		do 
		{
			++count;
			++index;
			index = str.indexOf(sep, index);
		} while (index != -1);
		// LAST GUBUNJA check
		
		if( isEmpty(str.substring(index2)) ) { count--; }
		String[] substr = new String[count];
		index = 0;
		int endIndex = 0;
		for( int i = 0; i < (count); i++) 
		{
			endIndex = str.indexOf(sep, index);
			if( endIndex == -1 ) 
			{
				substr[i] = str.substring(index);
			} 
			else 
			{
				substr[i] = str.substring(index, endIndex);
			}
			index = endIndex + 1;
		}
		
		return substr;
		
	}

	/** 
	 * "1,234.12" -> "1234.12" 
	 * @return 
	 */
	public static String getNumericString(String strTempvalue) 
	{
		
		if( strTempvalue == null || "".equals(strTempvalue.trim()) ) { return ""; }

		String[] tmpStr = getParser(strTempvalue,".");
		String retvalue = "";
		boolean isMinus = false;
		strTempvalue = tmpStr[0];
		
		if( "-".equals(strTempvalue.substring(0,1)) ) 
		{
			isMinus = true;
			strTempvalue = strTempvalue.substring(1);
		}
		
		int i,j;
		if( strTempvalue.length()<4 ) 
		{
			if( isMinus ) { return "-" + strTempvalue; }
			retvalue = strTempvalue;
		} 
		else 
		{
			j=0;
			for( i=(strTempvalue.length()-1); i >= 0; i-- )
			{
				j++;
				if( ((j % 3) == 1) && (j != 1) ) 
				{
					retvalue = strTempvalue.charAt(i) + "," + retvalue;
				} 
				else 
				{
					retvalue = strTempvalue.charAt(i) + retvalue;
				}
			}
			if( isMinus ) { retvalue = "-" + retvalue; }
		}
	  
		if( tmpStr.length > 1 ) { retvalue = retvalue + "." + tmpStr[1]; }
		
		return retvalue;
		
	}

	/** 
	 * "12,12,12" -> "121212"
	 * @return 
	 */
	public static String delComma(String comma)  
	{
		
		int index = 0;
		if( (comma == null) || comma.equals("") ) { return ""; }
		
		while( (index = comma.indexOf(",", index)) >= 0 ) 
		{
			comma = comma.substring(0, index) + "" + comma.substring(index + 1);
			index += 1;
		}
		
		return comma;
		
	}

	/** 
	 * 문자를 인티저형으로 변환
	 * null -> 0
	 * "" -> 0
	 * "12" -> 12
	 * @return 
	 */
	public static int chkNullInt(String inttemp)  
	{
		
		if( (inttemp == null) || inttemp.equals("") ) { return 0; }
		
		return Integer.parseInt(inttemp);
		
	}

	/** 
	 * 문자를 더형으로 변환
	 * null -> 0
	 * "" -> 0
	 * "12" -> 12
	 * @return 
	 */
	public static double chkNullDbl(String Wtemp)  
	{
		
		double dbltemp;
		if( (Wtemp == null) || Wtemp.equals("") ) { return 0.0d; }
		dbltemp = new Double(delComma(Wtemp)).doubleValue();
		
		return dbltemp;
		
	}

	/**
	 * YYYY-MM-DD <- YYYYMMDD
	 */
	public static String insDash(String str) 
	{
		
		if( (str == null) || (str.equals("")) ) { return ""; }
		
		str = replace(str,"-","");
		if( str.length() == 4 ) { return str; }
		if( str.length() == 6 ) { return str.substring(0, 4) + "-" + str.substring(4, 6); }
		if( str.length() == 8 ) { return str.substring(0, 4) + "-"	+ str.substring(4, 6) + "-"	+ str.substring(6, 8); }
		
		return "";
		
	}

	/**
	 * YYYY-MM-DD -> YYYYMMDD
	 */
	public static String delDash(String strdate) 
	{
		
		if( strdate == null ) { return null; } 
	
		return replace(strdate.toUpperCase(),"-","");
		
	}

	/**
	 * String을 받아서 길이가 0 인경우 true 반환.
	 */
	public static boolean isEmpty(String str) 
	{
		
		if( (str == null) || (str.trim().length() == 0) ) 
		{
			return true;
		} 
		else 
		{
			return false;
		}
		
	}

	/**
	 * String을 받아서 null일 경우 ""를 리턴한다.
	 */
	public static String chkNull( String temp ) 
	{
		
		if( temp == null ) { temp = ""; }
		
		return temp.trim();
		
	}
	
	/**
	 * String을 받아서 null일 경우 ""를 리턴한다.
	 */
	public static String chkNull( String temp, String ch ) 
	{
		
		if( temp == null ) { temp = ch; }
		
		return temp.trim();
		
	}
	
	/**
	 * Calendar 타입을 받아서 "yyyy-mm-dd" 형태로 리턴한다.
	 */
	public static String getDate( Calendar temp ) 
	{
		
		String str = String.valueOf( temp.get( Calendar.YEAR ) ) + "-";
		if( temp.get( Calendar.MONTH ) < 9 ) { str += "0"; }
		str += String.valueOf( temp.get( Calendar.MONTH ) + 1 ) + "-";
		if( temp.get( Calendar.DATE ) < 10 ) { str += "0"; }
		str += String.valueOf( temp.get( Calendar.DATE ) );
		
		return str;
		
	}
	
	/**
	 * Calendar 타입을 받아서 "yyyy-mm-dd-hh-mm-ss" 형태로 리턴한다.
	 */
	public static String getDateFullString( Calendar temp ) 
	{
		
		String str = String.valueOf( temp.get( Calendar.YEAR ) ) + "-";
		if( temp.get( Calendar.MONTH ) < 9 ) { str += "0"; }
		str += String.valueOf( temp.get( Calendar.MONTH ) + 1 ) + "-";
		if( temp.get( Calendar.DATE ) < 10 ) { str += "0"; }
		str += String.valueOf( temp.get( Calendar.DATE ) ) + "-";
		if( temp.get( Calendar.HOUR_OF_DAY ) < 10 ) { str += "0"; }
		str += String.valueOf( temp.get( Calendar.HOUR_OF_DAY ) ) + "-";
		if( temp.get( Calendar.MINUTE ) < 10 ) { str += "0"; }
		str += String.valueOf( temp.get( Calendar.MINUTE ) ) + "-";
		if( temp.get( Calendar.SECOND ) < 10 ) { str += "0"; }
		str += String.valueOf( temp.get( Calendar.SECOND ) );
		
		return str;
		
	}

	/**
	* String에서 특정 문자열을 replace한다.
	* @param source 원본 문자열
	* @param oldStr 바꿀 문자열
	* @param newStr 바뀔 문자열
	*/
	public static String replace( String source, String oldStr, String newStr ) 
	{
		
		if( source == null ) { return null; }
		if( oldStr == null ) { return null; }
		if( newStr == null ) { return null; }

		int oldLen = oldStr.length();
		int newLen = newStr.length();
		int startIndex=0;
		int check=0;

		while(true)
		{
			check = source.indexOf(oldStr,startIndex);
			if( check == -1 ) { break; }
			source = source.substring(0,check) + newStr + source.substring(check+oldLen);
			startIndex = check + newLen;
		}

		return source;
		
	}
	
	public HashMap<String, String> executeParam(Enumeration reqParam, HttpServletRequest request) throws UnsupportedEncodingException
	{
		request.setCharacterEncoding("utf-8");
		HashMap<String, String> paramHash = new HashMap<String, String>();

		while (reqParam.hasMoreElements())
		{
			String name = (String) reqParam.nextElement();
			String all[] = request.getParameterValues(name);
	
			for (int i = 0; i < all.length; i++)
			{
				paramHash.put(name, all[i].toString());
			}
		}
	
		
		Iterator iter = paramHash.keySet().iterator();
		String key, value;
		int i = 0;
		while (iter.hasNext())
		{
			key = (String)iter.next();
			value = new String(((String)paramHash.get(key)).getBytes("8859_1"), "utf-8"); 
			System.out.println("# param["+i+"] KEY[" + key + "]    VALUE[" + value + "]");
		}
		System.out.println("################################################################################");
		return paramHash;
	}

	
}