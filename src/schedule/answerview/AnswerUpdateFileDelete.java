package schedule.answerview;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import schedule.model.TargetAttachmentTable;

/**
 * Servlet implementation class AnswerUpdateFileDelete
 */
@WebServlet("/AnswerUpdateFileDelete")
public class AnswerUpdateFileDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AnswerUpdateFileDelete() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);

		request.setCharacterEncoding("utf-8");

		String fileName = request.getParameter("fileName");
		String randomURL = request.getParameter("randomURL");

		new TargetAttachmentTable().deleteFile(randomURL, fileName);

		String url = "/ScheduleManager/AnswerPage/" + randomURL;

		response.sendRedirect(url);
	}

}
