package schedule.userview;

import java.io.File;
import java.io.IOException;
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
import schedule.model.ScheduleTable;
import schedule.model.SessionConvert;
import schedule.model.TargetTable;
import schedule.model.Answer;
import schedule.model.AnswerTable;
import schedule.model.RequestAttachmentTable;
import schedule.model.NotifTable;

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
		// DBに対象者リストを保存
		Answer answer = sts.getAnswer();
		new AnswerTable().insert(answer);

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

		// 再送の通知
		String deadline = (String)session.getAttribute("eventDeadline");
		String deadlineDateStr = deadline.split(" ")[0];
		String deadlineDateTimeStr = deadline.split(" ")[1];
		LocalDate deadlineDate = LocalDate.parse(deadlineDateStr, DateTimeFormatter.ofPattern("yyyy/MM/dd"));
		LocalDateTime deadlineDateTime =
				deadlineDate.atTime(Integer.parseInt(deadlineDateTimeStr.split(":")[0]), Integer.parseInt(deadlineDateTimeStr.split(":")[1]), 0);
		// 再送日程を取得
		ArrayList<Integer> remindDates = (ArrayList<Integer>)session.getAttribute("remindDates");
		ArrayList<Integer> remindTimes = (ArrayList<Integer>)session.getAttribute("remindTimes");
		for(int i = 0; i < remindDates.size(); i++) {
			// 指定したリマインダー日時を設定
			LocalDateTime notifTime = deadlineDateTime.minusDays(remindDates.get(i));
			notifTime = notifTime.with(LocalTime.of(remindTimes.get(i), 0));
			// notifTimeとldtを比べてnotifTimeが前なら通知は行わない
			if(ldt.isBefore(notifTime)) {
				// 再送の通知なのでtypeは1
				new NotifTable().insert(randomURL, notifTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), 1);
			}
		}

		//新規スケジュールで使ったsession attributeを削除
		session.removeAttribute("eventName");
		session.removeAttribute("eventContent");
		session.removeAttribute("eventStartDate");
		session.removeAttribute("eventEndDate");
		session.removeAttribute("targetEmails");
		session.removeAttribute("eventDeadline");

		// jspを指定
		String view = "/WEB-INF/view/user/newschedulesubmit.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);
	}

}
