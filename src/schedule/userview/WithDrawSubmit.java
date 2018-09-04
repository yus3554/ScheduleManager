package schedule.userview;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import schedule.model.UserTable;

/**
 * Servlet implementation class WithDrawSubmit
 */
@WebServlet("/WithDrawSubmit")
public class WithDrawSubmit extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public WithDrawSubmit() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		//退会処理
		//全てのテーブルから関連するデータを削除
		// users

		// notifs

		// schedules

		// targets

		// answers

		// ログアウト処理

		// jspを指定
		String view = "/WEB-INF/view/user/withdrawsubmit.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);
	}

}
