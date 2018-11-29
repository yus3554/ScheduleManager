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

import schedule.model.ScheduleDate;
import schedule.model.ScheduleDateTable;
import schedule.model.ScheduleTable;
import schedule.model.TargetTable;

/**
 * Servlet implementation class ScheduleDeleteConfirm
 */
@WebServlet("/RequestSchedules/DeleteConfirm/*")
public class ScheduleDeleteConfirm extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ScheduleDeleteConfirm() {
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
		ArrayList<ScheduleDate> sdList = new ScheduleDateTable().getDateList(id, senderEmail);

		// scheduleをrequestに格納
		request.setAttribute("id", id);
		request.setAttribute("eventName", scheduleHM.get("eventName"));
		request.setAttribute("eventContent", scheduleHM.get("eventContent"));
		request.setAttribute("eventDeadline", scheduleHM.get("eventDeadline"));
		request.setAttribute("eventDates", sdList);

		// 対象者全てをidとsenderEmailを使って取得
		ArrayList<HashMap<String, String>> targetList = new ArrayList<>();
		targetList = new TargetTable().getTargetList(id, (String)session.getAttribute("email"));

		// scheduleListの数を取得
		int targetListLength = targetList.size();

		HashMap<String, String> targetHM = new HashMap<>();

		// 0番目からrequestにスケジュールを格納
		for(int i = 0; i < targetListLength; i++) {
			targetHM = targetList.get(i);
			request.setAttribute("targetEmail" + i, targetHM.get("targetEmail"));
			request.setAttribute("randomURL" + i, targetHM.get("randomURL"));
			request.setAttribute("isInput" + i, targetHM.get("isInput"));
		}

		// リストの長さをrequestに格納
		request.setAttribute("targetListLength", targetListLength);

		// jspを指定
		String view = "/WEB-INF/view/user/scheduledeleteconfirm.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);
	}
}
