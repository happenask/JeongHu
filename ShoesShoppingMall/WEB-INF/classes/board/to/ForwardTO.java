package board.to;

public class ForwardTO {
	private String url;
	private boolean redirect;//true-리다이렉트, false -요청디스패치
	public ForwardTO(){}
	public ForwardTO(String url, boolean redirect) {
		this.url = url;
		this.redirect = redirect;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public boolean isRedirect() {
		return redirect;
	}
	public void setRedirect(boolean redirect) {
		this.redirect = redirect;
	}
	@Override
	public String toString() {
		return "ForwardDTO [url=" + url + ", redirect=" + redirect + "]";
	}
	
}
