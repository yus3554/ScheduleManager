package schedule.userview;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet Filter implementation class AuthFilter
 * ユーザーページ等、ログインしていなかったらログインページに飛ばすフィルター
 */
// フィルターをかけるurlを指定
@WebFilter(
		urlPatterns = {
				"/UserPage",
				"/NewSchedule",
				"/NewScheduleConfirm",
				"/NewScheduleSubmit",
				"/ScheduleList",
				"/ScheduleDetail",
				"/ScheduleDeleteConfirm",
				"/ScheduleDeleteExecute",
				"/ClientAnswer",
				"/Config",
				"/WithDrawConfirm",
				"/WithDrawSubmit"
				})
public class UserFilter implements Filter {

    /**
     * Default constructor.
     */
    public UserFilter() {
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		// place your code here
		try {
			// sessionを取得
			HttpSession session = ((HttpServletRequest) request).getSession(false);

			if (session == null){
				/* まだ認証されていない */
				session = ((HttpServletRequest) request).getSession(true);

				((HttpServletResponse) response).sendRedirect("./Login");
				return;
			}else{
				Object loginCheck = session.getAttribute("login");
				if (loginCheck == null){
					/* まだ認証されていない */
					((HttpServletResponse) response).sendRedirect("./Login");
					return;
				}
			}

			// pass the request along the filter chain
			chain.doFilter(request, response);
		} catch (ServletException se) {
		} catch (IOException e) {
		}
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
	}

}
