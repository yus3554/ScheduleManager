package schedule.topview;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class SignUp
 */
@WebServlet("/SignUpConfirm")
public class SignUpConfirm extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public SignUpConfirm() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		// postされてきた情報をエンコード
		request.setCharacterEncoding("utf-8");
		// requestの"name"パラメータを取得
		String name = (String) request.getParameter("userName");
		String email = (String) request.getParameter("email");
		String pass = (String) request.getParameter("password");
		int passNum = pass.length();
		String passwordHidden = new String(new char[passNum]).replace("\0", "*");

		session.setAttribute("userName", name);
		session.setAttribute("email", email);
		session.setAttribute("password", pass);
		session.setAttribute("passwordHidden", passwordHidden);

		// jspを指定
		String view = "/WEB-INF/view/auth/signupconfirm.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);
	}

}
