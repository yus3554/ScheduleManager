package schedule.answerview;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import schedule.model.AnswerTable;
import schedule.model.TargetTable;

/**
 * Servlet implementation class AnswerSubmit
 */
@WebServlet("/AnswerSubmit")
public class AnswerSubmit extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AnswerSubmit() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);

		String randomURL = (String)session.getAttribute("randomURL");

		String[] date = (String[])session.getAttribute("date");
		String[] first = (String[])session.getAttribute("first");
		String[] second = (String[])session.getAttribute("second");
		String[] third = (String[])session.getAttribute("third");
		String[] fourth = (String[])session.getAttribute("fourth");
		String[] fifth = (String[])session.getAttribute("fifth");

		// dbと接続して上のデータを使ってupdateする
		new AnswerTable().update(randomURL, date, first, second, third, fourth, fifth);

		new TargetTable().isInputUpdate(randomURL);

		// 最後にsessionを削除しておく
		session.removeAttribute("date");
		session.removeAttribute("first");
		session.removeAttribute("second");
		session.removeAttribute("third");
		session.removeAttribute("fourth");
		session.removeAttribute("fifth");

		// jspを指定
    	String view = "/WEB-INF/view/answer/answersubmit.jsp";
    	// リクエストをviewに飛ばす
    	RequestDispatcher dispatcher = request.getRequestDispatcher(view);

    	dispatcher.forward(request, response);
	}

}
