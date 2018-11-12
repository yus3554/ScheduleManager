package schedule.answerview;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import schedule.model.AnswerTable;
import schedule.model.ScheduleTable;
import schedule.model.TargetTable;
import schedule.model.UserTable;

/**
 * Servlet implementation class AnswerPage
 */
@WebServlet("/AnswerPage/*")
public class AnswerPage extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AnswerPage() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(true);

		// randomURLを取得
		String randomURL = request.getPathInfo().substring(1);
		session.setAttribute("randomURL", randomURL);

		// 対象者の情報を取得
		HashMap<String, String> targetHM = new TargetTable().getTarget(randomURL);

		// idキーがあるならば回答ページを表示
		if(targetHM.containsKey("id")) {

			String senderEmail = targetHM.get("senderEmail");
			String targetEmail = targetHM.get("targetEmail");
			String note = targetHM.get("note");
			String id = targetHM.get("id");

			session.setAttribute("senderName", new UserTable().getName(senderEmail));
			session.setAttribute("targetEmail", targetEmail);
			session.setAttribute("note", note);
			session.setAttribute("isInput", targetHM.get("isInput"));

			// イベント内容を取得
			HashMap<String, String> scheduleHM = new ScheduleTable().getSchedule(id, senderEmail);
			session.setAttribute("eventName", scheduleHM.get("eventName"));
			session.setAttribute("eventContent", scheduleHM.get("eventContent"));

			// 対象者全てをidとsenderEmailを使って取得
			ArrayList<HashMap<String, String>> targetList = new TargetTable().getTargetList(id, (String)session.getAttribute("email"));

			// 要求者が知らせるようにしていれば、回答状況を送る
			boolean isInputInform = scheduleHM.get("isInputInform").equals("1");
			request.setAttribute("isInputInform", isInputInform);
			if (isInputInform) {
				// 回答済の人数をカウント
				int inputCount = 0;
				for(Iterator<HashMap<String, String>> i = targetList.iterator(); i.hasNext();) {
					inputCount += Integer.parseInt((String)i.next().get("isInput")) == 0 ? 0 : 1;
				}
				request.setAttribute("targetNum", targetList.size());
				request.setAttribute("inputCount", inputCount);
			}

			ArrayList<HashMap<String, String>> answers = new ArrayList<>();
			answers = new AnswerTable().getEmailAnswers(randomURL);

			// scheduleListの数を取得
			int answersLength = answers.size();

			HashMap<String, String> answerHM = new HashMap<>();

			// 0番目からrequestにスケジュールを格納
			for(int i = 0; i < answersLength; i++) {
				answerHM = answers.get(i);
				request.setAttribute("isInput", answerHM.get("isInput"));
				request.setAttribute("date" + i, answerHM.get("date"));
				request.setAttribute("first" + i, answerHM.get("first"));
				request.setAttribute("second" + i, answerHM.get("second"));
				request.setAttribute("third" + i, answerHM.get("third"));
				request.setAttribute("fourth" + i, answerHM.get("fourth"));
				request.setAttribute("fifth" + i, answerHM.get("fifth"));
			}

			// リストの長さをsessionに格納
			session.setAttribute("answersLength", answersLength);
			// jspを指定
	    	String view = "/WEB-INF/view/answer/answerpage.jsp";

	    	// リクエストをviewに飛ばす
	    	RequestDispatcher dispatcher = request.getRequestDispatcher(view);

	    	dispatcher.forward(request, response);
		} else {
			// 回答ページがないのでエラーページを表示
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "見つかりません");
		}
    }
}
