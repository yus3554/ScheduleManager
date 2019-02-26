package schedule.userview;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import schedule.model.NotifTable;
import schedule.model.ScheduleDate;
import schedule.model.ScheduleTable;
import schedule.model.SendMail;
import schedule.model.TargetTable;

/**
 * Servlet implementation class DecideScheduleSubmit
 */
@WebServlet("/RequestSchedules/DecideScheduleSubmit/*")
public class DecideScheduleSubmit extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public DecideScheduleSubmit() {
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
    	String senderEmail = (String)session.getAttribute("email");

    	// 取得したdateなどをnotifsテーブルに格納する
    	int dateType = (int)session.getAttribute("dateType");
    	String tempDecideDate = "";
    	ArrayList<String> decideDates = new ArrayList<>();

    	if(dateType == 1) {
    		ArrayList<ScheduleDate> sdList = (ArrayList<ScheduleDate>)session.getAttribute("eventDates");
    		int[][] date = (int[][])session.getAttribute("date");
    		for(int i = 0; i < sdList.size(); i++) {
        		for(int j = 0; j < 5; j++) {
        			if( date[i][j] == 1 ){
        				tempDecideDate += sdList.get(i).getDate() + " " + (j + 1) + "限";
        				decideDates.add(tempDecideDate);
        			}
        			tempDecideDate = "";
        		}
        	}
    	} else {
    		ArrayList<String> datetime = (ArrayList<String>)session.getAttribute("datetime");
    		int[] date = (int[])session.getAttribute("date");
    		for(int i = 0; i < datetime.size(); i++) {
        			if( date[i] == 1 ){
        				tempDecideDate += datetime.get(i) + "〜";
        				decideDates.add(tempDecideDate);
        			}
        			tempDecideDate = "";
        	}
    	}
    	// 備考
    	String note = (String)session.getAttribute("note");


    	// scheduletableに決定日時を格納
    	new ScheduleTable().updateDecideDate(id, senderEmail, decideDates, note);
    	// notiftableに通知を格納
    	// 今の時間を取得し、通知時間とする
    	LocalDateTime ldt = LocalDateTime.now();
    	String nowTime = ldt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    	// 対象者のrandomURLを取得
    	ArrayList<HashMap<String, String>> target = new TargetTable().getTargetList(id, senderEmail);
    	HashMap<String, String> targetHM = new HashMap<>();
    	String[] randomURLs = new String[target.size()];
    	for(int i = 0; i < target.size(); i++) {
    		targetHM = target.get(i);
    		randomURLs[i] = targetHM.get("randomURL");
    	}

    	// 要求者に決定完了メールを送る
    	HashMap<String, String>  scheduleHM = new ScheduleTable().getSchedule(id, senderEmail);
    	String subject = "[日時決定完了]" + scheduleHM.get("eventName");
    	String content = "<html><body><br>" + scheduleHM.get("eventName") + "の日時が決定が完了しました。"
    			+ "<br><br><hr align=\"left\" width=\"55%\"><br>"
				+ "[決定日時]<br>"
				+ scheduleHM.get("decideDate") + "<br><br>"
				+ note
				+ "<br><br><hr align=\"left\" width=\"55%\"><br>"
				+ "<table><tr><th>イベント名：</th><td>" + scheduleHM.get("eventName") + "</td></tr>"
				+ "<tr><th>イベント内容：</th><td>" + scheduleHM.get("eventContent") + "</td></tr>"
				+ "</table></body></html>";
    	new SendMail().send(subject, content, senderEmail);

    	// 日時を決定したので、リマインダーなど他の通知は消す
    	for(String url: randomURLs) {
    		new NotifTable().delete(url);
    	}

    	// 日時の決定通知をインサート
    	new NotifTable().insert(randomURLs, nowTime, 2);

		// jspを指定
    	String view = "/WEB-INF/view/user/decideschedulesubmit.jsp";
    	// リクエストをviewに飛ばす
    	RequestDispatcher dispatcher = request.getRequestDispatcher(view);

    	dispatcher.forward(request, response);
	}

}
