package board.model.service;

import java.sql.SQLException;
import java.util.ArrayList;

import board.model.dao.BoardDAO;
import board.to.BoardTO;
import board.to.ListTO;
import board.to.PagingTO;
import board.util.Utilities;

public class BoardService {
	private BoardDAO dao;
	public BoardService(BoardDAO dao){
		this.dao = dao;
	}
	//글입력 처리를 하는 Business 메소드
	public void writeContent(BoardTO bto) throws SQLException{
		
		String writeDate = Utilities.getNow();
		String c = Utilities.changeContentForDB(bto.getContent());
		bto.setWritedate(writeDate);
		bto.setContent(c);
		//2
		dao.insertContentForNewCount(bto);
		//3  - 멱등처리(redirect전송)의 경우 아래 코드는 필요없음
		bto.setWritedate(Utilities.changeDayTimeFormat(writeDate));
	}
	public ArrayList<BoardTO> getBoardAllList() throws SQLException{
		//1. dao로부터 전체 글내용을 ArrayList로 조회
		ArrayList<BoardTO> list = dao.selectBoardAllList();
		//2 list내의 BoardDTO객체들의 writedate를 변경
		for(BoardTO bto:list){
			bto.setWritedate(Utilities.changeDayFormat(bto.getWritedate()));
		}
		return list;
	}
	public BoardTO getContentByNO(int no) throws SQLException{
		//1. 조회수 증가
		dao.updateViewCount(no);
		//2. no로 글 정보 조회
		BoardTO bto = dao.selectContentByNO(no);
		//2-1 writedate를 yyyy.MM.dd HH:mm:ss 형식으로 변경
		bto.setWritedate(Utilities.changeDayTimeFormat(bto.getWritedate()));
		return bto;
	}
	public BoardTO getContentByNoForForm(int no) throws SQLException{
		//1. no값으로 글 조회
		BoardTO bto = dao.selectContentByNO(no);
		//2. content를 textarea용으로 변경
		bto.setContent(Utilities.changeContentForTextArea(bto.getContent()));
		return bto;
	}
	public void modifyContent(BoardTO bto) throws SQLException{
		//1. property변경 - content, writedate
		bto.setContent(Utilities.changeContentForDB(bto.getContent()));
		bto.setWritedate(Utilities.getNow());
		//2. 수정 처리
		dao.updateContent(bto);
		//3. writedate 포멧 변경 - 멱등처리(redirect전송)의 경우 아래 코드는 필요없음
		bto.setWritedate(Utilities.changeDayTimeFormat(bto.getWritedate()));
	}
	public void deleteContentByNO(int no) throws SQLException{
		dao.deleteContentByNO(no);
	}
	public void replyContent(BoardTO bto) throws SQLException{
		//1. DB에 같은 refamily의 restep들을 1씩 증가시킨다.
		dao.updateRestep(bto.getRefamily(), bto.getRestep());
		//2. bto의 restep, relevel을 1 증가시킨다.
		bto.setRestep(bto.getRestep()+1);
		bto.setRelevel(bto.getRelevel()+1);
		//3. insert할 글 번호를 가져온와 bto에 넣는다. 
		//4. BoardDTO에 no, writeDate와 content는 DB 저장용으로 변경한다.
		
		
		bto.setWritedate(Utilities.getNow());
		bto.setContent(Utilities.changeContentForDB(bto.getContent()));
		//5. 새글 등록 - dao.insertContent() 이용
		dao.insertContentForReply(bto);
		
		//6. 날짜 형태 show_content.jsp에서 보여주도록 년.월.일 시:분:초 로 변경 - 멱등처리(redirect전송)의 경우 아래 코드는 필요없음
		bto.setWritedate(Utilities.changeDayTimeFormat(bto.getWritedate()));
	}
	//페이징 리스트 조회
	public ListTO getBoardListByPage(int page) throws SQLException{
		//1. dao로부터 전체 글내용을 ArrayList로 조회
		ArrayList<BoardTO> list = dao.selectBoardListByPage(page);
		//2 list내의 BoardDTO객체들의 writedate를 변경
		for(BoardTO bto:list){
			bto.setWritedate(Utilities.changeDayFormat(bto.getWritedate()));
		}
		//3. PagingDTO객체를 생성
		// 	3.1. - dao.selectTotalContent() - 총게시물 수를 리턴
		int totalContent = dao.selectTotalContent();
		PagingTO pagingTO = new PagingTO(totalContent, page);
		//4. ArrayList, PagingDTO객체를 이용해 ListDTO를 생성해서 return
		ListTO lto = new ListTO(list, pagingTO);
		return lto;
	}
	public ArrayList getImageListByViewNum() {
		// TODO Auto-generated method stub
		return dao.selectImagListByViewNum();
	}
}






