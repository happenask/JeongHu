package board.to;
//게시판의 게시물 속성
public class BoardTO {
	private int no;
	private String title;
	private String writer;
	private String content;
	private String writedate;
	private int viewcount;
	private int refamily;
	private int restep;
	private int relevel;
	private String fileName;
	public BoardTO() {}
	public BoardTO(String title, String writer, String content) {
		this.title = title;
		this.writer = writer;
		this.content = content;
	}
	
	public BoardTO(int no, String title, String writer, String content,
			String writedate, int viewcount) {
		this.no = no;
		this.title = title;
		this.writer = writer;
		this.content = content;
		this.writedate = writedate;
		this.viewcount = viewcount;
	}
	public BoardTO(int no, String title, String writer, String content,
			String writedate, int viewcount, int refamily, int restep,
			int relevel, String fileName) {
		super();
		this.no = no;
		this.title = title;
		this.writer = writer;
		this.content = content;
		this.writedate = writedate;
		this.viewcount = viewcount;
		this.refamily = refamily;
		this.restep = restep;
		this.relevel = relevel;
		this.fileName = fileName;
	}
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWritedate() {
		return writedate;
	}
	public void setWritedate(String writedate) {
		this.writedate = writedate;
	}
	public int getViewcount() {
		return viewcount;
	}
	public void setViewcount(int viewcount) {
		this.viewcount = viewcount;
	}
	public int getRefamily() {
		return refamily;
	}
	public void setRefamily(int refamily) {
		this.refamily = refamily;
	}
	public int getRestep() {
		return restep;
	}
	public void setRestep(int restep) {
		this.restep = restep;
	}
	public int getRelevel() {
		return relevel;
	}
	public void setRelevel(int relevel) {
		this.relevel = relevel;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((content == null) ? 0 : content.hashCode());
		result = prime * result
				+ ((fileName == null) ? 0 : fileName.hashCode());
		result = prime * result + no;
		result = prime * result + refamily;
		result = prime * result + relevel;
		result = prime * result + restep;
		result = prime * result + ((title == null) ? 0 : title.hashCode());
		result = prime * result + viewcount;
		result = prime * result
				+ ((writedate == null) ? 0 : writedate.hashCode());
		result = prime * result + ((writer == null) ? 0 : writer.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BoardTO other = (BoardTO) obj;
		if (content == null) {
			if (other.content != null)
				return false;
		} else if (!content.equals(other.content))
			return false;
		if (fileName == null) {
			if (other.fileName != null)
				return false;
		} else if (!fileName.equals(other.fileName))
			return false;
		if (no != other.no)
			return false;
		if (refamily != other.refamily)
			return false;
		if (relevel != other.relevel)
			return false;
		if (restep != other.restep)
			return false;
		if (title == null) {
			if (other.title != null)
				return false;
		} else if (!title.equals(other.title))
			return false;
		if (viewcount != other.viewcount)
			return false;
		if (writedate == null) {
			if (other.writedate != null)
				return false;
		} else if (!writedate.equals(other.writedate))
			return false;
		if (writer == null) {
			if (other.writer != null)
				return false;
		} else if (!writer.equals(other.writer))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "BoardTO [no=" + no + ", title=" + title + ", writer=" + writer
				+ ", content=" + content + ", writedate=" + writedate
				+ ", viewcount=" + viewcount + ", refamily=" + refamily
				+ ", restep=" + restep + ", relevel=" + relevel + ", fileName="
				+ fileName + "]";
	}
	
	
	
}
