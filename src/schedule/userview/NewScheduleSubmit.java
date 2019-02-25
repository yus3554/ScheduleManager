package schedule.userview;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.tomcat.util.http.fileupload.FileItem;

import schedule.model.Schedule;
import schedule.model.ScheduleDate;
import schedule.model.ScheduleDateTable;
import schedule.model.ScheduleTable;
import schedule.model.SendMail;
import schedule.model.SessionConvert;
import schedule.model.TargetTable;
import schedule.model.Answer;
import schedule.model.AnswerTable;
import schedule.model.RequestAttachmentTable;
import schedule.model.NotifTable;
import schedule.model.RemindDateTable;

/**
 * Servlet implementation class NewScheduleSubmit
 */
@WebServlet("/NewScheduleSubmit")
public class NewScheduleSubmit extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public NewScheduleSubmit() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("utf-8");

		HttpSession session = request.getSession(false);

		// 現在の時刻をidとして登録
		LocalDateTime ldt = LocalDateTime.now();
		String id = ldt.toString();

		// DBにスケジュールを保存
		SessionConvert sts = new SessionConvert(id, session);
		Schedule schedule = sts.getSchedule();
		new ScheduleTable().insert(schedule);

		// 候補日程を保存
		new ScheduleDateTable().insert(schedule, (ArrayList<ScheduleDate>)session.getAttribute("eventDates"));
		// DBに対象者リストを保存
		Answer answer = sts.getAnswer();
		new AnswerTable().insert(answer, new ScheduleDateTable().getDateList(id, schedule.getSenderEmail()));

		// 添付ファイルをサーバー内に保存
		String path = getServletContext().getRealPath("data");
		String senderEmail = (String)session.getAttribute("email");
		int fileNum = (int)session.getAttribute("fileNum");
		for(int i = 0; i <= fileNum; i++) {
			String fileName = (String)session.getAttribute("fileName" + i);
			FileItem file = (FileItem)session.getAttribute("file" + i);
			new RequestAttachmentTable().insert(id, senderEmail, fileName, file.getInputStream());
		}

		// notifテーブルに通知を保存
		ArrayList<HashMap<String, String>> targetList = new TargetTable().getTargetList(schedule.getId(), schedule.getSenderEmail());
		HashMap<String, String> hm = new HashMap<String, String>();
		int listSize = targetList.size();
		String[] randomURL = new String[listSize];
		for(int i = 0; i < listSize; i++) {
			hm = targetList.get(i);
			randomURL[i] = hm.get("randomURL");
		}
		// sqlのnotifTimeがdatetime型なので、DateTimeFormetterでldtを変える
		String nowTime = ldt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		// 初回の通知なのでtypeは0
		new NotifTable().insert(randomURL, nowTime, 0);

		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd HH:mm");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		// 再送の通知
		ArrayList<String> remindDateTimes = (ArrayList<String>)session.getAttribute("remindDateTimes");
		String remindDateTime = "";
		for(int i = 0; i < remindDateTimes.size(); i++) {
			if(!remindDateTimes.get(i).equals("")) {
				// 再送の通知なのでtypeは1
				try {
					remindDateTime = sdf2.format(sdf1.parse(remindDateTimes.get(i)));
				} catch (ParseException e) {
					// TODO 自動生成された catch ブロック
					e.printStackTrace();
				}
				new NotifTable().insert(randomURL, remindDateTime, 1);
			}
		}

		// remindDatesに保存
		new RemindDateTable().insert(id, senderEmail, remindDateTimes);

		// 締め切り時のリマインダー
		if((boolean)session.getAttribute("isRemindDeadline")) {
			String deadline = (String)session.getAttribute("eventDeadline");
			String deadlineDateTime = "";
			try {
				deadlineDateTime = sdf2.format(sdf1.parse(deadline));
			} catch (ParseException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
			}
			// 締め切り時の通知なのでtypeは4
			new NotifTable().insert(randomURL, deadlineDateTime, 4);
		}

		// 調整者に通知
    	String subject = "[日程要求送信完了]" + schedule.getEventName();
    	String targetListStr = "";
    	for(HashMap<String, String> targetHM : targetList) {
    		targetListStr += targetHM.get("targetEmail") + "<br>";
    	}
    	String dateStr = "";
		for(ScheduleDate sd : new ScheduleDateTable().getDateList(id, schedule.getSenderEmail())) {
			dateStr += sd.toString();
		}
		String content = "<html><body><br>「" + schedule.getEventName() + "」の送信が完了しました。"
    			+ "<hr align=\"left\" width=\"55%\">"
				+ "<table border=\"1\" cellspacing=\"0\"><tr><th>イベント名</th><td>" + schedule.getEventName() + "</td></tr>"
				+ "<tr><th>イベント内容</th><td>" + schedule.getEventContent() + "</td></tr>"
				+ "<tr><th>対象者</th><td>" + targetListStr + "</td></tr>"
				+ "<tr><th>候補日程</th><td><table border=\"1\" cellspacing=\"0\">"
				+ "<tr><th>日付</th><td>1限</td><td>2限</td><td>3限</td><td>4限</td><td>5限</td></tr>" + dateStr + "</table></td></tr>"
				+ "<tr><th>締め切り</th><td>" + schedule.getEventDeadline() + "</td></tr>"
				+ "</table></body></html>";
    	new SendMail().send(subject, content, senderEmail);

		//新規スケジュールで使ったsession attributeを削除
		session.removeAttribute("eventName");
		session.removeAttribute("eventContent");
		session.removeAttribute("eventDates");
		session.removeAttribute("targetEmails");
		session.removeAttribute("eventDeadline");

		// jspを指定
		String view = "/WEB-INF/view/user/newschedulesubmit.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);
	}

}
