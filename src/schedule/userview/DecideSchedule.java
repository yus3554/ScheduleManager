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

import org.apache.commons.lang3.ArrayUtils;

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
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
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

		ArrayList<ScheduleDate> sdList = new ArrayList<>();
		ArrayList<String> datetime = new ArrayList<>();
    	if(dateType == 1) {
    		sdList = new ScheduleDateTable().getDateList(id, senderEmail);
    		session.setAttribute("eventDates", sdList);
    	} else {
    		datetime = new DatetimeDateTable().getDates(id, senderEmail);
    		session.setAttribute("datetime", datetime);
    	}

    	// scheduleをrequestに格納
    	session.setAttribute("id", scheduleHM.get("id"));
    	session.setAttribute("eventName", scheduleHM.get("eventName"));

    	// 決定日時の取得
    	String decideDate = scheduleHM.get("decideDate");
    	request.setAttribute("isDecideDate", decideDate != null);
    	if( decideDate != null) {
    		String[] decideDateArray = decideDate.split(",");
    		if(dateType == 1) {
    			ArrayList<Integer> dateDecideIndex = new ArrayList<>();
    			ArrayList<Integer> timeDecideIndex = new ArrayList<>();
    			for(int i = 0; i < decideDateArray.length; i++) {
    				String date = (decideDateArray[i].split(" "))[0];
    				int dateIndex = 0;
    				for(int j = 0; j < sdList.size(); j++) {
    					if(sdList.get(j).getDate().equals(date)) {
    						dateIndex = j;
    						break;
    					}
    				}
    				int time = Integer.parseInt((decideDateArray[i].split(" "))[1].substring(0, 1));
    				dateDecideIndex.add(dateIndex);
    				timeDecideIndex.add(time - 1);
    			}
    			request.setAttribute("dateDecideIndex", dateDecideIndex);
    			request.setAttribute("timeDecideIndex", timeDecideIndex);
    		} else {
    			ArrayList<Integer> dateDecideIndex = new ArrayList<>();
    			for(int i = 0; i < decideDateArray.length; i++) {
    				dateDecideIndex.add(datetime.indexOf(decideDateArray[i].replace("〜", "")));
    			}
    			request.setAttribute("dateDecideIndex", dateDecideIndex);
    		}
    	}

    	// 色付けを取得
    	String[] colors = request.getParameterValues("color");
    	ArrayList<Integer> colorsInt = new ArrayList<>();
    	for(String s : colors) {
    		colorsInt.add(Integer.parseInt(s));
    	}
    	request.setAttribute("colors", colorsInt);

    	// jspを指定
    	String view = "/WEB-INF/view/user/decideschedule.jsp";
    	// リクエストをviewに飛ばす
    	RequestDispatcher dispatcher = request.getRequestDispatcher(view);

    	dispatcher.forward(request, response);
	}

}
