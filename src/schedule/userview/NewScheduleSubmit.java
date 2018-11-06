package schedule.userview;

import java.io.File;
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

import org.apache.tomcat.util.http.fileupload.FileItem;

import schedule.model.Schedule;
import schedule.model.ScheduleTable;
import schedule.model.SessionConvert;
import schedule.model.TargetTable;
import schedule.model.Answer;
import schedule.model.AnswerTable;
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
		if(schedule.getFileName() != null) {
			FileItem file = (FileItem)session.getAttribute("file");
			try {
				file.write(new File(path + "/" + id + "#" + schedule.getFileName()));
			} catch (Exception e) {
				e.printStackTrace();
			}
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
		String deadline = (String)session.getAttribute("eventDeadlineDate");
		LocalDate deadlineDate = LocalDate.parse(deadline, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		LocalDateTime deadlineDateTime = deadlineDate.atTime(0, 0, 0);
		// とりあえず1日前にする
		LocalDateTime notifTime = deadlineDateTime.minusDays(1);
		// 再送の通知なのでtypeは1
		new NotifTable().insert(randomURL, notifTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), 1);


		//新規スケジュールで使ったsession attributeを削除
		session.removeAttribute("eventName");
		session.removeAttribute("eventContent");
		session.removeAttribute("eventStartDate");
		session.removeAttribute("eventEndDate");
		session.removeAttribute("targetEmails");
		session.removeAttribute("eventDeadlineDate");

		// jspを指定
		String view = "/WEB-INF/view/user/newschedulesubmit.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);
	}

}
