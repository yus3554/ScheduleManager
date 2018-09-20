package schedule.userview;

import java.io.IOException;
import java.util.ArrayList;
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
 * Servlet implementation class RequestSchedules
 */
@WebServlet("/RequestSchedules")
public class RequestSchedules extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public RequestSchedules() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    	// sessionを取得
    	HttpSession session = request.getSession(false);

    	// 全てのscheduleをsenderEmailを使って取得
    	ArrayList<HashMap<String, String>> scheduleList = new ArrayList<>();
    	scheduleList = new ScheduleTable().getScheduleList((String) session.getAttribute("email"));

    	// scheduleListの数を取得
    	int listLength = scheduleList.size();

    	HashMap<String, String> hm = new HashMap<>();

    	// 0番目からrequestにスケジュールを格納
    	for(int i = 0; i < listLength; i++) {
    		hm = scheduleList.get(i);
    		request.setAttribute("id" + i, hm.get("id"));
    		request.setAttribute("eventName" + i, hm.get("eventName"));
    		request.setAttribute("eventContent" + i, hm.get("eventContent"));
    		request.setAttribute("eventStartDate" + i, hm.get("eventStartDate"));
    		request.setAttribute("eventEndDate" + i, hm.get("eventEndDate"));
    		request.setAttribute("eventDeadlineDate" + i, hm.get("eventDeadlineDate"));
    	}

    	// リストの長さをrequestに格納
    	request.setAttribute("listLength", listLength);

    	// jspを指定
    	String view = "/WEB-INF/view/user/schedulelist.jsp";
    	// リクエストをviewに飛ばす
    	RequestDispatcher dispatcher = request.getRequestDispatcher(view);

    	dispatcher.forward(request, response);
    }
}