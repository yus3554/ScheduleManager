package schedule.topview;

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
 * Servlet Filter implementation class LoginFilter
 * TopPageなど、ログインしていたらユーザーページに飛ばすフィルター
 */
@WebFilter(
		urlPatterns = {
				"/TopPage",
				"/Login",
				"/SignUp",
				"/SignUpSubmit"
				})
public class LoginFilter implements Filter {

    /**
     * Default constructor.
     */
    public LoginFilter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		try {
			// sessionを取得
			HttpSession session = ((HttpServletRequest) request).getSession(false);

			if (session != null){
				Object loginCheck = session.getAttribute("login");
				if (loginCheck != null){
					((HttpServletResponse) response).sendRedirect("./UserPage");
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
		// TODO Auto-generated method stub
	}

}
