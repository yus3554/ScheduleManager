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
		String name = (String) request.getParameter("userNameSignUp");
		String email = (String) request.getParameter("emailSignUp");
		String pass = (String) request.getParameter("passwordSignUp");

		session.setAttribute("userNameSignUp", name);
		session.setAttribute("emailSignUp", email);
		session.setAttribute("passwordSignUp", pass);

		// jspを指定
		String view = "/WEB-INF/view/auth/signupconfirm.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);
	}

}
