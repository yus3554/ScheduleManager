package schedule.userview;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import schedule.model.DatetimeDateTable;
import schedule.model.ScheduleDate;
import schedule.model.ScheduleDateTable;
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

    	String senderEmail = (String) session.getAttribute("email");

    	// idとsenderEmailを入れてscheduleを取得
    	HashMap<String, String> scheduleHM = new HashMap<String, String>();
    	scheduleHM = new ScheduleTable().getSchedule(id, senderEmail);

    	int dateType = Integer.parseInt(scheduleHM.get("dateType"));
    	session.setAttribute("dateType", dateType);

    	if(dateType == 1) {
    		ArrayList<ScheduleDate> sdList = new ScheduleDateTable().getDateList(id, senderEmail);
    		session.setAttribute("eventDates", sdList);
    	} else {
    		ArrayList<String> datetime = new DatetimeDateTable().getDates(id, senderEmail);
    		session.setAttribute("datetime", datetime);
    	}

    	// scheduleをrequestに格納
    	session.setAttribute("id", scheduleHM.get("id"));
    	session.setAttribute("eventName", scheduleHM.get("eventName"));

    	// jspを指定
    	String view = "/WEB-INF/view/user/decideschedule.jsp";
    	// リクエストをviewに飛ばす
    	RequestDispatcher dispatcher = request.getRequestDispatcher(view);

    	dispatcher.forward(request, response);
    }

}
