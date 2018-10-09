package schedule.userview;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import schedule.model.ScheduleTable;

/**
 * Servlet implementation class DecideSchedule
 */
@WebServlet("/RequestSchedules/DecideSchedule/*")
public class DecideSchedule extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public DecideSchedule() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	// urlからidを取得
    	// 1文字目には"\"が入っているので2文字目からを代入
    	String id = request.getPathInfo().substring(1);

    	// sessionを取得
    	HttpSession session = request.getSession(false);

    	// idとsenderEmailを入れてscheduleを取得
    	HashMap<String, String> scheduleHM = new HashMap<String, String>();
    	scheduleHM = new ScheduleTable().getSchedule(id, (String) session.getAttribute("email"));

    	// scheduleをrequestに格納
    	String eventStartDate = scheduleHM.get("eventStartDate");
    	String eventEndDate = scheduleHM.get("eventEndDate");
    	LocalDate startDate = LocalDate.parse(eventStartDate);
		LocalDate endDate = LocalDate.parse(eventEndDate);

		long dateLength = ChronoUnit.DAYS.between(startDate, endDate);

    	session.setAttribute("id", scheduleHM.get("id"));
    	session.setAttribute("eventName", scheduleHM.get("eventName"));
    	session.setAttribute("eventStartDate", scheduleHM.get("eventStartDate"));
    	session.setAttribute("eventEndDate", scheduleHM.get("eventEndDate"));
		session.setAttribute("dateLength", dateLength);

    	// jspを指定
    	String view = "/WEB-INF/view/user/decideschedule.jsp";
    	// リクエストをviewに飛ばす
    	RequestDispatcher dispatcher = request.getRequestDispatcher(view);

    	dispatcher.forward(request, response);
    }

}