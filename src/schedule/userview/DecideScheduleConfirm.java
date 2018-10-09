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
 * Servlet implementation class DecideScheduleConfirm
 */
@WebServlet("/RequestSchedules/DecideScheduleConfirm/*")
public class DecideScheduleConfirm extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public DecideScheduleConfirm() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("utf-8");
		// urlからidを取得
    	// 1文字目には"\"が入っているので2文字目からを代入
    	String id = request.getPathInfo().substring(1);

    	// sessionを取得
    	HttpSession session = request.getSession(false);

    	int dateLength = (int)(long)session.getAttribute("dateLength") + 1;
    	int[][] date = new int[dateLength][5];

    	String[] dateIndex = request.getParameterValues("date");

    	for(int i = 0; i < dateIndex.length; i++) {
    		String[] splitDateIndex = dateIndex[i].split(",", 0);
    		date[Integer.parseInt(splitDateIndex[0])][Integer.parseInt(splitDateIndex[1])] = 1;
    	}
    	session.setAttribute("date", date);

    	String note = request.getParameter("note");
    	note = note.replace("\n", "");
    	note = note.replace("\r", "<br>");
    	note = note.replace("\r\n", "<br>");
    	session.setAttribute("note", note);

    	// jspを指定
    	String view = "/WEB-INF/view/user/decidescheduleconfirm.jsp";
    	// リクエストをviewに飛ばす
    	RequestDispatcher dispatcher = request.getRequestDispatcher(view);

    	dispatcher.forward(request, response);
	}

}
