package board.to;

import java.util.ArrayList;

public class ListTO {
	private ArrayList<BoardTO> list;
	private PagingTO pagingTO;
	public ListTO(ArrayList<BoardTO> list, PagingTO pagingTO) {
		this.list = list;
		this.pagingTO = pagingTO;
	}
	
	public ListTO() {}

	public ArrayList<BoardTO> getList() {
		return list;
	}
	public void setList(ArrayList<BoardTO> list) {
		this.list = list;
	}
	public PagingTO getPagingTO() {
		return pagingTO;
	}
	public void setPagingTO(PagingTO pagingTO) {
		this.pagingTO = pagingTO;
	}
	@Override
	public String toString() {
		return "ListDTO [list=" + list + ", pagingTO=" + pagingTO + "]";
	}
	
	
}
