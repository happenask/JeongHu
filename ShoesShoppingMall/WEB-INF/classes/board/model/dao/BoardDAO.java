package board.model.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import board.to.BoardTO;
import board.util.Utilities;


public class BoardDAO {
	private SqlMapClientTemplate sqlMap;
	public BoardDAO(SqlMapClientTemplate sqlMap){
		this.sqlMap = sqlMap;
	}
	
	
	//board테이블에 내용을 하나 insert
	public Object insertContentForNewCount(BoardTO bdto) throws SQLException{
		System.out.println("dao:"+bdto.getFileName());
		System.out.println(bdto.toString());
		return sqlMap.insert("insertContentForNewCount", bdto);
							 
	}
	public Object insertContentForReply(BoardTO bdto) throws SQLException{
		return sqlMap.insert("insertContentForReply", bdto);
	}
	public ArrayList<BoardTO> selectBoardListByPage(int page) throws SQLException{
		HashMap map = new HashMap();
		map.put("contentPerPage", Utilities.CONTENT_PER_PAGE);
		map.put("page", page);
		return (ArrayList<BoardTO>)sqlMap.queryForList("selectBoardListByPage", map);
	}
	//페이징 없이 전체 조회
	public ArrayList<BoardTO> selectBoardAllList() throws SQLException{
		return (ArrayList<BoardTO>)sqlMap.queryForList("selectBoardAllList");
	}
	
	//총 게시물 수를 return 하는 메소드
	public int selectTotalContent() throws SQLException{
		return (Integer)sqlMap.queryForObject("selectTotalContent");
	}
	public int updateViewCount(int no) throws SQLException{
		return sqlMap.update("updateViewCount", no);
	}

	public BoardTO selectContentByNO(int no) throws SQLException{
		return (BoardTO)sqlMap.queryForObject("selectContentByNO", no);
	}
	//게시물 정보를 수정하는 메소드
	public int updateContent(BoardTO bdto) throws SQLException{
		return sqlMap.update("updateContent", bdto);
	}
	//글번호로 글을 삭제하는 메소드
	public int deleteContentByNO(int no) throws SQLException{
		return sqlMap.delete("deleteContentByNO", no);
	}
	//답변 처리시 restep값 update하는 메소드
	public int updateRestep(int refamily, int restep) throws SQLException{
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("refamily", refamily);
		map.put("restep", restep);
		return sqlMap.update("updateRestep", map);
	}


	public ArrayList selectImagListByViewNum() {
		// TODO Auto-generated method stub
		return (ArrayList) sqlMap.queryForList("selectImageByViewNum");
	}
	

}












