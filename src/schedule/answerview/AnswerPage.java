package schedule.answerview;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

import schedule.model.AnswerTable;
import schedule.model.DatetimeAnswerTable;
import schedule.model.DeleteScheduleTable;
import schedule.model.NotifTable;
import schedule.model.RequestAttachmentTable;
import schedule.model.ScheduleTable;
import schedule.model.TargetAttachmentTable;
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


		// 削除済みならそのページを表示
		String deleteTitle = new DeleteScheduleTable().getDeleteTitle(randomURL);
		if( deleteTitle != null ) {
			request.setAttribute("deleteTitle", deleteTitle);
			// jspを指定
			String view = "/WEB-INF/view/answer/deletepage.jsp";
			RequestDispatcher dispatcher = request.getRequestDispatcher(view);

			dispatcher.forward(request, response);
		}
		// idキーがあるならば回答ページを表示
		else if(targetHM.containsKey("id")) {
			String senderEmail = targetHM.get("senderEmail");
			request.setAttribute("senderEmail", senderEmail);
			String targetEmail = targetHM.get("targetEmail");
			String note = targetHM.get("note");
			if(note != null) {
				note = note.replace("<br>", "\n");
			}
			String id = targetHM.get("id");
			request.setAttribute("id", id);
			String sendDate = targetHM.get("sendDate");

			request.setAttribute("senderName", new UserTable().getName(senderEmail));
			request.setAttribute("targetEmail", targetEmail);
			request.setAttribute("note", note);
			request.setAttribute("isInput", targetHM.get("isInput"));
			request.setAttribute("sendDate", sendDate);

			// イベント内容を取得
			HashMap<String, String> scheduleHM = new ScheduleTable().getSchedule(id, senderEmail);
			request.setAttribute("eventName", scheduleHM.get("eventName"));
			request.setAttribute("eventContent", scheduleHM.get("eventContent"));
			request.setAttribute("eventDeadline", scheduleHM.get("eventDeadline"));

			// 日程調整者からの添付ファイルを取得
			ArrayList<String> requestFileNameList = new RequestAttachmentTable().getFileNames(id, senderEmail);
			request.setAttribute("requestFileNameList", requestFileNameList);
			boolean isRequestFile = false;
			if (requestFileNameList != null && requestFileNameList.size() != 0) {
				isRequestFile = true;
			}
			request.setAttribute("isRequestFile", isRequestFile);

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

			// 既にアップロードされた添付ファイルの名前を取得
			ArrayList<String> uploadFileNameList = new TargetAttachmentTable().getFileNames(randomURL);
			request.setAttribute("uploadFileNameList", uploadFileNameList);

			int dateType = Integer.parseInt(scheduleHM.get("dateType"));
			session.setAttribute("dateType", dateType);

			ArrayList<HashMap<String, String>> answers = new ArrayList<>();
			int answersLength = 0;

			if( dateType == 1 ) {
				answers = new AnswerTable().getEmailAnswers(randomURL);

				// scheduleListの数を取得
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
				answers = new DatetimeAnswerTable().getEmailAnswers(randomURL);

				answersLength = answers.size();

				HashMap<String, String> answerHM = new HashMap<>();

				// 0番目からrequestにスケジュールを格納
				for(int i = 0; i < answersLength; i++) {
					answerHM = answers.get(i);
					request.setAttribute("date" + i, answerHM.get("date"));
					request.setAttribute("answer" + i, answerHM.get("answer"));
				}
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		request.setCharacterEncoding("utf-8");

		DiskFileItemFactory factory = new DiskFileItemFactory();
    	ServletFileUpload sfu = new ServletFileUpload(factory);
    	sfu.setSizeMax(5 * 1000 * 1024);
		sfu.setFileSizeMax(10 * 1000 * 1024);

		String randomURL = (String)session.getAttribute("randomURL");

		//int answersLength = (int)session.getAttribute("answersLength");

		String fileName = "";
		ArrayList<String> date = new ArrayList<>();
		ArrayList<String> first = new ArrayList<>();
		ArrayList<String> second = new ArrayList<>();
		ArrayList<String> third = new ArrayList<>();
		ArrayList<String> fourth = new ArrayList<>();
		ArrayList<String> fifth = new ArrayList<>();
		ArrayList<String> answer = new ArrayList<>();
		String note = "";

		int fileNum = 0;
		try {
			List list = sfu.parseRequest(new ServletRequestContext(request));
			Iterator iterator = list.iterator();

			while(iterator.hasNext()){
				FileItem item = (FileItem)iterator.next();

				// アップロードされたファイルのみ対象の処理
				if (!item.isFormField()){
					fileName = item.getName();
					if ((fileName != null) && (!fileName.equals(""))) {
						fileName = (new File(fileName)).getName();
						new TargetAttachmentTable().insert(randomURL, fileName, item.getInputStream());
					}
				} else {
					String name = item.getFieldName();
					String value = item.getString("utf-8");
					switch(name) {
					case "date[]":
						date.add(value);
						break;
					case "first[]":
						first.add(value);
						break;
					case "second[]":
						second.add(value);
						break;
					case "third[]":
						third.add(value);
						break;
					case "fourth[]":
						fourth.add(value);
						break;
					case "fifth[]":
						fifth.add(value);
						break;
					case "answer[]":
						answer.add(value);
						break;
					case "note":
						note = value;
						break;
					default:
					}
				}
			}
		}catch (FileUploadException e) {
    		e.printStackTrace();
    	}catch (Exception e) {
    		  e.printStackTrace();
    	}

		note = note.replace("\n", "");
		note = note.replace("\r", "<br>");
		note = note.replace("\r\n", "<br>");

		// dbと接続して上のデータを使ってupdateする
		if((int)session.getAttribute("dateType") == 1) {
			new AnswerTable().update(randomURL, date, first, second, third, fourth, fifth);
		} else {
			new DatetimeAnswerTable().update(randomURL, date, answer);
		}

		LocalDateTime ldt = LocalDateTime.now();

		new TargetTable().isInputUpdate(randomURL, note, ldt.toString());

		// 全員回答しているかの確認
		// していたらnotifTableに追加
		// randomURLから対象者を取得し、スケジュールのidとsenderEmailを取得
		HashMap<String, String> targetHM = new TargetTable().getTarget(randomURL);
		String id = targetHM.get("id");
		String senderEmail = targetHM.get("senderEmail");
		// idとsenderEmailから対象者リストを取得
		ArrayList<HashMap<String, String>> targetList = new TargetTable().getTargetList(id, senderEmail);
		int inputNum = 0;
		// リストをforし、入力してあったらinputNumを1増やす
		for(HashMap<String, String> hm : targetList) {
			if(Integer.parseInt(hm.get("isInput")) == 1) {
				inputNum++;
			}
		}
		// 全員回答していたら通知
		if(targetList.size() == inputNum) {
			String nowTime = ldt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
			new NotifTable().insert(randomURL, nowTime, 3);
		}


		doGet(request, response);
	}
}
