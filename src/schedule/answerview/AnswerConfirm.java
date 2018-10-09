package schedule.answerview;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class AnswerConfirm
 */
@WebServlet("/AnswerConfirm")
public class AnswerConfirm extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AnswerConfirm() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// getParameterして要素を取り出す
		// randomURLをinput type="hidden"で送っておく
		// randomURLでschedule等からdateを取り出し、確認用の表を作れるようにする
		request.setCharacterEncoding("utf-8");

		HttpSession session = request.getSession(false);

		int answersLength = (int)session.getAttribute("answersLength");

		String[] date = new String[answersLength];
		String[] first = new String[answersLength];
		String[] second = new String[answersLength];
		String[] third = new String[answersLength];
		String[] fourth = new String[answersLength];
		String[] fifth = new String[answersLength];

		for(int i = 0; i < answersLength; i++) {
			date[i] = request.getParameter("date" + i);
			first[i] = request.getParameter("first" + i);
			second[i] = request.getParameter("second" + i);
			third[i] = request.getParameter("third" + i);
			fourth[i] = request.getParameter("fourth" + i);
			fifth[i] = request.getParameter("fifth" + i);
		}

		String note = request.getParameter("note");
		note = note.replace("\n", "");
    	note = note.replace("\r", "<br>");
    	note = note.replace("\r\n", "<br>");

		session.setAttribute("date", date);
		session.setAttribute("first", first);
		session.setAttribute("second", second);
		session.setAttribute("third", third);
		session.setAttribute("fourth", fourth);
		session.setAttribute("fifth", fifth);
		session.setAttribute("note", note);

		// jspを指定
    	String view = "/WEB-INF/view/answer/answerconfirm.jsp";
    	// リクエストをviewに飛ばす
    	RequestDispatcher dispatcher = request.getRequestDispatcher(view);

    	dispatcher.forward(request, response);
	}

}
