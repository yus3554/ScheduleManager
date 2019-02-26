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

import schedule.model.AnswerTable;
import schedule.model.DatetimeAnswerTable;
import schedule.model.DatetimeDateTable;
import schedule.model.ScheduleTable;
import schedule.model.TargetAttachmentTable;
import schedule.model.TargetTable;

/**
 * Servlet implementation class ClientAnswer
 */
@WebServlet("/ClientAnswer/*")
public class ClientAnswer extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ClientAnswer() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// urlからrandomURLを取得
		// 1文字目には"\"が入っているので2文字目からを代入
		String randomURL = request.getPathInfo().substring(1);
		request.setAttribute("randomURL", randomURL);

		// sessionを取得
		HttpSession session = request.getSession(false);

		HashMap<String, String> targetHM = new HashMap<>();
		targetHM = new TargetTable().getTarget(randomURL);

		String id = targetHM.get("id");
		String targetEmail = targetHM.get("targetEmail");
		String note = targetHM.get("note");
		String key = targetHM.get("key");

		request.setAttribute("id", id);
		request.setAttribute("targetEmail", targetEmail);
		request.setAttribute("note", note);
		request.setAttribute("key", key);

		request.setAttribute("isInput", targetHM.get("isInput"));
		request.setAttribute("sendDate", targetHM.get("sendDate"));

		// idとsenderEmailを入れてscheduleを取得
		HashMap<String, String> scheduleHM = new HashMap<String, String>();
		scheduleHM = new ScheduleTable().getSchedule(id, (String) session.getAttribute("email"));
		request.setAttribute("eventName", scheduleHM.get("eventName"));

		// 既にアップロードされた添付ファイルの名前を取得
		ArrayList<String> uploadFileNameList = new TargetAttachmentTable().getFileNames(randomURL);
		request.setAttribute("uploadFileNameList", uploadFileNameList);

		// arraylistでanswersを取得する
		// randomURLを使ってselect
		int dateType = Integer.parseInt(scheduleHM.get("dateType"));
		request.setAttribute("dateType", dateType);
		// scheduleListの数を取得
		int answersLength = 0;
		if( dateType == 1) {
			ArrayList<HashMap<String, String>> answers = new ArrayList<>();
			answers = new AnswerTable().getEmailAnswers(randomURL);
			answersLength = answers.size();

			HashMap<String, String> answerHM = new HashMap<>();

			// 0番目からrequestにスケジュールを格納
			for(int i = 0; i < answersLength; i++) {
				answerHM = answers.get(i);
				request.setAttribute("date" + i, answerHM.get("date"));
				request.setAttribute("first" + i, answerHM.get("first"));
				request.setAttribute("second" + i, answerHM.get("second"));
				request.setAttribute("third" + i, answerHM.get("third"));
				request.setAttribute("fourth" + i, answerHM.get("fourth"));
				request.setAttribute("fifth" + i, answerHM.get("fifth"));
			}
		} else {
			ArrayList<HashMap<String, String>> answers = new DatetimeAnswerTable().getEmailAnswers(randomURL);
			answersLength = answers.size();
			request.setAttribute("answers", answers);
		}

		// リストの長さをrequestに格納
		request.setAttribute("answersLength", answersLength);

		// jspを指定
		String view = "/WEB-INF/view/user/clientanswer.jsp";
		// リクエストをviewに飛ばす
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);

		dispatcher.forward(request, response);
	}

}
