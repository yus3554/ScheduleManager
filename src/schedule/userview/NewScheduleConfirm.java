package schedule.userview;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class NewScheduleConfirm
 */
@WebServlet("/NewScheduleConfirm")
public class NewScheduleConfirm extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public NewScheduleConfirm() {
		super();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");

		// postされて来た要素を取得
		String eventName = (String) request.getParameter("eventName");
		String eventContent = (String) request.getParameter("eventContent");
		eventContent = eventContent.replace("\r", "<br>");
		eventContent = eventContent.replace("\r\n", "<br>");
		String eventStartDate = (String) request.getParameter("eventStartDate");
		String eventEndDate = (String) request.getParameter("eventEndDate");
		String[] targetEmails = {
				(String) request.getParameter("targetEmail1"),
				(String) request.getParameter("targetEmail2"),
				(String) request.getParameter("targetEmail3"),
				(String) request.getParameter("targetEmail4"),
				(String) request.getParameter("targetEmail5")};
		String eventDeadlineDate = (String) request.getParameter("eventDeadlineDate");

		HttpSession session = request.getSession(false);

		// 取得した要素をsessionに保存
		session.setAttribute("eventName", eventName);
		session.setAttribute("eventContent", eventContent);
		session.setAttribute("eventStartDate", eventStartDate);
		session.setAttribute("eventEndDate", eventEndDate);
		session.setAttribute("targetEmails", targetEmails);
		session.setAttribute("eventDeadlineDate", eventDeadlineDate);

		// jspを指定
		String view = "/WEB-INF/view/user/newscheduleconfirm.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);

	}

}
