package upload.to;

import org.springframework.web.multipart.MultipartFile;

public class SingleUpTO {

	private String comment; 
	private MultipartFile upfile;
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public MultipartFile getUpfile() {
		return upfile;
	}
	public void setUpfile(MultipartFile upfile) {
		this.upfile = upfile;
	}
	
	
}
